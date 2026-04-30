#!/bin/bash

# stonemeta: title: Change Bottom Panel Height
# stonemeta: description: Modifies the bottom panel height in shell.json configuration file.
#

set -e

SHELL_JSON="$(dirname "$(dirname "$(dirname "$(readlink -f "$0")")")")/shell.json"

# Function to display current height
show_current() {
    if [ -f "$SHELL_JSON" ]; then
        current=$(jq '.BOTTOM_HEIGHT' "$SHELL_JSON")
        echo "Current bottom panel height: $current"
    else
        echo "Error: shell.json not found at $SHELL_JSON"
        exit 1
    fi
}

# Function to validate input (must be a positive integer)
validate_input() {
    local value="$1"
    if ! [[ "$value" =~ ^[0-9]+$ ]]; then
        echo "Error: Please enter a valid positive integer."
        return 1
    fi
    if [ "$value" -lt 5 ]; then
        echo "Warning: Height less than 5 may not display properly."
    fi
    if [ "$value" -gt 50 ]; then
        echo "Warning: Height greater than 50 may take up too much screen space."
    fi
    return 0
}

# Show current setting
show_current
echo ""

# Check if value provided as argument
if [ -n "$1" ]; then
    new_height="$1"
    echo "Using provided value: $new_height"
else
    # Prompt user for input
    echo "Enter new bottom panel height (in lines):"
    read -r new_height
fi

# Validate input
if validate_input "$new_height"; then
    # Update the JSON file using jq
    jq ".BOTTOM_HEIGHT = $new_height" "$SHELL_JSON" > "${SHELL_JSON}.tmp" && \
        mv "${SHELL_JSON}.tmp" "$SHELL_JSON"
    
    echo ""
    echo "Success: Bottom panel height updated to $new_height"
    show_current
    echo ""
    echo "Restart shellstone to apply changes."
else
    echo ""
    echo "Operation cancelled."
    exit 1
fi
