from __future__ import annotations

import argparse
from dataclasses import dataclass
from pathlib import Path

import matplotlib.pyplot as plt
import pandas as pd
import torch
import torch.nn.functional as F
from sklearn.metrics import classification_report, confusion_matrix
from torch import nn
from torch.optim import Adam, AdamW
from torch.optim.lr_scheduler import StepLR
from torch.utils.data import DataLoader, Dataset, WeightedRandomSampler

from jravan_dataframe_extractor import JravanDataFrameExtractor
from win5_resnet_model import build_win5_resnet_model


@dataclass
class TrainConfig:
    database_name: str | None = None
    table_name: str = "race_results"
    race_date_col: str = "race_date"
    target_col: str = "target_class"
    min_race_date: str = "2024-01-01"
    batch_size: int = 256
    epochs: int = 30
    learning_rate: float = 1e-3
    weight_decay: float = 1e-4
    optimizer_name: str = "adamw"
    scheduler_step_size: int = 10
    scheduler_gamma: float = 0.5
    loss_name: str = "cross_entropy"
    focal_gamma: float = 2.0
    validation_ratio: float = 0.2
    years: int = 5
    device: str = "cuda" if torch.cuda.is_available() else "cpu"
    use_class_weights: bool = True
    use_weighted_sampler: bool = False
    disable_loss_weights_with_sampler: bool = True
    input_dim: int = 128
    num_classes: int = 18
    hidden_dim: int = 256
    num_blocks: int = 4
    dropout: float = 0.1
    standardize_features: bool = True
    early_stopping_patience: int = 5
    model_output_path: str = "models/algo5_best.pth"
    learning_curve_path: str = "logs/learning_curve.png"
    focus_class: int = 1
    zero_feature_columns: list[str] | None = None


@dataclass
class FeatureScaler:
    mean: pd.Series
    std: pd.Series

    def transform(self, dataframe: pd.DataFrame, feature_columns: list[str]) -> pd.DataFrame:
        transformed = dataframe.copy()
        transformed[feature_columns] = (transformed[feature_columns] - self.mean) / self.std
        return transformed


@dataclass
class EarlyStopping:
    patience: int = 5
    min_delta: float = 0.0
    best_score: float = float("-inf")
    counter: int = 0
    should_stop: bool = False

    def step(self, score: float) -> bool:
        if score > self.best_score + self.min_delta:
            self.best_score = score
            self.counter = 0
            return True

        self.counter += 1
        if self.counter >= self.patience:
            self.should_stop = True
        return False


class Win5Dataset(Dataset):
    def __init__(self, features: torch.Tensor, targets: torch.Tensor) -> None:
        if features.ndim != 2:
            raise ValueError("features は [件数, 特徴量数] の2次元テンソルを想定しています")
        if targets.ndim != 1:
            raise ValueError("targets は [件数] の1次元テンソルを想定しています")
        if len(features) != len(targets):
            raise ValueError("features と targets の件数が一致していません")

        self.features = features
        self.targets = targets

    def __len__(self) -> int:
        return len(self.targets)

    def __getitem__(self, index: int) -> tuple[torch.Tensor, torch.Tensor]:
        return self.features[index], self.targets[index]


class FocalLoss(nn.Module):
    def __init__(self, gamma: float = 2.0, alpha: torch.Tensor | None = None) -> None:
        super().__init__()
        self.gamma = gamma
        self.alpha = alpha

    def forward(self, logits: torch.Tensor, targets: torch.Tensor) -> torch.Tensor:
        cross_entropy = F.cross_entropy(logits, targets, reduction="none", weight=self.alpha)
        probabilities = torch.softmax(logits, dim=1)
        true_class_probabilities = probabilities.gather(1, targets.unsqueeze(1)).squeeze(1)
        focal_factor = (1.0 - true_class_probabilities).pow(self.gamma)
        return (focal_factor * cross_entropy).mean()


def parse_feature_columns(feature_columns_arg: str | None, input_dim: int) -> list[str]:
    if feature_columns_arg:
        return [column.strip() for column in feature_columns_arg.split(",") if column.strip()]
    return [f"feature_{index}" for index in range(input_dim)]


def validate_training_dataframe(
    dataframe: pd.DataFrame,
    feature_columns: list[str],
    target_col: str,
    num_classes: int,
) -> pd.DataFrame:
    required_columns = set(feature_columns + [target_col])
    missing_columns = required_columns.difference(dataframe.columns)
    if missing_columns:
        missing = ", ".join(sorted(missing_columns))
        raise KeyError(f"学習に必要な列が不足しています: {missing}")

    validated = dataframe.copy()
    for column in feature_columns:
        validated[column] = pd.to_numeric(validated[column], errors="coerce")

    validated = validated.dropna(subset=feature_columns + [target_col]).copy()
    validated[target_col] = pd.to_numeric(validated[target_col], errors="raise").astype("int64")

    invalid_targets = validated.loc[
        ~validated[target_col].between(0, num_classes - 1), target_col
    ]
    if not invalid_targets.empty:
        raise ValueError("target_col は 0 から 17 のクラスIDを想定しています")

    return validated


def ensure_output_directories(config: TrainConfig) -> None:
    Path(config.model_output_path).parent.mkdir(parents=True, exist_ok=True)
    Path(config.learning_curve_path).parent.mkdir(parents=True, exist_ok=True)


def apply_zero_feature_columns(dataframe: pd.DataFrame, zero_feature_columns: list[str] | None) -> pd.DataFrame:
    if not zero_feature_columns:
        return dataframe

    transformed = dataframe.copy()
    existing_columns = [column for column in zero_feature_columns if column in transformed.columns]
    transformed[existing_columns] = 0.0
    return transformed


def fit_feature_scaler(dataframe: pd.DataFrame, feature_columns: list[str]) -> FeatureScaler:
    mean = dataframe[feature_columns].mean()
    std = dataframe[feature_columns].std(ddof=0)
    std = std.replace(0.0, 1.0).fillna(1.0)
    return FeatureScaler(mean=mean, std=std)


def split_train_validation(
    dataframe: pd.DataFrame,
    validation_ratio: float,
    race_date_col: str,
) -> tuple[pd.DataFrame, pd.DataFrame]:
    if not 0.0 < validation_ratio < 1.0:
        raise ValueError("validation_ratio は 0 と 1 の間で指定してください")

    sorted_dataframe = dataframe.sort_values(race_date_col).reset_index(drop=True)
    validation_size = max(1, int(len(sorted_dataframe) * validation_ratio))
    if validation_size >= len(sorted_dataframe):
        raise ValueError("Validation データが大きすぎます。学習データが残るように調整してください")

    train_dataframe = sorted_dataframe.iloc[:-validation_size].reset_index(drop=True)
    validation_dataframe = sorted_dataframe.iloc[-validation_size:].reset_index(drop=True)
    return train_dataframe, validation_dataframe


def dataframe_to_dataset(
    dataframe: pd.DataFrame,
    feature_columns: list[str],
    target_col: str,
) -> Win5Dataset:
    features = torch.tensor(dataframe[feature_columns].to_numpy(dtype="float32"), dtype=torch.float32)
    targets = torch.tensor(dataframe[target_col].to_numpy(dtype="int64"), dtype=torch.long)
    return Win5Dataset(features=features, targets=targets)


def build_dataloaders(
    dataframe: pd.DataFrame,
    feature_columns: list[str],
    target_col: str,
    race_date_col: str,
    batch_size: int,
    validation_ratio: float,
    standardize_features: bool,
    use_weighted_sampler: bool,
) -> tuple[DataLoader, DataLoader, pd.DataFrame, pd.DataFrame, FeatureScaler | None]:
    train_dataframe, validation_dataframe = split_train_validation(
        dataframe=dataframe,
        validation_ratio=validation_ratio,
        race_date_col=race_date_col,
    )

    scaler = None
    if standardize_features:
        scaler = fit_feature_scaler(train_dataframe, feature_columns)
        train_dataframe = scaler.transform(train_dataframe, feature_columns)
        validation_dataframe = scaler.transform(validation_dataframe, feature_columns)

    train_dataset = dataframe_to_dataset(
        dataframe=train_dataframe,
        feature_columns=feature_columns,
        target_col=target_col,
    )
    validation_dataset = dataframe_to_dataset(
        dataframe=validation_dataframe,
        feature_columns=feature_columns,
        target_col=target_col,
    )

    train_loader_kwargs: dict[str, object] = {
        "batch_size": batch_size,
        "drop_last": False,
    }
    if use_weighted_sampler:
        sample_weights = build_sample_weights(train_dataframe[target_col], targets_tensor=train_dataset.targets)
        train_loader_kwargs["sampler"] = WeightedRandomSampler(
            weights=sample_weights,
            num_samples=len(sample_weights),
            replacement=True,
        )
    else:
        train_loader_kwargs["shuffle"] = True

    train_loader = DataLoader(train_dataset, **train_loader_kwargs)
    validation_loader = DataLoader(validation_dataset, batch_size=batch_size, shuffle=False, drop_last=False)
    return train_loader, validation_loader, train_dataframe, validation_dataframe, scaler


def build_class_weights(targets: pd.Series, num_classes: int) -> torch.Tensor:
    counts = torch.bincount(torch.tensor(targets.to_numpy(dtype="int64")), minlength=num_classes).float()
    counts = torch.where(counts == 0, torch.ones_like(counts), counts)
    weights = counts.sum() / (num_classes * counts)
    return weights / weights.mean()


def build_sample_weights(targets: pd.Series, targets_tensor: torch.Tensor | None = None) -> torch.Tensor:
    counts = targets.value_counts().sort_index()
    class_weights = {int(class_id): 1.0 / float(count) for class_id, count in counts.items() if count > 0}

    if targets_tensor is None:
        target_values = torch.tensor(targets.to_numpy(dtype="int64"), dtype=torch.long)
    else:
        target_values = targets_tensor.to(dtype=torch.long)

    weights = [class_weights[int(class_id)] for class_id in target_values.tolist()]
    return torch.tensor(weights, dtype=torch.double)


def build_loss_function(
    loss_name: str,
    class_weights: torch.Tensor | None,
    focal_gamma: float,
    device: torch.device,
) -> nn.Module:
    if class_weights is not None:
        class_weights = class_weights.to(device)

    if loss_name == "cross_entropy":
        return nn.CrossEntropyLoss(weight=class_weights)
    if loss_name == "focal":
        return FocalLoss(gamma=focal_gamma, alpha=class_weights)
    raise ValueError(f"未対応の loss_name です: {loss_name}")


def build_optimizer(model: nn.Module, config: TrainConfig):
    if config.optimizer_name == "adam":
        return Adam(model.parameters(), lr=config.learning_rate, weight_decay=config.weight_decay)
    if config.optimizer_name == "adamw":
        return AdamW(model.parameters(), lr=config.learning_rate, weight_decay=config.weight_decay)
    raise ValueError(f"未対応の optimizer_name です: {config.optimizer_name}")


def compute_topk_accuracy(logits: torch.Tensor, targets: torch.Tensor, k: int) -> float:
    topk_indices = torch.topk(logits, k=k, dim=1).indices
    matches = topk_indices.eq(targets.unsqueeze(1)).any(dim=1)
    return matches.float().mean().item()


def compute_binary_f1(true_positive: float, false_positive: float, false_negative: float) -> float:
    precision_denominator = true_positive + false_positive
    recall_denominator = true_positive + false_negative
    precision = true_positive / precision_denominator if precision_denominator else 0.0
    recall = true_positive / recall_denominator if recall_denominator else 0.0
    f1_denominator = precision + recall
    return 2.0 * precision * recall / f1_denominator if f1_denominator else 0.0


def train_one_epoch(
    model: nn.Module,
    loader: DataLoader,
    criterion: nn.Module,
    optimizer: torch.optim.Optimizer,
    device: torch.device,
) -> float:
    model.train()
    total_loss = 0.0
    total_samples = 0

    for features, targets in loader:
        features = features.to(device)
        targets = targets.to(device)

        optimizer.zero_grad(set_to_none=True)
        logits = model(features)
        loss = criterion(logits, targets)
        loss.backward()
        optimizer.step()

        batch_size = features.size(0)
        total_loss += loss.item() * batch_size
        total_samples += batch_size

    return total_loss / max(total_samples, 1)


@torch.no_grad()
def evaluate(
    model: nn.Module,
    loader: DataLoader,
    criterion: nn.Module,
    device: torch.device,
    focus_class: int,
) -> dict[str, float]:
    model.eval()
    total_loss = 0.0
    total_samples = 0
    total_correct = 0.0
    total_top3 = 0.0
    focus_true_positive = 0.0
    focus_false_positive = 0.0
    focus_false_negative = 0.0

    for features, targets in loader:
        features = features.to(device)
        targets = targets.to(device)

        logits = model(features)
        loss = criterion(logits, targets)
        predictions = torch.argmax(logits, dim=1)

        batch_size = features.size(0)
        total_loss += loss.item() * batch_size
        total_correct += (predictions == targets).float().sum().item()
        total_top3 += compute_topk_accuracy(logits, targets, k=3) * batch_size
        total_samples += batch_size

        focus_true_positive += ((predictions == focus_class) & (targets == focus_class)).float().sum().item()
        focus_false_positive += ((predictions == focus_class) & (targets != focus_class)).float().sum().item()
        focus_false_negative += ((predictions != focus_class) & (targets == focus_class)).float().sum().item()

    return {
        "loss": total_loss / max(total_samples, 1),
        "accuracy": total_correct / max(total_samples, 1),
        "top3_accuracy": total_top3 / max(total_samples, 1),
        "focus_class_f1": compute_binary_f1(
            true_positive=focus_true_positive,
            false_positive=focus_false_positive,
            false_negative=focus_false_negative,
        ),
    }


@torch.no_grad()
def collect_predictions(
    model: nn.Module,
    loader: DataLoader,
    device: torch.device,
) -> tuple[list[int], list[int]]:
    model.eval()
    all_targets: list[int] = []
    all_predictions: list[int] = []

    for features, targets in loader:
        features = features.to(device)
        logits = model(features)
        predictions = torch.argmax(logits, dim=1).cpu().tolist()
        all_predictions.extend(predictions)
        all_targets.extend(targets.tolist())

    return all_targets, all_predictions


def log_validation_analysis(
    y_true: list[int],
    y_pred: list[int],
    num_classes: int,
    focus_class: int,
) -> None:
    labels = list(range(num_classes))
    matrix = confusion_matrix(y_true, y_pred, labels=labels)
    report = classification_report(
        y_true,
        y_pred,
        labels=labels,
        zero_division=0,
        digits=4,
    )

    print("validation_confusion_matrix=")
    print(matrix)
    print("validation_classification_report=")
    print(report)

    if 0 <= focus_class < num_classes:
        true_positive = matrix[focus_class, focus_class]
        predicted_positive = matrix[:, focus_class].sum()
        actual_positive = matrix[focus_class, :].sum()
        precision = true_positive / predicted_positive if predicted_positive else 0.0
        recall = true_positive / actual_positive if actual_positive else 0.0
        f1 = compute_binary_f1(
            true_positive=float(true_positive),
            false_positive=float(predicted_positive - true_positive),
            false_negative=float(actual_positive - true_positive),
        )
        print(
            "focus_class={focus_class} precision={precision:.4f} recall={recall:.4f} f1={f1:.4f}".format(
                focus_class=focus_class,
                precision=precision,
                recall=recall,
                f1=f1,
            )
        )


def save_learning_curve(history: dict[str, list[float]], output_path: str) -> None:
    epochs = range(1, len(history["train_loss"]) + 1)
    figure, axes = plt.subplots(1, 2, figsize=(12, 5))

    axes[0].plot(epochs, history["train_loss"], label="train_loss")
    axes[0].plot(epochs, history["val_loss"], label="val_loss")
    axes[0].set_title("Loss")
    axes[0].set_xlabel("Epoch")
    axes[0].set_ylabel("Loss")
    axes[0].legend()

    axes[1].plot(epochs, history["val_accuracy"], label="val_accuracy")
    axes[1].plot(epochs, history["val_top3_accuracy"], label="val_top3_accuracy")
    axes[1].plot(epochs, history["val_focus_class_f1"], label="val_focus_class_f1")
    axes[1].set_title("Validation Accuracy")
    axes[1].set_xlabel("Epoch")
    axes[1].set_ylabel("Score")
    axes[1].legend()

    figure.tight_layout()
    figure.savefig(output_path, dpi=150, bbox_inches="tight")
    plt.close(figure)


def load_dataframe_from_mariadb(
    config: TrainConfig,
    feature_columns: list[str],
    env_path: str = ".env",
) -> pd.DataFrame:
    extractor = JravanDataFrameExtractor(env_path=env_path, database_name=config.database_name)
    try:
        dataframe = extractor.fetch_table_dataframe(
            table_name=config.table_name,
            years=config.years,
            race_date_col=config.race_date_col,
        )
    finally:
        extractor.close()

    dataframe[config.race_date_col] = pd.to_datetime(dataframe[config.race_date_col], errors="coerce")
    minimum_race_date = pd.Timestamp(config.min_race_date)
    dataframe = dataframe.loc[dataframe[config.race_date_col] >= minimum_race_date].copy()
    dataframe = apply_zero_feature_columns(dataframe, config.zero_feature_columns)

    return validate_training_dataframe(
        dataframe=dataframe,
        feature_columns=feature_columns,
        target_col=config.target_col,
        num_classes=config.num_classes,
    )


def train_model(
    dataframe: pd.DataFrame,
    feature_columns: list[str],
    config: TrainConfig,
) -> nn.Module:
    if len(feature_columns) != config.input_dim:
        raise ValueError(
            f"feature_columns の数が input_dim と一致しません: {len(feature_columns)} != {config.input_dim}"
        )

    ensure_output_directories(config)
    device = torch.device(config.device)
    loss_weights_applied = config.use_class_weights and not (
        config.use_weighted_sampler and config.disable_loss_weights_with_sampler
    )
    print(
        "train_config batch_size={batch_size} device={device} learning_rate={learning_rate} hidden_dim={hidden_dim} num_blocks={num_blocks} dropout={dropout} weighted_sampler={weighted_sampler} class_weights={class_weights} disable_loss_weights_with_sampler={disable_loss_weights_with_sampler} loss_weights_applied={loss_weights_applied}".format(
            batch_size=config.batch_size,
            device=config.device,
            learning_rate=config.learning_rate,
            hidden_dim=config.hidden_dim,
            num_blocks=config.num_blocks,
            dropout=config.dropout,
            weighted_sampler=config.use_weighted_sampler,
            class_weights=config.use_class_weights,
            disable_loss_weights_with_sampler=config.disable_loss_weights_with_sampler,
            loss_weights_applied=loss_weights_applied,
        )
    )
    if config.zero_feature_columns:
        print("zero_feature_columns={columns}".format(columns=",".join(config.zero_feature_columns)))
    train_loader, validation_loader, train_dataframe, _, _ = build_dataloaders(
        dataframe=dataframe,
        feature_columns=feature_columns,
        target_col=config.target_col,
        race_date_col=config.race_date_col,
        batch_size=config.batch_size,
        validation_ratio=config.validation_ratio,
        standardize_features=config.standardize_features,
        use_weighted_sampler=config.use_weighted_sampler,
    )

    model = build_win5_resnet_model(
        input_dim=config.input_dim,
        num_classes=config.num_classes,
        hidden_dim=config.hidden_dim,
        num_blocks=config.num_blocks,
        dropout=config.dropout,
        device=device,
    )

    class_weights = None
    if config.use_class_weights:
        class_weights = build_class_weights(train_dataframe[config.target_col], config.num_classes)
    if config.use_weighted_sampler and config.disable_loss_weights_with_sampler:
        class_weights = None

    criterion = build_loss_function(
        loss_name=config.loss_name,
        class_weights=class_weights,
        focal_gamma=config.focal_gamma,
        device=device,
    )
    optimizer = build_optimizer(model, config)
    scheduler = StepLR(
        optimizer,
        step_size=config.scheduler_step_size,
        gamma=config.scheduler_gamma,
    )
    early_stopping = EarlyStopping(patience=config.early_stopping_patience)
    history = {
        "train_loss": [],
        "val_loss": [],
        "val_accuracy": [],
        "val_top3_accuracy": [],
        "val_focus_class_f1": [],
    }

    for epoch in range(1, config.epochs + 1):
        train_loss = train_one_epoch(
            model=model,
            loader=train_loader,
            criterion=criterion,
            optimizer=optimizer,
            device=device,
        )
        validation_metrics = evaluate(
            model=model,
            loader=validation_loader,
            criterion=criterion,
            device=device,
            focus_class=config.focus_class,
        )

        history["train_loss"].append(train_loss)
        history["val_loss"].append(validation_metrics["loss"])
        history["val_accuracy"].append(validation_metrics["accuracy"])
        history["val_top3_accuracy"].append(validation_metrics["top3_accuracy"])
        history["val_focus_class_f1"].append(validation_metrics["focus_class_f1"])

        improved = early_stopping.step(validation_metrics["focus_class_f1"])
        if improved:
            torch.save(
                {
                    "model_state_dict": model.state_dict(),
                    "config": config.__dict__,
                    "feature_columns": feature_columns,
                    "best_focus_class_f1": validation_metrics["focus_class_f1"],
                },
                config.model_output_path,
            )

        scheduler.step()

        current_lr = optimizer.param_groups[0]["lr"]
        print(
            "epoch={epoch} train_loss={train_loss:.4f} val_loss={val_loss:.4f} "
            "val_acc={val_acc:.4f} val_top3={val_top3:.4f} class1_f1={focus_class_f1:.4f} lr={lr:.6f}".format(
                epoch=epoch,
                train_loss=train_loss,
                val_loss=validation_metrics["loss"],
                val_acc=validation_metrics["accuracy"],
                val_top3=validation_metrics["top3_accuracy"],
                focus_class_f1=validation_metrics["focus_class_f1"],
                lr=current_lr,
            )
        )

        if early_stopping.should_stop:
            print(
                "early_stopping_triggered epoch={epoch} patience={patience} best_class1_f1={best_score:.4f}".format(
                    epoch=epoch,
                    patience=config.early_stopping_patience,
                    best_score=early_stopping.best_score,
                )
            )
            break

    checkpoint = torch.load(config.model_output_path, map_location=device)
    model.load_state_dict(checkpoint["model_state_dict"])

    y_true, y_pred = collect_predictions(model=model, loader=validation_loader, device=device)
    log_validation_analysis(
        y_true=y_true,
        y_pred=y_pred,
        num_classes=config.num_classes,
        focus_class=config.focus_class,
    )
    save_learning_curve(history=history, output_path=config.learning_curve_path)
    print(f"best_model_saved_to={config.model_output_path}")
    print(f"learning_curve_saved_to={config.learning_curve_path}")

    return model


def build_arg_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="WIN5 1着馬予想用 ResNet 学習スクリプト")
    parser.add_argument("--database-name", default=None)
    parser.add_argument("--table-name", default="race_results")
    parser.add_argument("--race-date-col", default="race_date")
    parser.add_argument("--target-col", default="target_class")
    parser.add_argument("--min-race-date", default="2024-01-01")
    parser.add_argument("--feature-columns", default=None)
    parser.add_argument("--batch-size", type=int, default=256)
    parser.add_argument("--epochs", type=int, default=30)
    parser.add_argument("--learning-rate", type=float, default=1e-3)
    parser.add_argument("--weight-decay", type=float, default=1e-4)
    parser.add_argument("--optimizer", choices=["adam", "adamw"], default="adamw")
    parser.add_argument("--scheduler-step-size", type=int, default=10)
    parser.add_argument("--scheduler-gamma", type=float, default=0.5)
    parser.add_argument("--loss", choices=["cross_entropy", "focal"], default="cross_entropy")
    parser.add_argument("--focal-gamma", type=float, default=2.0)
    parser.add_argument("--validation-ratio", type=float, default=0.2)
    parser.add_argument("--years", type=int, default=5)
    parser.add_argument("--device", default="cuda" if torch.cuda.is_available() else "cpu")
    parser.add_argument("--disable-class-weights", action="store_true")
    parser.add_argument("--use-weighted-sampler", action="store_true")
    parser.add_argument("--allow-loss-weights-with-sampler", action="store_true")
    parser.add_argument("--input-dim", type=int, default=128)
    parser.add_argument("--num-classes", type=int, default=18)
    parser.add_argument("--hidden-dim", type=int, default=256)
    parser.add_argument("--num-blocks", type=int, default=4)
    parser.add_argument("--dropout", type=float, default=0.1)
    parser.add_argument("--disable-standardization", action="store_true")
    parser.add_argument("--early-stopping-patience", type=int, default=5)
    parser.add_argument("--model-output-path", default="models/algo5_best.pth")
    parser.add_argument("--learning-curve-path", default="logs/learning_curve.png")
    parser.add_argument("--focus-class", type=int, default=1)
    parser.add_argument("--zero-feature-columns", default=None)
    return parser


def main() -> None:
    args = build_arg_parser().parse_args()
    feature_columns = parse_feature_columns(args.feature_columns, input_dim=args.input_dim)

    config = TrainConfig(
        database_name=args.database_name,
        table_name=args.table_name,
        race_date_col=args.race_date_col,
        target_col=args.target_col,
        min_race_date=args.min_race_date,
        batch_size=args.batch_size,
        epochs=args.epochs,
        learning_rate=args.learning_rate,
        weight_decay=args.weight_decay,
        optimizer_name=args.optimizer,
        scheduler_step_size=args.scheduler_step_size,
        scheduler_gamma=args.scheduler_gamma,
        loss_name=args.loss,
        focal_gamma=args.focal_gamma,
        validation_ratio=args.validation_ratio,
        years=args.years,
        device=args.device,
        use_class_weights=not args.disable_class_weights,
        use_weighted_sampler=args.use_weighted_sampler,
        disable_loss_weights_with_sampler=not args.allow_loss_weights_with_sampler,
        input_dim=args.input_dim,
        num_classes=args.num_classes,
        hidden_dim=args.hidden_dim,
        num_blocks=args.num_blocks,
        dropout=args.dropout,
        standardize_features=not args.disable_standardization,
        early_stopping_patience=args.early_stopping_patience,
        model_output_path=args.model_output_path,
        learning_curve_path=args.learning_curve_path,
        focus_class=args.focus_class,
        zero_feature_columns=[column.strip() for column in args.zero_feature_columns.split(",") if column.strip()]
        if args.zero_feature_columns
        else None,
    )

    dataframe = load_dataframe_from_mariadb(config=config, feature_columns=feature_columns)
    train_model(dataframe=dataframe, feature_columns=feature_columns, config=config)


if __name__ == "__main__":
    main()