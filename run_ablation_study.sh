#!/usr/bin/env bash

set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
PYTHON_BIN="$ROOT_DIR/.venv/bin/python"
FEATURE_COLUMNS="$(seq -s, -f 'feature_%g' 0 127)"
TRAIN_BATCH_SIZE="${TRAIN_BATCH_SIZE:-1024}"
COMMON_ARGS=(
  --database-name algo_5_db
  --table-name algo5_training_data
  --race-date-col race_date
  --target-col target_class
  --feature-columns "$FEATURE_COLUMNS"
  --batch-size "$TRAIN_BATCH_SIZE"
  --min-race-date 2024-01-01
  --early-stopping-patience 5
  --focus-class 1
  --optimizer adamw
  --loss focal
  --use-weighted-sampler
  --device cuda
)

if [[ ! -x "$PYTHON_BIN" ]]; then
  echo "Python virtual environment was not found at: $PYTHON_BIN" >&2
  exit 1
fi

mkdir -p "$ROOT_DIR/models" "$ROOT_DIR/logs"

run_case() {
  local case_name="$1"
  local zero_columns="$2"
  local model_path="$ROOT_DIR/models/${case_name}.pth"
  local curve_path="$ROOT_DIR/logs/${case_name}_learning_curve.png"
  local log_path="$ROOT_DIR/logs/${case_name}.log"

  echo "=== ${case_name} ==="
  if [[ -n "$zero_columns" ]]; then
    "$PYTHON_BIN" "$ROOT_DIR/train_win5.py" \
      "${COMMON_ARGS[@]}" \
      --model-output-path "$model_path" \
      --learning-curve-path "$curve_path" \
      --zero-feature-columns "$zero_columns" | tee "$log_path"
  else
    "$PYTHON_BIN" "$ROOT_DIR/train_win5.py" \
      "${COMMON_ARGS[@]}" \
      --model-output-path "$model_path" \
      --learning-curve-path "$curve_path" | tee "$log_path"
  fi

  local best_f1
  best_f1="$(grep -o 'best_class1_f1=[0-9.]*' "$log_path" | tail -n 1 | cut -d= -f2)"
  if [[ -z "$best_f1" ]]; then
    best_f1="$(grep -o 'f1=[0-9.]*' "$log_path" | tail -n 1 | cut -d= -f2)"
  fi
  echo "case=${case_name} best_class1_f1=${best_f1}"
}

run_case baseline ""
run_case ablate_feature_38 "feature_38"
run_case ablate_feature_35 "feature_35"
