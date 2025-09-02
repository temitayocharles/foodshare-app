#!/bin/bash
set -euo pipefail

BASE_DIR="/Volumes/256-B/tc-enterprise-devops-platform"
ZIP_FILE="/Volumes/256-B/screenshots-from-k8s-cluster.zip"
SOURCE_DIR="$BASE_DIR/screenshots-raw"
TARGET_DIR="$BASE_DIR/screenshots"

mkdir -p "$SOURCE_DIR" "$TARGET_DIR"

# Extract
if [[ -f "$ZIP_FILE" ]]; then
  echo "🔧 Extracting $ZIP_FILE..."
  unzip -o "$ZIP_FILE" -d "$SOURCE_DIR" >/dev/null
else
  echo "❌ Zip file not found at $ZIP_FILE"
  exit 1
fi

# Gather screenshots safely (handles spaces in filenames)
mapfile -t files < <(find "$SOURCE_DIR" -type f -name "Screenshot*.png" | sort)

if [[ ${#files[@]} -eq 0 ]]; then
  echo "❌ No screenshots found in $SOURCE_DIR"
  exit 1
fi

# First 5 mappings
declare -a DEST_NAMES=(
  "cluster-overview.png"
  "nodes-view.png"
  "grafana-overview.png"
  "foodshare-pods.png"
  "argocd-deployments.png"
)

echo "🔧 Mapping first 5 screenshots..."
for i in "${!DEST_NAMES[@]}"; do
  if [[ -n "${files[$i]:-}" ]]; then
    cp -f "${files[$i]}" "$TARGET_DIR/${DEST_NAMES[$i]}"
    echo "✅ $(basename "${files[$i]}") → ${DEST_NAMES[$i]}"
  else
    echo "⚠️ Missing source for ${DEST_NAMES[$i]}"
  fi
done

# Remaining as extras
echo "🔧 Mapping remaining screenshots as extras..."
extra_index=1
for ((i=${#DEST_NAMES[@]}; i<${#files[@]}; i++)); do
  dest=$(printf "extra-%02d.png" "$extra_index")
  cp -f "${files[$i]}" "$TARGET_DIR/$dest"
  echo "✅ $(basename "${files[$i]}") → $dest"
  ((extra_index++))
done

echo "🎉 All screenshots ready in $TARGET_DIR"
