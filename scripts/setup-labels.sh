#!/usr/bin/env bash
# Create the factory labels on the current repo. Needs: gh (GitHub CLI), logged in.
# Usage: scripts/setup-labels.sh [owner/repo]
set -euo pipefail

REPO_ARG=()
[ $# -ge 1 ] && REPO_ARG=(--repo "$1")

mk() { gh label create "$1" --color "$2" --description "$3" --force "${REPO_ARG[@]}"; }

mk "triage"        "ededed" "Waiting for triage"
mk "impact:low"    "0e8a16" "Small, reversible change: cheaper model OK"
mk "impact:medium" "fbca04" "Moderate change"
mk "impact:high"   "d93f0b" "Risky or wide change: best model + human review"
mk "needs-human"   "b60205" "Agent stopped, human decision needed"
mk "factory:halt"  "000000" "Kill switch: agents must not act"
mk "agent-pr"      "5319e7" "PR authored by the agent"
echo "labels ready"
