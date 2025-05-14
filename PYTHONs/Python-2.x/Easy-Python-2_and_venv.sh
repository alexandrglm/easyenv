#!/bin/bash

clear
echo "========================================================="
echo "          @alexandrglm/easyenv - v1.0"
echo ""
echo "         PYTHON 2.x BUILD + VENV SETUP"
echo "========================================================="
echo "Before proceeding, please:"
echo ""
echo "1. Make sure you've installed required build packages"
echo "   via apt/dnf/pkg, or from their sources."
echo ""
echo "    Common building dependencies:"
echo ""
echo "    autoconf build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev uuid-dev libgdbm-dev libnss3-dev libgdbm-compat-dev libdb-dev libexpat1-dev libmpdec-dev libedit-dev libbluetooth-dev libx11-dev libxext-dev libxrender-dev libxslt1-dev libssl3 libtirpc-dev libgmp-dev lzma lzma-dev pkg-config ..."
echo ""
echo ""
echo "2. This script targets:"
echo ""
echo "  -> PYTHON 2.X versions"
echo "  -> x86_64 architecture"
echo ""
echo "Your system arch is:     $(uname -m)"
echo ""
echo ""
echo "3. PIP for Python 2.6.x/2.7.x will be also downloaded."
echo ""
echo "4 Ensure your CPU/RAM can handle building from source"
echo "========================================================="
echo ""
read -p "Type (yes)/(y) to continue:  " YES
if [[ "$YES" =~ ^(yes|y|YES|Yes)$ ]]; then

    continue

else 

    echo ""
    echo "Confirm you have previously satisfied all the requirements by typping YES/yes!"

fi
clear
while true; do

    echo ""
    echo 'Set Python 2.x Version to install (e.g. 2.7.18, 2.6.9, ...): '
    echo ""
    read -p "(PYTHON VER?) ->   " PYTHON_VER
    
    if [[ "$PYTHON_VER" =~ ^[0-9]+(\.[0-9]+)+$ ]]; then

        break

    else

        echo ""
        echo "ERROR -> Invalid version. Use X.X or X.X.X (E.g. 2.6.9 / 2.7.18 / 2.0.1 )"
    fi

done
echo ""
while true; do
    
    echo "Set FOLDER NAME (not path) for Python & venv (e.g .venv ): "
    read -p "(PATH?) ->  " VENV_DIR

    if [[ "$VENV_DIR" =~ ^[a-zA-Z0-9._-]+$ ]]; then

        break

    else 

        echo ""
        echo "ERROR -> Venv folder name MUST NOT include PATH symbols ( / \ | $ ), excepting those allowed (. - _ )"
        echo ""
    fi   
done

echo "========================================================="
echo ""
echo "Source directory  -> $PWD"
echo ""
echo "Python Version    ->  $PYTHON_VER"
echo "PATH for venv     ->  $VENV_DIR"
echo ""
echo "Long compilation time may be apply."
echo "Even modules errors might appear, Py2.x compilation will success." 
echo "   P L E A S E ! ->   Wait until entire installation is done"
echo ""
echo "========================================================="
read -p "Type YES to confirm the actions:  " YES

if [ $YES = "YES" ]; then

    continue

else
    echo ""
    echo "========================================================="
    echo "Cancelled by the user, bye!"
    exit 1
fi
echo ""
echo "Proceeding ...."
echo "========================================================="
echo ""


PYTHON_VER=${PYTHON_VER}
VENV_DIR=${VENV_DIR}

mkdir -p "./$VENV_DIR"

wget "https://www.python.org/ftp/python/$PYTHON_VER/Python-$PYTHON_VER.tgz"
tar -xvzf "./Python-$PYTHON_VER.tgz"
rm -rf "./Python-$PYTHON_VER.tgz"
mv "./Python-$PYTHON_VER" "./$VENV_DIR/$PYTHON_VER"

cd "./$VENV_DIR/$PYTHON_VER"
./configure --enable-optimizations --prefix="$PWD/../../$VENV_DIR/$PYTHON_VER/install"


make -k -j"$(nproc)"
make install

cd ../../
find "./$VENV_DIR/$PYTHON_VER/" -mindepth 1 ! -path "./$VENV_DIR/$PYTHON_VER/install*" -exec rm -rf {} +
cd "./$VENV_DIR/$PYTHON_VER"

echo ""
echo "========================================================="
echo ""
echo "Python $PYTHON_VER has been succesfully installed!"
echo ""
echo "As long as 'pip' is only available for 2.6.x // 2.7.x,"
echo "we are going to try downloaing pip bin."
echo ""
echo "You can try installing PIP for another Python 2.x version, but"
echo "in case it fails, you can also use Python 2.x by setting the "
echo "env PATH manually"

if [[ "$PYTHON_VER" < "2.7"  ]]; then

    wget "https://bootstrap.pypa.io/pip/2.6/get-pip.py" -O "./install/bin/get-pip.py"

else

    wget "https://bootstrap.pypa.io/pip/2.7/get-pip.py" -O "./install/bin/get-pip.py"

fi

"./install/bin/python" "./install/bin/get-pip.py"
"./install/bin/pip" install --upgrade pip setuptools virtualenv
"./install/bin/virtualenv" "$PWD/../../$VENV_DIR/"

echo ""
echo "========================================================="
echo "Python $PYTHON_VER (non system-wide) as venv has been succesfully installed for this project!"
echo "-> Now, you can 'source ./$VENV_DIR/bin/activate' this project's venv!"
exit 0


