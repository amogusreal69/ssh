#!/bin/bash

# amogus's SSH key manager
#
# This script is used as a way to help users as fast as possible by instead of sharing their server's password, they add my SSH key, and I have access to their server.
# Idea inspired by Virtfusion
# This is the old version of the script, which is no longer maintained, accessible via:
#   $ wget -qO- https://ssh.amogus.works/old.sh | bash
#
# We recommend using the new version of the script, accessible via:
#   $ wget -qO- https://ssh.amogus.works/script.sh | bash
# 
# Have fun! Made with ❤️ by amogus

RED="\e[1;31m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
ENDCOLOR="\e[0m"

help() {
     echo "";
     echo "Usage: script.sh [add|remove|check]";
     echo "";
     exit 0;
}

case "$1" in
        --help|help|-h)
                help
                ;;
esac

SSH_KEY=''
TMP_DOWNLOAD_LOCATION=/tmp
OPTION=$1;

if [ "$OPTION" == 'add' ]; then
        mkdir -p ~/.ssh
        chmod 700 ~/.ssh
        touch ~/.ssh/authorized_keys
        IS_KEY_INSTALLED=$(cat ~/.ssh/authorized_keys | grep -w amogusreal69420@proton.me)
        if [ "${IS_KEY_INSTALLED}" == "" ]; then
                echo -e "\nDownloading SSH key."
                wget https://ssh.amogus.works/keys/ssh_key.pub -O ${TMP_DOWNLOAD_LOCATION}/__tmp___amogus___key >/dev/null 2>&1
                echo -e "Downloading SSH key check."
                wget https://ssh.amogus.works/keys/checksum/ssh_key.checksum -O ${TMP_DOWNLOAD_LOCATION}/__tmp___amogus__key___check >/dev/null 2>&1
                CHECKSUM=$(cat ${TMP_DOWNLOAD_LOCATION}/__tmp___amogus__key___check | awk '{ print $1 }')
                KEYSUM=$(sha1sum ${TMP_DOWNLOAD_LOCATION}/__tmp___amogus___key | awk '{ print $1 }')
                if [ "${CHECKSUM}" == "${KEYSUM}" ]; then
                        SSH_KEY=$(cat ${TMP_DOWNLOAD_LOCATION}/__tmp___amogus___key)
                        echo "${SSH_KEY}" >> ~/.ssh/authorized_keys
                        rm -f ${TMP_DOWNLOAD_LOCATION}/__tmp___amogus___key
                        rm -f ${TMP_DOWNLOAD_LOCATION}/__tmp___amogus__key___check
                        echo -e "\n${GREEN}SSH key installed successfully.${ENDCOLOR}\n"
                else
                        echo -e "\n${RED}SSH key check failed.${ENDCOLOR}\n"
                fi
        else
                echo -e "\n${YELLOW}SSH key is already installed!${ENDCOLOR}\n"
        fi
        chmod 600 ~/.ssh/authorized_keys

        elif [ "$OPTION" == 'remove' ]; then
                IS_KEY_INSTALLED=$(cat ~/.ssh/authorized_keys | grep -w amogusreal69420@proton.me)
                if [ "${IS_KEY_INSTALLED}" == "" ]; then
                        echo -e "\n${RED}SSH key not found!${ENDCOLOR}\n"
                else
                        sed -i '/amogusreal69420@proton.me/ d' ~/.ssh/authorized_keys
                        echo -e "\n${GREEN}SSH key removed successfully.${ENDCOLOR}\n"
                fi
        elif [ "$OPTION" == 'check' ]; then
                IS_KEY_INSTALLED=$(cat ~/.ssh/authorized_keys | grep -w amogusreal69420@proton.me)
                if [ "${IS_KEY_INSTALLED}" == "" ]; then
                        echo -e "\n${YELLOW}SSH key is NOT installed.${ENDCOLOR}\n"
                else
                        echo -e "\n${YELLOW}SSH key IS installed.${ENDCOLOR}\n"
                fi
        else
                help
fi