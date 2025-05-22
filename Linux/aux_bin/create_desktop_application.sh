#!/bin/bash
set -e

# === INPUT ARGUMENT ===
# AUX_PATH is the path where oasys.png and start_oasys.sh are located
AUX_PATH="$1"

# === Move Icon and start script to standard locations ===
echo "Moving icon and start script to standard locations..."
mkdir -p ~/.local/share/icons
cp "$AUX_PATH/oasys.png" ~/.local/share/icons/oasys.png

mkdir -p ~/.local/bin
cp "$AUX_PATH/start_oasys.sh" ~/.local/bin/start_oasys.sh
chmod +x ~/.local/bin/start_oasys.sh

# === Ensure local application and MIME directories exist ===
mkdir -p "$HOME/.local/share/applications"
mkdir -p "$HOME/.local/share/mime/packages"

# === Create the .desktop entry ===
DESKTOP_FILE="$HOME/.local/share/applications/Oasys.desktop"

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Type=Application
Name=Oasys
Comment=Open Source X-ray Optics Workbench
Exec=$HOME/.local/bin/start_oasys.sh %f
Icon=oasys
Terminal=false
Categories=Education;Science;
MimeType=application/x-oasys-project;
EOF

echo "✅ Desktop entry created at: $DESKTOP_FILE"

# === Register the custom MIME type for .ows files ===
MIME_XML="$HOME/.local/share/mime/packages/oasys.xml"

cat > "$MIME_XML" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
  <mime-type type="application/x-oasys-project">
    <comment>Oasys Project File</comment>
    <glob pattern="*.ows"/>
  </mime-type>
</mime-info>
EOF

echo "✅ MIME type definition created at: $MIME_XML"

# === Update MIME database ===
update-mime-database "$HOME/.local/share/mime"
echo "✅ MIME database updated"

# === Add custom icon for .ows files ===
echo "Installing icon for .ows files..."
ICON_TARGET="$HOME/.local/share/icons/hicolor/48x48/mimetypes/application-x-oasys-project.png"
mkdir -p "$(dirname "$ICON_TARGET")"
cp "$AUX_PATH/oasys.png" "$ICON_TARGET"

ICON_THEME_DIR="$HOME/.local/share/icons/hicolor"
INDEX_FILE="$ICON_THEME_DIR/index.theme"

if [ ! -f "$INDEX_FILE" ]; then
    echo "[Icon Theme]
Name=Hicolor
Comment=Fallback icon theme
Directories=48x48/mimetypes

[48x48/mimetypes]
Size=48
Context=Mimetype
Type=Fixed" > "$INDEX_FILE"
fi


# gtk-update-icon-cache "$HOME/.local/share/icons/hicolor"
# echo "✅ Custom icon registered for .ows files"

# === Update desktop entry database ===
update-desktop-database "$HOME/.local/share/applications"
echo "✅ Desktop database updated"

# === Done ===
echo "🎉 Oasys desktop integration completed!"
echo "You can now find Oasys in your application launcher."
echo "Double-clicking a .ows file or dragging it onto the Oasys icon will open it."
