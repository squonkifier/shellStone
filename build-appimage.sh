#!/bin/bash
# Rebuild shellstone AppImage
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
APPDIR="$SCRIPT_DIR/AppDir"
OUTPUT="$SCRIPT_DIR/shellstone-x86_64.AppImage"

echo "==> Cleaning AppDir..."
rm -rf "$APPDIR" 2>/dev/null

echo "==> Creating AppDir structure..."
mkdir -p "$APPDIR/usr/bin"
mkdir -p "$APPDIR/usr/share/applications"
mkdir -p "$APPDIR/usr/share/icons/hicolor/128x128/apps"

echo "==> Copying project files..."
rsync -a --exclude='AppDir' --exclude='*.AppImage' --exclude='__pycache__' "$SCRIPT_DIR/." "$APPDIR/usr/bin/"

echo "==> Copying icon..."
cp "$SCRIPT_DIR/appicon.png" "$APPDIR/usr/share/icons/hicolor/128x128/apps/shellstone.png"
cp "$SCRIPT_DIR/appicon.png" "$APPDIR/shellstone.png"

echo "==> Creating desktop file..."
cat > "$APPDIR/usr/share/applications/shellstone.desktop" << 'EOF'
[Desktop Entry]
Name=Shellstone
Comment=Zero-dependency ncurses TUI for Linux system administration
Exec=shellstone
Icon=shellstone
Type=Application
Terminal=true
Categories=System;Utility;
StartupNotify=false
EOF
cp "$APPDIR/usr/share/applications/shellstone.desktop" "$APPDIR/shellstone.desktop"

echo "==> Creating AppRun..."
cat > "$APPDIR/AppRun" << 'APPRUN'
#!/bin/sh
DIR="$(dirname "$(readlink -f "$0")")"
export PYTHONPATH="${DIR}/usr/bin:${PYTHONPATH:-}"
exec python3 "${DIR}/usr/bin/shellstone.py" "$@"
APPRUN
chmod +x "$APPDIR/AppRun"
rm -rf "$APPDIR/usr/bin/.git"

echo "==> Building AppImage..."
ARCH=x86_64 appimagetool --no-appstream "$APPDIR" "$OUTPUT"

echo "==> Done! AppImage: $OUTPUT"
ls -lh "$OUTPUT"

echo "==> Removing tmp ./AppDir..."
rm -rf "$APPDIR" 2>/dev/null
