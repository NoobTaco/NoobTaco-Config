#!/bin/bash
# NoobTaco-Config Sync Utility
# This script copies the library files into NoobTacoUI for local development.

# --- Configuration ---
# Update this path to point to your NoobTacoUI repository
TARGET_DIR="/mnt/e/Development/Active/NoobTacoUI/Libraries/NoobTaco-Config"

# --- Logic ---
echo "--- NoobTaco-Config Sync ---"

if [ ! -d "$TARGET_DIR" ]; then
    echo "Target directory not found: $TARGET_DIR"
    echo "Creating directory..."
    mkdir -p "$TARGET_DIR"
fi

echo "Syncing Core and Media to $TARGET_DIR..."

# Sync Core
rsync -av --delete Core/ "$TARGET_DIR/Core/"

# Sync Media
rsync -av --delete Media/ "$TARGET_DIR/Media/"

# Sync LICENSE
cp LICENSE "$TARGET_DIR/"

echo "Sync Complete!"
