#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
PYTHON_BIN="$ROOT_DIR/.venv/bin/python"
FEATURE_COLUMNS="$(seq -s, -f 'feature_%g' 0 127)"
TRAIN_BATCH_SIZE="${TRAIN_BATCH_SIZE:-1024}"
ZERO_FEATURE_COLUMNS="${ZERO_FEATURE_COLUMNS-feature_38}"
TRAIN_LEARNING_RATE="${TRAIN_LEARNING_RATE:-0.001}"
MODEL_HIDDEN_DIM="${MODEL_HIDDEN_DIM:-256}"
MODEL_NUM_BLOCKS="${MODEL_NUM_BLOCKS:-4}"
MODEL_DROPOUT="${MODEL_DROPOUT:-0.1}"
MODEL_OUTPUT_PATH="${MODEL_OUTPUT_PATH:-models/algo5_final_v2.pth}"
LEARNING_CURVE_PATH="${LEARNING_CURVE_PATH:-logs/algo5_final_v2_learning_curve.png}"

if [[ ! -x "$PYTHON_BIN" ]]; then
    echo "Python virtual environment was not found at: $PYTHON_BIN" >&2
    exit 1
fi

ARGS=(
    --database-name algo_5_db
    --table-name algo5_training_data
    --race-date-col race_date
    --target-col target_class
    --feature-columns "$FEATURE_COLUMNS"
    --batch-size "$TRAIN_BATCH_SIZE"
    --learning-rate "$TRAIN_LEARNING_RATE"
    --min-race-date 2024-01-01
    --early-stopping-patience 5
    --model-output-path "$MODEL_OUTPUT_PATH"
    --learning-curve-path "$LEARNING_CURVE_PATH"
    --focus-class 1
    --hidden-dim "$MODEL_HIDDEN_DIM"
    --num-blocks "$MODEL_NUM_BLOCKS"
    --dropout "$MODEL_DROPOUT"
    --optimizer adamw
    --loss focal
    --use-weighted-sampler
    --device cuda
)

if [[ -n "$ZERO_FEATURE_COLUMNS" ]]; then
    ARGS+=(--zero-feature-columns "$ZERO_FEATURE_COLUMNS")
fi

"$PYTHON_BIN" "$ROOT_DIR/train_win5.py" "${ARGS[@]}"