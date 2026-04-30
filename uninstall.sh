#!/bin/bash

set -e

TARGET_DIR="${1:-$HOME/Applications/memstone}"

echo "Uninstalling memstone from: $TARGET_DIR"

if [ ! -d "$TARGET_DIR" ]; then
    echo "Directory not found: $TARGET_DIR"
    exit 1
fi

remove_memstone_from_config() {
    local config_file="$1"

    if [ -f "$config_file" ]; then
        if grep -q "memstone" "$config_file" 2>/dev/null; then
            grep -v "memstone" "$config_file" > "${config_file}.tmp" || true
            mv "${config_file}.tmp" "$config_file"
            echo "Removed memstone from $config_file"
        fi
    fi
}

remove_memstone_from_config "$HOME/.zshrc"
remove_memstone_from_config "$HOME/.bashrc"
remove_memstone_from_config "$HOME/.profile"
remove_memstone_from_config "$HOME/.bash_profile"

echo "Removing installation directory..."
rm -rf "$TARGET_DIR"

echo ""
echo "Uninstallation complete!"
echo "Please restart your shell or run: source ~/.zshrc (or ~/.bashrc)"
