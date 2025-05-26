#!/bin/bash
set -e

# === Define paths ===
OASYS_FOLDER="$HOME/.oasys"
MINICONDA_HOME="$OASYS_FOLDER/miniconda3"
CUR_PATH="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUX_PATH="$CUR_PATH/aux_bin"
INSTALLER="Miniconda3-py38_4.12.0-Linux-x86_64.sh"
INSTALLER_URL="https://repo.continuum.io/miniconda/$INSTALLER"

# === Create OASYS and logs folders if they don't exist ===
mkdir -p "$OASYS_FOLDER"

# === Source functions ===
source ./oasys_install_lib.sh

# === Run installation steps ===
setup_logging
check_git
prepare_miniconda_folder
download_installer
deactivate_existing_conda
install_miniconda
install_oasys_dependencies
install_qt_plugins
launch_oasys
create_desktop_shortcut
final_message
