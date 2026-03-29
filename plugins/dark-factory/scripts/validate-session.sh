#!/bin/bash
# Dark Factory Plugin — Post-Session Validator
# Validates a completed session and prints governance-appropriate actions
#
# Usage: ./validate-session.sh <session-id>

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

source "$PLUGIN_ROOT/lib/config.sh"
load_project_config

SESSION_ID="${1:?Usage: validate-session.sh <session-id>}"
SESSION_DIR="$DF_FACTORY_DIR/sessions/$SESSION_ID"

if [ ! -d "$SESSION_DIR" ]; then
  echo "ERROR: Session directory not found: $SESSION_DIR"
  exit 1
fi

GOVERNANCE_FILE="$SESSION_DIR/governance.json"
if [ ! -f "$GOVERNANCE_FILE" ]; then
  echo "ERROR: No governance.json in session $SESSION_ID"
  exit 1
fi

DECISION=$(jq -r '.decision' "$GOVERNANCE_FILE")
TIER=$(jq -r '.tier' "$GOVERNANCE_FILE")
SATISFACTION=$(jq -r '.satisfaction_score' "$GOVERNANCE_FILE")
HOLDOUT_PASS=$(jq -r '.holdout_pass' "$GOVERNANCE_FILE")
ISSUE_NUMBER=$(jq -r '.issue_number' "$GOVERNANCE_FILE")
LAYER=$(jq -r '.layer' "$GOVERNANCE_FILE")
RISK_SCORE=$(jq -r '.risk_score' "$GOVERNANCE_FILE")

PR_URL="none"
if [ -f "$SESSION_DIR/implementation-parsed.json" ]; then
  PR_URL=$(jq -r '.pr_url // "none"' "$SESSION_DIR/implementation-parsed.json" 2>/dev/null || echo "none")
fi

echo "=== Session Validation: $SESSION_ID ==="
echo "Project:      $DF_PROJECT_NAME"
echo "Issue:        #$ISSUE_NUMBER"
echo "Layer:        $LAYER"
echo "Tier:         $TIER"
echo "Decision:     $DECISION"
echo "Satisfaction: $SATISFACTION"
echo "Holdout:      $HOLDOUT_PASS"
echo "Risk Score:   $RISK_SCORE"
echo "PR:           $PR_URL"

case "$DECISION" in
  "auto-ship")
    echo ""
    echo "ACTION: Auto-merge eligible (T0)"
    echo "PR should be auto-merged via CI workflow."
    ;;
  "auto-pr")
    echo ""
    echo "ACTION: Auto-PR with CI gate (T1)"
    echo "PR will auto-merge after CI passes."
    ;;
  "review-pr")
    echo ""
    echo "ACTION: PR needs human review (T2)"
    echo "WAITING: PR requires 1 human reviewer."
    ;;
  "gated")
    echo ""
    echo "ACTION: PR needs architecture review (T3)"
    echo "WAITING: PR requires 2 reviewers + architect."
    ;;
  "blocked")
    echo ""
    echo "ACTION: Task blocked (T4)"
    echo "BLOCKED: Implementation failed, holdout failed, or satisfaction too low."
    echo ""
    if [ -f "$SESSION_DIR/implementation-stderr.log" ]; then
      echo "--- Implementation Errors (last 20 lines) ---"
      tail -20 "$SESSION_DIR/implementation-stderr.log"
    fi
    if [ "$HOLDOUT_PASS" = "false" ]; then
      echo "Holdout validation failed. Check: $SESSION_DIR/holdout-result.json"
    fi
    echo ""
    echo "Human action required. Options:"
    echo "  1. Fix the issue and retry"
    echo "  2. Override governance tier"
    echo "  3. Cancel the task"
    ;;
  "no-op")
    echo ""
    echo "ACTION: No-op (feature already implemented)"
    echo "0 files changed. Issue marked as merged."
    ;;
  *)
    echo "ERROR: Unknown decision: $DECISION"
    exit 1
    ;;
esac

echo ""
echo "Session artifacts: $SESSION_DIR/"
echo "=== Validation Complete ==="
