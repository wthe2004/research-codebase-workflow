# Agent experiment command log

Use this template when an agent starts, resumes, or changes a training,
evaluation, rendering, or sweep command that produces research artifacts.

Copy this file to:

```text
docs/exp-log-agent/<YYYYMMDD_HHMMSS>_<short-slug>.sh
```

The file is a small replayable audit record. It is not a place for bulky stdout,
model checkpoints, raw metrics dumps, credentials, or private tokens.

## Rules

- Create the log before launching the command when possible. If the run already
  started, create it as soon as possible and mark the status honestly.
- Use one file per experiment attempt or coherent command sequence.
- Keep exact commands, environment variables, working directory, input artifacts,
  output paths, and hardware assumptions.
- Prefer repo-relative paths for in-repo files. Use absolute paths for
  cross-repo checkpoints, datasets, or external assets.
- If a run is resumed, append a new dated step or create a new log that points
  back to the original log.
- Keep comments short and decision-focused: explain why this command exists,
  not what every shell token means.

## Template

```bash
#!/usr/bin/env bash
set -euo pipefail

# Goal:
#   <What question does this run answer?>
#
# Context:
#   Issue/PR/plan:
#   Prior run/log, if any:
#   Code ref:
#
# Status:
#   planned | running | completed | failed | canceled
#
# Expected hardware/runtime:
#   <GPU/CPU, memory assumptions, estimated wall clock>
#
# Inputs:
#   <Datasets, checkpoints, prompt files, config files>
#
# Outputs:
#   <Save dir, report dir, log file, metric artifact paths>
#
# Review notes:
#   <What should a reviewer compare or inspect when this finishes?>

cd "$(git rev-parse --show-toplevel)"

# Step 1: <short reason>
# Example:
# DEVICE=cuda:0 \
# RUN_TS=<run-id> \
# OUTPUT_DIR=<path> \
#   bash scripts/eval/<launcher>.sh
```
