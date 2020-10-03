#!/bin/bash
# Installs the docker-compose services helper script and aliases

SCRIPT_PATH="$(
    cd "$(dirname "$0")"
    pwd -P
)"
BIN_PATH="$SCRIPT_PATH/bin"
ALIAS_HELPERS_FILE="$SCRIPT_PATH/bin/.drun_alias_helpers"

if ! [ -x "$(command -v docker)" ]; then
    printf "\e[31m[ERROR]\e[39m You need to install [docker].\n"
    exit 1
fi
if ! [ -x "$(command -v docker-compose)" ]; then
    printf "\e[31m[ERROR]\e[39m You need to install [docker-compose].\n"
    exit 1
fi

output() {
    printf "%s \e[32m%s\e[39m" "$1" >/dev/stderr
    if [[ ! -z "$2" ]]; then
        printf "\e[34m%s\e[39m" "[$2]" >/dev/stderr
    fi
}

continueYesNo() {
    output "$1" "Y/n"
    read -n 1 -r
    echo # (optional) move to a new line
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        # 0 = true
        return 0
    else
        # 1 = false
        return 1
    fi
}

if [ -f "$HOME/.bashrc" ]; then
    PROFILE_FILE="$HOME/.bashrc"
elif [ -f "$HOME/.zshrc" ]; then
    PROFILE_FILE="$HOME/.zshrc"
elif [ -f "$HOME/.zprofile" ]; then
    PROFILE_FILE="$HOME/.zprofile"
else
    printf "\e[31m[ERROR]\e[39m %s\n" "No ~/.bashrc, ~/.zshrc or ~/.zprofile found. Can't continue."
    exit 1
fi

ask="Install the utilities script?"
if continueYesNo "$ask"; then
    # Add the PATH to the bin folder
    echo -e "PATH=\$PATH:$BIN_PATH" >> $PROFILE_FILE

    # Create the docker network that will be used by the services and traefik
    docker network create dev-net-trfk

    # Some of the services require an allready build directory path because of user rights
    # Here we create those that we know for sure that are needed. More to come ... maybe?
    mkdir -p "$SCRIPT_PATH/.containers_home/dev-elasticsearch/es-data"
    mkdir -p "$SCRIPT_PATH/.containers_home/dev-elasticsearch/es-backups"

    ask="Install the alias helpers?"
    if continueYesNo "$ask"; then
        # Add the file of aliases if it exists
        if [ -f $ALIAS_HELPERS_FILE ]; then
            echo -e "if [ -f $ALIAS_HELPERS_FILE ]; then \n\t. $ALIAS_HELPERS_FILE \nfi" >> $PROFILE_FILE
        fi
    fi
    printf "\e[32m%s\e[39m\n" "success"
fi
