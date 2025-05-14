#!/bin/bash

clear
echo "========================================================="
echo "          @alexandrglm/easyenv - v1.1"
echo ""
echo "         IntelliJ + OpenJDK 17 non system-wide"
echo "========================================================="
echo "Before proceeding, please:"
echo ""
echo "1. Make sure you've installed required build packages"
echo "   via apt/dnf/pkg, or from their sources."
echo ""
echo "    Common building dependencies:"
echo ""
echo "    openjdk-17-jdk git curl autoconf libfreetype6-dev libfontconfig-dev libcups2-dev libx11-dev libxext-dev libxrender-dev libxrandr-dev libxtst-dev libxt-dev libasound2-dev libffi-dev debootstrap gcc clang g++ build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev liblzma-dev uuid-dev libgdbm-dev libnss3-dev libgdbm-compat-dev libdb-dev libexpat1-dev libmpdec-dev libedit-dev libbluetooth-dev libxslt1-dev libssl3 libtirpc-dev libgmp-dev lzma lzma-dev pkg-config ..."
echo ""
echo ""
echo "2. This script targets:"
echo ""
echo "  ->   OpenJDK 17"
echo "  ->   IntelliJ latest version"
echo "  -> x86_64 architecture"
echo ""
echo "Your system arch is:     $(uname -m)"
echo ""
echo "========================================================="
echo ""
read -p "Type (yes)/(y) to continue:  " YES
if [[ ! "$YES" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo ""
    echo "Aborting installation. Please satisfy all requirements and try again."
    exit 1
fi

echo ""
echo "========================================================="
echo ""
while true; do

    read -p "Choose IDEA IntelliJ Version (e.g., 2023.1, 2024.3, etc.): " INTELLIJ_VER

    if [[ "$INTELLIJ_VER" =~ ^20[0-9]{2}\.[0-9]+$ ]]; then
        break

    else

        echo ""
        echo "ERROR -> Please enter a valid version in format 20xx.x (e.g., 2023.1)"

    fi
done

while true; do

    echo "========================================================="
    echo "Set IDEA IntelliJ installation directory name (no paths, just folder name): "

    read -p "Folder name: " VENV_DIR
    
    if [[ "$VENV_DIR" =~ ^[a-zA-Z0-9._-]+$ ]]; then

        INSTALL_DIR="$PWD/$VENV_DIR/IntelliJ_IDE_$INTELLIJ_VER"
        mkdir -p "$INSTALL_DIR"

        break


    else
        echo ""
        echo "ERROR -> Folder name must only contain alphanumeric characters, dots, dashes or underscores."
    fi

done


echo "Downloading IntelliJ IDEA $INTELLIJ_VER..."

wget "https://download.jetbrains.com/idea/ideaIC-$INTELLIJ_VER.tar.gz" -O "$INSTALL_DIR/ideaIC-$INTELLIJ_VER.tar.gz" || {
    echo "SORRY! -> Failed to download IntelliJ IDEA. Please check the version and run the script again."
    exit 1
}

echo "Extracting IntelliJ IDEA..."

tar -xvzf "$INSTALL_DIR/ideaIC-$INTELLIJ_VER.tar.gz" -C "$INSTALL_DIR" --strip-components=1 || {
    echo "Failed to extract IntelliJ IDEA archive."
    exit 1
}

rm -f "$INSTALL_DIR/ideaIC-$INTELLIJ_VER.tar.gz"


DESKTOP_ENTRY="$HOME/Desktop/intellij-$INTELLIJ_VER.desktop"

cat > "$DESKTOP_ENTRY" << EOF
[Desktop Entry]
Name=IntelliJ IDEA $INTELLIJ_VER
Type=Application
Exec=\"$INSTALL_DIR/bin/idea.sh\"
Terminal=false
Icon=$INSTALL_DIR/bin/idea.png
Comment=Integrated Development Environment
NoDisplay=false
Categories=Development;IDE;
Name[en]=IntelliJ IDEA $INTELLIJ_VER
EOF

chmod +x "$DESKTOP_ENTRY"

echo ""
echo "========================================================="
echo "IntelliJ IDEA $INTELLIJ_VER has been successfully installed!"
echo ""
echo "You can run it with:"
echo "1. Desktop application icon"
echo "2. Command: $INSTALL_DIR/bin/idea.sh"
echo ""
echo "Installation directory: $INSTALL_DIR"
echo "========================================================="