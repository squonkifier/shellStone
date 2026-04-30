#!/usr/bin/env bash
# stonemeta: title: List System Services (Systemd)
# stonemeta: description: List all systemd services with their current status. Shows active, inactive, failed, and enabled/disabled states.
# stonemeta: command: systemctl list-units --type=service --all
# Services are displayed in columns: UNIT, LOAD, ACTIVE, SUB, and DESCRIPTION.
# Use arrow keys to scroll, Q to return.

echo "Listing all systemd services..."
echo ""

systemctl list-units --type=service --all 2>/dev/null

if [ $? -ne 0 ]; then
    echo ""
    echo -e "\x1b[1;31mError: systemd may not be available on this system.\x1b[0m"
fi

echo ""
echo -e "\x1b[1;32mPress Q to return to main menu\x1b[0m"
