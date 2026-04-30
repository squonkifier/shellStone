#!/usr/bin/env bash
# stonemeta: title: Arch - Export - Packagelist
# stonemeta: description: Export a list of all installed packages to ~/.packagelist.log
#

pacman -Qq | tee ~/packagelist.log
echo ""
        echo -e "\x1b[1;32mPackagelist exported to ~/packagelist.log\x1b[0m"
