#!/usr/bin/env bash
# stonemeta: title:  Arch - Export - Packagelist (explicit)
# stonemeta: description: Export a list of all installed packages, minus scraggler dependencies. These are mostly your "intentionally installed" main programs. Export to to ~/.packagelist-explicit.log
#

pacman -Qqe | tee ~/packagelist-explicit.log
echo ""
        echo -e "\x1b[1;32mPackagelist exported to ~/packagelist-explicit.log\x1b[0m"
