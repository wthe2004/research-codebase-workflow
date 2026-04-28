#!/usr/bin/env bash
# Create the recommended label set for a research project repo (idempotent).
#
# Usage:
#   bash recommended-labels.sh                   # current repo (auto-detect via gh)
#   bash recommended-labels.sh wthe2004/foo      # explicit repo
#
# Each label is created with `|| true` so re-running after some labels
# already exist will not fail the script.
#
# The label set has 3 dimensions:
#   priority:* — how soon should this be addressed
#   type:*     — what kind of work
#   scope:*    — which area of the project (customize per project)
#
# Apply 1 priority + 1 type + 1-N scope labels per issue.

set -euo pipefail

REPO="${1:-}"
GH_OPTS=()
[ -n "$REPO" ] && GH_OPTS=(--repo "$REPO")

# priority — how soon
gh label create "priority:high"   --color "d73a4a" --description "Blocks something or has time pressure"        "${GH_OPTS[@]}" || true
gh label create "priority:medium" --color "ff7619" --description "Should do, no immediate rush"                 "${GH_OPTS[@]}" || true
gh label create "priority:low"    --color "6f6f6f" --description "Nice to have, no clear trigger yet"           "${GH_OPTS[@]}" || true

# type — what kind of work
gh label create "type:tech-debt"  --color "fbca04" --description "Code health; no functional change required"  "${GH_OPTS[@]}" || true
gh label create "type:refactor"   --color "1d76db" --description "Restructure existing code without changing behavior" "${GH_OPTS[@]}" || true
gh label create "type:cleanup"    --color "006b75" --description "Small mechanical cleanup (dead code, magic numbers, etc.)" "${GH_OPTS[@]}" || true
gh label create "type:scheduled"  --color "0e8a16" --description "Already planned with a known trigger / deadline" "${GH_OPTS[@]}" || true

# scope — area of the project (these are EXAMPLES; customize per project)
gh label create "scope:eval"      --color "5319e7" --description "Eval pipeline (project-local; customize)"     "${GH_OPTS[@]}" || true
gh label create "scope:paths"     --color "5319e7" --description "Path / config handling (project-local; customize)" "${GH_OPTS[@]}" || true
gh label create "scope:ci"        --color "5319e7" --description "CI / build automation"                       "${GH_OPTS[@]}" || true
gh label create "scope:data-prep" --color "5319e7" --description "Data preparation (project-local; customize)" "${GH_OPTS[@]}" || true

echo
echo "Done. Verify via: gh label list ${GH_OPTS[*]}"
