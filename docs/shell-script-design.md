# Shell Script Design Guide

Shell thin. Python thick. Shell only: derive paths, hold defaults, call Python. Logic stay in Python.

## Three Hard Rules

1. First line `set -euo pipefail`. Fail fast, no silent skip.
2. Paths derived from `$0`. No hard-coded absolute path.
   ```bash
   SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
   PROJECT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"
   ```
3. Last arg `"$@"` -> CLI override any default.
   ```bash
   python train.py --lr 3e-4 ... "$@"
   ```

## Two Styles, Pick By Use Case

### Style A: One-Variable-Per-Hyperparam (single run)

Each hyperparam own line, own comment. Easy edit, easy diff. Use when one Python invocation.

```bash
#!/bin/bash
set -euo pipefail

# ---------- Paths ----------
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

CHECKPOINT="${PROJECT_DIR}/data/pretrained/last.ckpt"
MOTION_FILE="${PROJECT_DIR}/data/motion.pt"

# ---------- Training hyperparameters (paper defaults) ----------
DEVICE="cuda:1"
NUM_ENVS=8192
LR=3e-4
NUM_ITERATIONS=1500

# ---------- LR schedule (WSD: Warmup-Stable-Decay) ----------
WARMUP_STEPS=50
DECAY_STEPS=400
MIN_LR_RATIO=0.01

SAVE_DIR="${PROJECT_DIR}/results/critic_g1"

# ---------- Optional toggles ----------
ENABLE_DR=""                  # "yes" -> enable DR
RESUME=""                     # path -> resume from ckpt
MOTION_CHUNK_DIR=""           # path -> chunk training

# ---------- Run ----------
python "${SCRIPT_DIR}/train.py" \
    --checkpoint "${CHECKPOINT}" \
    --motion-file "${MOTION_FILE}" \
    --device "${DEVICE}" \
    --num-envs "${NUM_ENVS}" \
    --lr "${LR}" \
    --num-iterations "${NUM_ITERATIONS}" \
    --warmup-steps "${WARMUP_STEPS}" \
    --decay-steps "${DECAY_STEPS}" \
    --min-lr-ratio "${MIN_LR_RATIO}" \
    --save-dir "${SAVE_DIR}" \
    ${ENABLE_DR:+--enable-dr} \
    ${RESUME:+--resume "$RESUME"} \
    ${MOTION_CHUNK_DIR:+--motion-chunk-dir "$MOTION_CHUNK_DIR"} \
    "$@"
```

### Style B: `COMMON_ARGS` Array (multi-run, shared defaults)

Shared args -> array. Per-run diff -> inline. Use when same script call Python multiple times w/ small variation (ablation, sweep).

```bash
#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

CHECKPOINT="${PROJECT_DIR}/data/pretrained/last.ckpt"
SAVE_DIR="${PROJECT_DIR}/results/ablation_future_dropout"

COMMON_ARGS=(
    --checkpoint "$CHECKPOINT"
    --device cuda:1
    --num-envs 8192
    --lr 3e-4
    --num-iterations 1000
    --save-dir "$SAVE_DIR"
    --wandb-project robotmdm-critic-ablation
)

echo "===== Run 1/2: exp offsets (1 2 4 8) ====="
python "$SCRIPT_DIR/train_multi_critic.py" \
    "${COMMON_ARGS[@]}" \
    --future-offsets 1 2 4 8 \
    --wandb-run-name "exp_1248" \
    "$@"

echo "===== Run 2/2: lin offsets (1 2 3 4) ====="
python "$SCRIPT_DIR/train_multi_critic.py" \
    "${COMMON_ARGS[@]}" \
    --future-offsets 1 2 3 4 \
    --wandb-run-name "lin_1234" \
    "$@"
```

## Optional Flag Idiom: `${VAR:+...}`

Empty string -> flag dropped. Non-empty -> flag passed. No `if/else` needed.

```bash
${ENABLE_DR:+--enable-dr}                          # bool flag
${RESUME:+--resume "$RESUME"}                      # value flag
${MOTION_CHUNK_DIR:+--motion-chunk-dir "$MOTION_CHUNK_DIR"}
```

Comment must say "set X to enable" so reader know empty = off.

## Section Header Convention

Visual grouping w/ banner comments. Reader scan top-to-bottom fast.

```
# ---------- Paths ----------
# ---------- Environment ----------
# ---------- Training hyperparameters ----------
# ---------- LR schedule ----------
# ---------- Domain Randomization ----------
# ---------- Resume ----------
# ---------- Logging ----------
# ---------- Run ----------
```

## Quoting Rules

- Quote every var expand: `"${PATH_VAR}"`. Skip quote -> word-split bug w/ space in path.
- Exception: deliberate word-split for `nargs='+'`:
  ```bash
  HIDDEN_DIMS="256 256 256 256"
  python train.py --hidden-dims ${HIDDEN_DIMS}     # unquoted on purpose
  ```
  Add comment explain why unquoted.

## Shell Must NOT Do

- File existence check. Python entry do `assert path.exists()`. One source of truth.
- `if`/`case`/loop. Branch logic -> Python.
- String/JSON/YAML manipulation -> Python.
- Config selection. No `if [[ $MODE == "fast" ]]; then ...`. Use `--config-preset fast` Python side.
- Math. No `$(( ... ))` for hyperparam computation. Python compute.

If tempted -> stop, move to Python.

## Real Environment Variable Exception

`export` only for vars downstream lib read directly:

```bash
# ---------- Environment ----------
export CUDA_VISIBLE_DEVICES=1
export WANDB_PROJECT=robotmdm-critic
export HF_HOME=/data/cache/huggingface
# export LD_LIBRARY_PATH="${HOME}/miniforge3/envs/proj/lib:${LD_LIBRARY_PATH:-}"
```

Per-run hyperparam -> argparse, not env var. Env var invisible, no `--help`, all string.

## Anti-Patterns

```bash
# BAD: hard-coded path
python /home/me/proj/train.py --lr 3e-4

# BAD: file check in shell (duplicate truth)
if [ ! -f "$CHECKPOINT" ]; then echo "missing"; exit 1; fi

# BAD: branch logic in shell
if [ "$MODE" = "fast" ]; then NUM_ITER=100; else NUM_ITER=1000; fi

# BAD: env var for per-run hyperparam
export LR=3e-4
python train.py    # reads os.environ["LR"] inside

# BAD: no "$@" passthrough -> can't override w/o edit script
python train.py --lr "$LR"
```

## Templates

Copy-modify, no rewrite:

- Single run: see Style A above.
- Multi-run sweep: see Style B above.
