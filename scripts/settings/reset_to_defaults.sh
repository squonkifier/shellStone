#!/bin/bash

# stonemeta: title: Reset Settings to Defaults
# stonemeta: description: Resets all memstone.json settings to their default values.
#

set -e

SHELL_JSON="$(dirname "$(dirname "$(dirname "$(readlink -f "$0")")")")/memstone.json"

show_current() {
    if [ -f "$SHELL_JSON" ]; then
        echo "Current settings:"
        jq '.' "$SHELL_JSON"
    else
        echo "Error: memstone.json not found at $SHELL_JSON"
        exit 1
    fi
}

DEFAULT_JSON='{
    "PANES": [
        ["Main Menu", "system", 5],
        ["Packages", "packages", 2],
        ["Filesystem", "filesystem", 0],
        ["Networking", "networking", 3],
        ["Extras", "extras", 4],
        ["Settings", "settings", 1]
    ],
    "META_TITLE_RE": "^#\\s*stonemeta:\\s*title:\\s*(.+)$",
    "META_DESC_RE": "^#\\s*stonemeta:\\s*description:\\s*(.+)$",
    "META_CAT_RE": "^#\\s*stonemeta:\\s*command:\\s*(.+)$",
    "SPINNER_FRAMES": ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"],
    "PARTICLE_LAYERS": [
        ["·", "∙", "⋅", "⁺"],
        ["°", "∘", "⚬", "•", "◦", "⁎"],
        ["○", "●", "‣", "✧", "✦", "☾", "*"]
    ],
    "PARTICLE_COLORS_BASIC": [6, 3, 5, 4, 2],
    "PARTICLE_DENSITY": 0.06,
    "BOTTOM_HEIGHT": 14
}'

echo "This will reset all memstone.json settings to default values."
echo ""
show_current
echo ""

if [ -n "$1" ] && [ "$1" = "--confirm" ]; then
    confirm="y"
else
    echo "Are you sure you want to reset all settings? (y/N)"
    read -r confirm
fi

if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo "$DEFAULT_JSON" | jq '.' > "$SHELL_JSON"
    
    echo ""
    echo "Success: All settings have been reset to defaults."
    echo ""
    show_current
    echo ""
    echo "Restart memstone to apply changes."
else
    echo ""
    echo "Operation cancelled."
    exit 0
fi
