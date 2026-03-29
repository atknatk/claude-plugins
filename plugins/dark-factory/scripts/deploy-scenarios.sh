#!/bin/bash
# Dark Factory Plugin — Deploy holdout scenarios from staging
# Usage: ./deploy-scenarios.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLUGIN_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

source "$PLUGIN_ROOT/lib/config.sh"
load_project_config

STAGING_DIR="$DF_FACTORY_DIR/holdouts-staging"
TARGET_DIR="$DF_HOLDOUT_DIR"

if [ ! -d "$STAGING_DIR" ]; then
  echo "ERROR: Staging directory not found: $STAGING_DIR"
  exit 1
fi

count=0
for layer_dir in "$STAGING_DIR"/*/; do
  [ -d "$layer_dir" ] || continue
  layer=$(basename "$layer_dir")
  dst="$TARGET_DIR/$layer"

  mkdir -p "$dst"

  for file in "$layer_dir"/*.yaml; do
    [ -f "$file" ] || continue
    cp -f "$file" "$dst/$(basename "$file")"
    count=$((count + 1))
  done

  echo "OK: $layer — $(ls "$layer_dir"/*.yaml 2>/dev/null | wc -l | tr -d ' ') files deployed"
done

echo ""
echo "Total: $count files deployed from staging to active directory."
echo ""
echo "Cleaning up staging directory..."
rm -rf "$STAGING_DIR"
echo "Done."
