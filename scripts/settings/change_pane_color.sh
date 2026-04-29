#!/bin/bash

# Admin-Meta: Title: Change Pane Color
# Admin-Meta: Description: Changes the color scheme for a specific pane/tab.
# Admin-Meta: Category: Settings
#

set -e

SHELL_JSON="$(dirname "$(dirname "$(dirname "$(readlink -f "$0")")")")/shell.json"

show_current() {
    if [ -f "$SHELL_JSON" ]; then
        echo "Current pane colors:"
        jq -r '.PANES[] | "  \(.[0]) (directory: \(.[1])) - Color pair: \(.[2])"' "$SHELL_JSON"
        echo ""
        echo "Available color pairs:"
        echo "  0 - Black/Default"
        echo "  1 - Red"
        echo "  2 - Green"
        echo "  3 - Yellow/Cyan"
        echo "  4 - Blue/Yellow"
        echo "  5 - Blue (Slate blue)"
        echo "  6 - White/Gray"
        echo "  7 - Green (Alternate)"
        echo "  8 - Yellow (Alternate)"
    else
        echo "Error: shell.json not found at $SHELL_JSON"
        exit 1
    fi
}

show_current

if [ -n "$1" ] && [ -n "$2" ]; then
    pane_name="$1"
    new_color="$2"
    echo "Using provided values: Pane='$pane_name', Color='$new_color'"
else
    echo ""
    echo "Enter the pane name (exact match):"
    read -r pane_name
    echo "Enter the new color pair number (0-8):"
    read -r new_color
fi

if ! [[ "$new_color" =~ ^[0-8]$ ]]; then
    echo "Error: Color must be a number between 0 and 8."
    exit 1
fi

# Check if pane exists and update
if jq -e --arg name "$pane_name" '.PANES[] | select(.[0] == $name)' "$SHELL_JSON" > /dev/null 2>&1; then
    jq --arg name "$pane_name" --argjson color "$new_color" \
        '.PANES = [.PANES[] | if .[0] == $name then [.[0], .[1], $color] else . end]' \
        "$SHELL_JSON" > "${SHELL_JSON}.tmp" && mv "${SHELL_JSON}.tmp" "$SHELL_JSON"
    
    echo ""
    echo "Success: Color updated for pane '$pane_name' to $new_color"
    show_current
    echo ""
    echo "Restart shellstone to apply changes."
else
    echo "Error: Pane '$pane_name' not found."
    exit 1
fi
