#!/bin/bash

# === Global variables should be set in the main script ===

setup_logging() {
    echo "Setting up logging..."
    mkdir -p "$CUR_PATH/logs"
    TIMESTAMP=$(date +'%Y-%m-%d_%H-%M-%S')
    LOG_FILE="$CUR_PATH/logs/install_oasys_$TIMESTAMP.log"
    exec > >(tee -a "$LOG_FILE") 2>&1
    echo -e "\n\n"
}


check_git() {
    echo "Checking if git is installed..."
    type git >/dev/null 2>&1 || ./aux_bin/check_git.sh
    type git >/dev/null 2>&1 || exit 1
    echo -e "\n\n"
}

prepare_miniconda_folder() {
    echo "Preparing miniconda folder. Miniconda will be installed in $MINICONDA_HOME"   
    echo "It is recommended to not use the Oasys miniconda installation for other purposes."
    mkdir -p "$OASYS_FOLDER"
    if [ -d "$MINICONDA_HOME" ]; then
        read -p "Delete or Rename previous Miniconda3 installation? ([D]/r): " -n 1 -r
        echo
        if [[ "$REPLY" =~ ^[Rr]$ ]]; then
            mv "$MINICONDA_HOME" "$HOME/miniconda3_$(date +'%d-%m-%Y_%H-%M-%S')"
            echo "Previous installation renamed."
        else
            rm -rf "$MINICONDA_HOME"
            echo "Previous installation removed."
        fi
    else
        echo "Miniconda 3 not previously installed."
    fi
    echo -e "\n\n"
}

download_installer() {
    if [ ! -f "$INSTALLER" ]; then
        echo "Downloading Miniconda Installer ..."
        wget "$INSTALLER_URL"
        chmod +x "$INSTALLER"
    else
        echo "Miniconda Installer already downloaded."
    fi
    echo -e "\n\n"
}

deactivate_existing_conda() {
    echo "Deactivating any existing conda environment..."
    if command -v conda >/dev/null 2>&1; then
        __conda_setup="$("conda" shell.bash hook 2> /dev/null)"
        eval "$__conda_setup"
        if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
            echo "Deactivating existing conda environment: $CONDA_DEFAULT_ENV"
            conda deactivate
        fi
    fi
    echo -e "\n\n"
}

install_miniconda() {
    echo "Installing Miniconda at $MINICONDA_HOME"
    bash "$INSTALLER" -b -p "$MINICONDA_HOME"
    echo "Miniconda installed to $MINICONDA_HOME"
    echo -e "\n\n"
}

install_oasys_dependencies() {
    echo "Installing OASYS and dependencies..."
    source "$MINICONDA_HOME/etc/profile.d/conda.sh"
    conda activate base
    "$MINICONDA_HOME/bin/python" -m pip install --upgrade pip

    echo "Installing xraylib (may take a few minutes)..."
    conda install -y -c conda-forge xraylib=4.1.2
    echo "xraylib installed."

    echo "Installing OASYS..."
    "$MINICONDA_HOME/bin/python" -m pip install oasys1
    echo "OASYS installed."
    echo -e "\n\n"
}

install_qt_plugins() {
    echo "Installing Qt5 style plugins for GUI"
    if command -v apt >/dev/null 2>&1; then
        sudo apt install -y qt5-style-plugins
    elif command -v yum >/dev/null 2>&1; then
        sudo yum install -y qt5-style-plugins
    fi
    echo -e "\n\n"
}

launch_oasys() {
    echo "Starting OASYS..."
    echo "Upgrade the packages"
    "$AUX_PATH/start_oasys.sh"
    echo -e "\n\n"
}

create_desktop_shortcut() {
    read -p "Create Desktop Application (requires sudo grants)? ([Y]/n): " -n 1 -r
    echo
    if [[ ! "$REPLY" =~ ^[Nn]$ ]]; then
        "$AUX_PATH/create_desktop_application.sh" "$AUX_PATH"
    fi
    echo -e "\n\n"
}

final_message() {
    echo "📝 Full log saved to $LOG_FILE"
    echo "✅ Installation completed."
    echo "Start OASYS and install the required add-ons."
}