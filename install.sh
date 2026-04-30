#!/bin/bash

set -e

echo "Enter installation directory (default: $HOME/Applications/memstone):"
read TARGET_DIR
TARGET_DIR="${TARGET_DIR:-$HOME/Applications/memstone}"
SHELLSTONE_BIN="$TARGET_DIR/memstone.py"

BIN_DIR="$TARGET_DIR/bin"

echo "Installing memstone to: $TARGET_DIR"

mkdir -p "$TARGET_DIR"
mkdir -p "$BIN_DIR"

echo "Copying files..."
cp -r memstone.py memstone_modules config.json scripts "$TARGET_DIR/"
cp memstone "$BIN_DIR/"
rm -f "$TARGET_DIR/memstone"

chmod +x "$BIN_DIR/memstone"
chmod +x "$TARGET_DIR/memstone.py"

update_shell_config() {
    local config_file="$1"
    local path_line="export PATH=\"$BIN_DIR:\$PATH\""

    if [ -f "$config_file" ]; then
        if grep -q "memstone" "$config_file" 2>/dev/null; then
            echo "memstone PATH already configured in $config_file"
        else
            echo "" >> "$config_file"
            echo "# memstone" >> "$config_file"
            echo "$path_line" >> "$config_file"
            echo "Added PATH to $config_file"
        fi
    fi
}

update_shell_config "$HOME/.zshrc"
update_shell_config "$HOME/.bashrc"
update_shell_config "$HOME/.profile"
update_shell_config "$HOME/.bash_profile"

echo ""
echo "Installation complete!"
echo "memstone installed to: $TARGET_DIR"
echo "Please restart your shell or run: source ~/.zshrc (or ~/.bashrc)"
echo "Then you can run: memstone"
