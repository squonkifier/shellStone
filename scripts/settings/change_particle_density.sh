#!/bin/bash

# stonemeta: title: Change Particle Density
# stonemeta: description: Modifies the particle density for the background animation effect.
#

set -e

SHELL_JSON="$(dirname "$(dirname "$(dirname "$(readlink -f "$0")")")")/memstone.json"

show_current() {
    if [ -f "$SHELL_JSON" ]; then
        current=$(jq '.PARTICLE_DENSITY' "$SHELL_JSON")
        echo "Current particle density: $current"
        echo "  (Higher values = more particles, Lower values = fewer particles)"
    else
        echo "Error: memstone.json not found at $SHELL_JSON"
        exit 1
    fi
}

validate_input() {
    local value="$1"
    if ! [[ "$value" =~ ^[0-9]*\.?[0-9]+$ ]]; then
        echo "Error: Please enter a valid number (e.g., 0.06, 0.1, 0.5)."
        return 1
    fi
    if jq -e --arg v "$value" '($v | tonumber) < 0.01' > /dev/null 2>&1; then
        echo "Warning: Density less than 0.01 may show very few particles."
    fi
    if jq -e --arg v "$value" '($v | tonumber) > 0.5' > /dev/null 2>&1; then
        echo "Warning: Density greater than 0.5 may cause performance issues."
    fi
    return 0
}

show_current
echo ""

if [ -n "$1" ]; then
    new_density="$1"
    echo "Using provided value: $new_density"
else
    echo "Enter new particle density (recommended: 0.03 to 0.15):"
    read -r new_density
fi

if validate_input "$new_density"; then
    jq ".PARTICLE_DENSITY = $new_density" "$SHELL_JSON" > "${SHELL_JSON}.tmp" && \
        mv "${SHELL_JSON}.tmp" "$SHELL_JSON"
    
    echo ""
    echo "Success: Particle density updated to $new_density"
    show_current
    echo ""
    echo "Restart memstone to apply changes."
else
    echo ""
    echo "Operation cancelled."
    exit 1
fi
