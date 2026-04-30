#!/bin/bash

set -e

echo "Enter installation directory (default: $HOME/Applications/shellstone):"
read TARGET_DIR
TARGET_DIR="${TARGET_DIR:-$HOME/Applications/shellstone}"
SHELLSTONE_BIN="$TARGET_DIR/shellstone.py"

echo "Installing shellstone to: $TARGET_DIR"

mkdir -p "$TARGET_DIR"

echo "Copying files..."
cp -r shellstone.py shellstone_modules shell.json scripts "$TARGET_DIR/"

chmod +x "$TARGET_DIR/shellstone.py"

update_shell_config() {
    local config_file="$1"
    local path_line="export PATH=\"$TARGET_DIR:\$PATH\""

    if [ -f "$config_file" ]; then
        if grep -q "shellstone" "$config_file" 2>/dev/null; then
            echo "shellstone PATH already configured in $config_file"
        else
            echo "" >> "$config_file"
            echo "# shellstone" >> "$config_file"
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
echo "shellstone installed to: $TARGET_DIR"
echo "Please restart your shell or run: source ~/.zshrc (or ~/.bashrc)"
echo "Then you can run: shellstone"
