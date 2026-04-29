#!/bin/bash

# Admin-Meta: Title: Change Spinner Style
# Admin-Meta: Description: Changes the spinner animation frames used for the selection indicator.
# Admin-Meta: Category: Settings
#

set -e

SHELL_JSON="$(dirname "$(dirname "$(dirname "$(readlink -f "$0")")")")/shell.json"

show_current() {
    if [ -f "$SHELL_JSON" ]; then
        echo "Current spinner frames:"
        jq -r '.SPINNER_FRAMES[]' "$SHELL_JSON" | tr '\n' ' '
        echo ""
    else
        echo "Error: shell.json not found at $SHELL_JSON"
        exit 1
    fi
}

echo "Select a spinner style:"
echo "  1) Braille dots (default) - ⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏"
echo "  2) Clock - ◴◷◶◵"
echo "  3) Line - |/-\\"
echo "  4) Circle - ◐◓◑◒"
echo "  5) Arrow - →↘↓↙←↖↑↗"
echo "  6) Custom (enter your own JSON array)"
echo ""

if [ -n "$1" ]; then
    choice="$1"
    echo "Using provided choice: $choice"
else
    echo "Enter your choice (1-6):"
    read -r choice
fi

case "$choice" in
    1)
        new_frames='["⠋","⠙","⠹","⠸","⠼","⠴","⠦","⠧","⠇","⠏"]'
        ;;
    2)
        new_frames='["◴","◷","◶","◵"]'
        ;;
    3)
        new_frames='["|","/","-","\\"]'
        ;;
    4)
        new_frames='["◐","◓","◑","◒"]'
        ;;
    5)
        new_frames='["→","↘","↓","↙","←","↖","↑","↗"]'
        ;;
    6)
        echo "Enter custom spinner frames as JSON array (e.g., [\"a\",\"b\",\"c\"]):"
        read -r new_frames
        if ! echo "$new_frames" | jq -e '.' > /dev/null 2>&1; then
            echo "Error: Invalid JSON array."
            exit 1
        fi
        ;;
    *)
        echo "Error: Invalid choice."
        exit 1
        ;;
esac

jq ".SPINNER_FRAMES = $new_frames" "$SHELL_JSON" > "${SHELL_JSON}.tmp" && \
    mv "${SHELL_JSON}.tmp" "$SHELL_JSON"

echo ""
echo "Success: Spinner style updated."
show_current
echo ""
echo "Restart shellstone to apply changes."
