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

# === Create the .desktop entry ===
DESKTOP_FILE="$HOME/.local/share/applications/Oasys.desktop"

cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Type=Application
Name=Oasys
Exec=sh -c "$HOME/.local/bin/start_oasys.sh > $HOME/.oasys/logs/oasys.log 2>&1"
Icon=oasys
EOF

echo "✅ Desktop entry created at: $DESKTOP_FILE"

#
# === Update desktop entry database ===
update-desktop-database "$HOME/.local/share/applications"
echo "✅ Desktop database updated"

# === Done ===
echo "🎉 Oasys desktop integration completed!"
echo "You can now find Oasys in your application launcher."
echo "Double-clicking a .ows file or dragging it onto the Oasys icon will open it."
