from __future__ import annotations

import torch
from torch import nn


class ResidualMLPBlock(nn.Module):
    def __init__(self, hidden_dim: int, dropout: float = 0.1) -> None:
        super().__init__()
        self.block = nn.Sequential(
            nn.Linear(hidden_dim, hidden_dim),
            nn.BatchNorm1d(hidden_dim),
            nn.ReLU(inplace=True),
            nn.Dropout(dropout),
            nn.Linear(hidden_dim, hidden_dim),
            nn.BatchNorm1d(hidden_dim),
        )
        self.activation = nn.ReLU(inplace=True)

    def forward(self, inputs: torch.Tensor) -> torch.Tensor:
        residual = inputs
        outputs = self.block(inputs)
        outputs = outputs + residual
        return self.activation(outputs)


class Win5ResNetClassifier(nn.Module):
    def __init__(
        self,
        input_dim: int = 128,
        num_classes: int = 18,
        hidden_dim: int = 256,
        num_blocks: int = 4,
        dropout: float = 0.1,
    ) -> None:
        super().__init__()

        if input_dim <= 0:
            raise ValueError("input_dim は 1 以上を指定してください")
        if num_classes <= 1:
            raise ValueError("num_classes は 2 以上を指定してください")
        if hidden_dim <= 0:
            raise ValueError("hidden_dim は 1 以上を指定してください")
        if num_blocks <= 0:
            raise ValueError("num_blocks は 1 以上を指定してください")

        self.input_layer = nn.Sequential(
            nn.Linear(input_dim, hidden_dim),
            nn.BatchNorm1d(hidden_dim),
            nn.ReLU(inplace=True),
            nn.Dropout(dropout),
        )
        self.residual_layers = nn.Sequential(
            *[ResidualMLPBlock(hidden_dim=hidden_dim, dropout=dropout) for _ in range(num_blocks)]
        )
        self.classifier = nn.Linear(hidden_dim, num_classes)

        self._initialize_weights()

    def _initialize_weights(self) -> None:
        for module in self.modules():
            if isinstance(module, nn.Linear):
                nn.init.kaiming_normal_(module.weight, nonlinearity="relu")
                if module.bias is not None:
                    nn.init.zeros_(module.bias)
            elif isinstance(module, nn.BatchNorm1d):
                nn.init.ones_(module.weight)
                nn.init.zeros_(module.bias)

    def forward(self, inputs: torch.Tensor) -> torch.Tensor:
        if inputs.ndim != 2:
            raise ValueError("inputs は [batch_size, feature_dim] の2次元テンソルを想定しています")

        outputs = self.input_layer(inputs)
        outputs = self.residual_layers(outputs)
        logits = self.classifier(outputs)
        return logits

    @torch.no_grad()
    def predict_proba(self, inputs: torch.Tensor) -> torch.Tensor:
        logits = self.forward(inputs)
        return torch.softmax(logits, dim=1)

    @torch.no_grad()
    def predict(self, inputs: torch.Tensor) -> torch.Tensor:
        probabilities = self.predict_proba(inputs)
        return torch.argmax(probabilities, dim=1)


def build_win5_resnet_model(
    input_dim: int = 128,
    num_classes: int = 18,
    hidden_dim: int = 256,
    num_blocks: int = 4,
    dropout: float = 0.1,
    device: str | torch.device | None = None,
) -> Win5ResNetClassifier:
    model = Win5ResNetClassifier(
        input_dim=input_dim,
        num_classes=num_classes,
        hidden_dim=hidden_dim,
        num_blocks=num_blocks,
        dropout=dropout,
    )

    if device is not None:
        model = model.to(device)

    return model


if __name__ == "__main__":
    target_device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
    model = build_win5_resnet_model(device=target_device)
    dummy_batch = torch.randn(32, 128, device=target_device)
    logits = model(dummy_batch)
    print(f"device={target_device}")
    print(f"logits_shape={tuple(logits.shape)}")