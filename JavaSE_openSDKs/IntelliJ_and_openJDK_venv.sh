#!/bin/bash

clear
echo "========================================================="
echo "          @alexandrglm/easyenv - v1.1"
echo ""
echo "  OpenJDK + IntelliJ IDEA (Local Setup with Project Dir)"
echo "========================================================="

JDK_selection() {
    echo "Available OpenJDK Versions :"
    echo "============================"
    echo "24 (Current stable)"
    echo "23 (Current stable)"
    echo "22 (Security updates only)"
    echo "21 (LTS - Long Term Support)"
    echo "20 (DEPRECATED - Unsupported)"
    echo "19 (DEPRECATED - Unsupported)"
    echo "18 (DEPRECATED - Unsupported)"
    echo "17 (LTS - Long Term Support)"
    echo "16 (DEPRECATED - Unsupported)"
    echo "15 (DEPRECATED - Unsupported)"
    echo "14 (DEPRECATED - Unsupported)"
    echo ""
    echo "Please, note that versions marked as DEPRECATED may contain vulnerabilities"
    echo "and there are available only to be used for legacy projects."
    echo ""

    while true; do

        read -p "Choose OpenJDK version (number only): " JDK_VER

        case $JDK_VER in
            14|15|16|17|18|19|20|21|22|23|24)
    
                if [[ "$JDK_VER" =~ ^(14|15|16|18|19|20)$ ]]; then
                    read -p "WARNING: Version $JDK_VER is DEPRECATED and potentially insecure. Continue? (y/n): " confirm
                    [[ "$confirm" =~ ^[Yy]$ ]] || continue
                fi
                break
                ;;
            *)
                echo "Invalid version. Please select from the list above."
                ;;
        esac
    done
}

IDEA_selection() {
    
    while true; do
    
        read -p "Enter IntelliJ IDEA version (e.g., 2023.1): " INTELLIJ_VER

        if [[ "$INTELLIJ_VER" =~ ^20[0-9]{2}\.[0-9]+(\.[0-9]+)?$ ]]; then
            
            break

        else

            echo ""
            echo "Invalid version format. Please use format 20xx.x or 20xx.x.x (e.g., 2023.1 or 2024.1.5)"
            echo ""
        fi
    done
}


install_JDK() {

    local JDK_VER=$1
    local INSTALL_DIR="$VENV_DIR/OpenJDK_$JDK_VER"


    echo "Setting up OpenJDK $JDK_VER in $INSTALL_DIR ..."

    mkdir -p "$INSTALL_DIR"
    cd "$INSTALL_DIR" || exit 1

    declare -A JDK_URLS=(
        ["14"]="https://download.java.net/openjdk/jdk14/ri/openjdk-14+36_linux-x64_bin.tar.gz"
        ["15"]="https://download.java.net/openjdk/jdk15/ri/openjdk-15+36_linux-x64_bin.tar.gz"
        ["16"]="https://download.java.net/openjdk/jdk16/ri/openjdk-16+36_linux-x64_bin.tar.gz"
        ["17"]="https://download.java.net/openjdk/jdk17/ri/openjdk-17+35_linux-x64_bin.tar.gz"
        ["18"]="https://download.java.net/openjdk/jdk18/ri/openjdk-18+36_linux-x64_bin.tar.gz"
        ["19"]="https://download.java.net/openjdk/jdk19/ri/openjdk-19+36_linux-x64_bin.tar.gz"
        ["20"]="https://download.java.net/openjdk/jdk20/ri/openjdk-20+36_linux-x64_bin.tar.gz"
        ["21"]="https://download.java.net/openjdk/jdk21/ri/openjdk-21+35_linux-x64_bin.tar.gz"
        ["22"]="https://download.java.net/openjdk/jdk22/ri/openjdk-22+36_linux-x64_bin.tar.gz"
        ["23"]="https://download.java.net/openjdk/jdk23/ri/openjdk-23+37_linux-x64_bin.tar.gz"
        ["24"]="https://download.java.net/openjdk/jdk24/ri/openjdk-24+36_linux-x64_bin.tar.gz"
    )

    echo "Downloading OpenJDK $JDK_VER ..."

    wget "${JDK_URLS[$JDK_VER]}" -O openjdk.tar.gz || {
        
        echo ""
        echo "ERROR -> Failed downloading SDK, check connection and try again!"
        echo ""

        return 1
    }

    echo "Extracting OpenJDK ..."

    tar -xzf openjdk.tar.gz --strip-components=1
    rm openjdk.tar.gz

    echo "OpenJDK $JDK_VER setup complete in $INSTALL_DIR"
}


install_IDEA() {

    local INTELLIJ_VER=$1
    
    local INSTALL_DIR="$VENV_DIR/IntelliJ_IDEA_$INTELLIJ_VER"

    echo "Downloading IntelliJ IDEA $INTELLIJ_VER ..."
    cd ../../

    curl -L -C - "https://download.jetbrains.com/idea/ideaIC-${INTELLIJ_VER}.tar.gz" --output "./ideaIC-${INTELLIJ_VER}.tar.gz"

    mkdir -p "$INSTALL_DIR"

    echo "Extracting IntelliJ IDEA ..."

    if ! tar -xzf "./ideaIC-${INTELLIJ_VER}.tar.gz" -C "$INSTALL_DIR" --strip-components=1; then

        echo ""
        echo "DEBUG -> WGET cannot download IntelliJ chosen version"
        echo ""
        echo "Anyway, we are also going to set default projects / env / paths / configs."
    fi

    rm -rf "./ideaIC-${INTELLIJ_VER}.tar.gz"

    echo "IntelliJ IDEA $INTELLIJ_VER installed in $INSTALL_DIR"
}



#Dialogs, execution

echo "========================================================="
read -p "Enter name for environment directory (will be created in current location): " VENV_DIR
mkdir -p "$VENV_DIR"

FULL_VENV_PATH="$(cd "$VENV_DIR" && pwd)"
FULL_PROJECT_PATH="$(cd .. && pwd)/project"

JDK_selection
install_JDK "$JDK_VER"

IDEA_selection
install_IDEA "$INTELLIJ_VER"


# IDEA & PROJECT congifurations
echo ""
echo "Creating config files and paths ...."

mkdir -p "../project"

IDEA_CONFIG_DIR="$VENV_DIR/.idea"

mkdir -p "$IDEA_CONFIG_DIR"

cat > "$IDEA_CONFIG_DIR/workspace.xml" <<EOF
<project version="4">
<component name="ProjectRootManager" version="2" project-jdk-name="OpenJDK_$JDK_VER" project-jdk-type="JavaSDK">
<output url="file://\$PROJECT_DIR$/../project/out" />
</component>
<component name="ProjectModuleManager">
<modules>
    <module fileurl="file://\$PROJECT_DIR$/../project/project.iml" filepath="\$PROJECT_DIR$/../project/project.iml" />
</modules>
</component>
</project>
EOF


cat > "../project/project.iml" <<EOF
<module type="JAVA_MODULE" version="4">
<component name="NewModuleRootManager" inherit-compiler-output="true">
<exclude-output />
<content url="file://\$MODULE_DIR$">
    <sourceFolder url="file://\$MODULE_DIR$/src" isTestSource="false" />
</content>
<orderEntry type="inheritedJdk" />
<orderEntry type="sourceFolder" forTests="false" />
</component>
</module>
EOF

mkdir -p "../project/src"

# VENV ACTIVATE
cat > "$VENV_DIR/activate" <<EOF
#!/bin/bash

if [ -z "\$JAVA_ENV_BACKUP" ]; then
    export JAVA_ENV_BACKUP_PATH="\$PATH"
    export JAVA_ENV_BACKUP_PS1="\$PS1"
    export JAVA_ENV_BACKUP_JAVA_HOME="\$JAVA_HOME"
fi


export JAVA_HOME="$FULL_VENV_PATH/OpenJDK_$JDK_VER"
export PATH="\$JAVA_HOME/bin:\$PATH"
export IDEA_HOME="$FULL_VENV_PATH/IntelliJ_IDEA_$INTELLIJ_VER"
alias idea="$FULL_VENV_PATH/IntelliJ_IDEA_$INTELLIJ_VER/bin/idea.sh"

export VENV_NAME="$(basename "$VENV_DIR")"
export PS1="(\$VENV_NAME) \$PS1"

echo "========================================================="
echo "Environment configured for:"
echo ""
echo " - OpenJDK $JDK_VER: \$JAVA_HOME"
echo " - IntelliJ IDEA $INTELLIJ_VER: \$IDEA_HOME"
echo " - Project directory: $FULL_PROJECT_PATH"
echo ""
echo "Type 'source ./$VENV_DIR/deactivate' to exit this environment"
EOF

# VENV DEACTIVATE
cat > "$VENV_DIR/deactivate" <<EOF
#!/bin/bash

if [ -n "\$JAVA_ENV_BACKUP_PATH" ]; then

    export PATH="\$JAVA_ENV_BACKUP_PATH"
    export PS1="\$JAVA_ENV_BACKUP_PS1"
    export JAVA_HOME="\$JAVA_ENV_BACKUP_JAVA_HOME"

    unset JAVA_ENV_BACKUP_PATH
    unset JAVA_ENV_BACKUP_PS1
    unset JAVA_ENV_BACKUP_JAVA_HOME
    unset IDEA_HOME
    unset VENV_NAME

    unalias idea 2>/dev/null

    echo "========================================================="
    echo "Environment restored to original state"
    echo "========================================================="

else

    echo "========================================================="
    echo "No Java environment active"
    echo "========================================================="
fi
EOF

# And Launcher
cat > "$VENV_DIR/launch_IntelliJ" <<EOF
#!/bin/bash

source "$FULL_VENV_PATH/activate"
"\$IDEA_HOME/bin/idea.sh" "\$FULL_PROJECT_PATH"
EOF

chmod +x "./$VENV_DIR/activate"
chmod +x "./$VENV_DIR/deactivate"
chmod +x "./$VENV_DIR/launch_IntelliJ"



echo "========================================================="
echo " OpenJDK + IntelliJ IDE installed!!!
echo "========================================================="
echo "Directory structure:"
echo ""
echo " - Environment: $FULL_VENV_PATH"
echo "   - OpenJDK: $FULL_VENV_PATH/OpenJDK_$JDK_VER"
echo "   - IntelliJ: $FULL_VENV_PATH/IntelliJ_IDEA_$INTELLIJ_VER"
echo " - Project: $FULL_PROJECT_PATH"
echo "========================================================="
echo ""
echo "To activate this environment:"
echo "  source $FULL_VENV_PATH/activate"
echo "========================================================="
echo "To launch IntelliJ with this project:"
echo "  $FULL_VENV_PATH/launch_idea"
echo "========================================================="
exit 0