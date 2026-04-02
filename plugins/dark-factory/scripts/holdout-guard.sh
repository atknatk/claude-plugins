#!/bin/bash
# Dark Factory Plugin — Holdout Guard Hook
# Prevents implementation agents from accessing holdout scenarios.
# This is a PreToolUse hook that runs before Read, Bash, Glob, Grep operations.
# It blocks any attempt to access holdout validation content during development.

INPUT=$(cat)

# Fast targeted config load — only reads the 2 fields we need (not full config)
_HG_SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
_HG_PLUGIN_ROOT="$(cd "$_HG_SCRIPT_DIR/.." && pwd)"
if [ -z "${DF_HOLDOUT_ALLOWED_AGENTS:-}" ] && [ -f "$_HG_PLUGIN_ROOT/lib/config.sh" ]; then
  source "$_HG_PLUGIN_ROOT/lib/config.sh"
  _hg_project_dir="$(resolve_project_dir)"
  _hg_config="$_hg_project_dir/.dark-factory/config.yaml"
  export DF_PROJECT_DIR="$_hg_project_dir"
  export DF_HOLDOUT_ALLOWED_AGENTS="$(yaml_val "$_hg_config" "holdout_allowed_agents" "holdout-validator,satisfaction-judge")"
fi

# Extract ALL relevant fields (command, file_path, pattern, path) and join them
# This prevents bypass via Glob tool where pattern and path are separate fields
CMD=$(echo "$INPUT" | jq -r '
  [.tool_input.command, .tool_input.file_path, .tool_input.pattern, .tool_input.path]
  | map(select(. != null and . != ""))
  | join(" ")' 2>/dev/null)

# Allow directory creation and management (mkdir, ls, touch, chmod)
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // ""' 2>/dev/null)
if [ "$TOOL_NAME" = "Bash" ]; then
  if echo "$CMD" | grep -qE '^mkdir |^ls |^touch |^chmod '; then
    echo '{}'
    exit 0
  fi
fi

# Skip non-reading Bash commands (git, etc.) — only block file reads
if [ "$TOOL_NAME" = "Bash" ]; then
  if echo "$CMD" | grep -qE '^git '; then
    echo '{}'
    exit 0
  fi
  if ! echo "$CMD" | grep -qE 'cat |head |tail |less |more |bat |source |\.[ ]'; then
    echo '{}'
    exit 0
  fi
fi

# Block READING holdout scenario content
if echo "$CMD" | grep -qiE '\.dark-factory/holdouts/|dark-factory/holdouts|holdout\.yaml|holdout\.yml|\.holdout\.'; then
  # Config-driven allowed agents (DF_HOLDOUT_ALLOWED_AGENTS set by config.sh)
  AGENT_NAME=$(echo "$INPUT" | jq -r '.agent_name // ""' 2>/dev/null)
  ALLOWED="${DF_HOLDOUT_ALLOWED_AGENTS:-holdout-validator,satisfaction-judge}"
  if [ -n "$AGENT_NAME" ] && echo ",$ALLOWED," | grep -qF ",$AGENT_NAME,"; then
    echo '{}'
    exit 0
  fi

  # Allow sub-agents spawned with holdout-related names
  if echo "$AGENT_NAME" | grep -qE '^holdout-'; then
    echo '{}'
    exit 0
  fi

  # Environment variable bypass for run-task.sh validation phase
  if [ "${HOLDOUT_VALIDATOR_MODE:-}" = "true" ]; then
    echo '{}'
    exit 0
  fi

  # Marker file bypass — project-scoped to prevent cross-project interference
  PROJECT_HASH=$(echo "${DF_PROJECT_DIR:-unknown}" | (md5 2>/dev/null || md5sum 2>/dev/null) | cut -c1-8)
  PROJECT_HASH="${PROJECT_HASH:-default}"
  if [ -f "/tmp/.dark-factory-holdout-validate-${PROJECT_HASH}" ]; then
    echo '{}'
    exit 0
  fi

  echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"deny","reason":"Access to holdout validation scenarios is blocked during development. Holdout scenarios are agent-invisible behavioral tests that run only during validation. This ensures implementation agents cannot game the tests."}}'
  exit 0
fi

# Allow all other operations
echo '{}'
