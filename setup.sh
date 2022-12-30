#!/bin/bash

set -e

function getCurrentDir() {
    local current_dir="${BASH_SOURCE%/*}"
    if [[ ! -d "${current_dir}" ]]; then current_dir="$PWD"; fi
    echo "${current_dir}"
}

function includeDependencies() {
    # shellcheck source=./setupLibrary.sh
    source "${current_dir}/setupLibrary.sh"
}

current_dir=$(getCurrentDir)
includeDependencies
output_file="output.log"

function main() {
    logTimestamp "${output_file}"
    exec 3>&1 >>"${output_file}" 2>&1

    echo "Installing and configuring ZSH/ZSH-OMG and Powerlevel10k " >&3
    #setupZsh

    echo "Upgrading server... " >&3
    #updateServer
    
    echo "Configuring System Time... " >&3
    #setupTimezone

    echo "Install pyenv... " >&3
    #setupPyEnv

    echo "Installing packages... " >&3
    cmd=(whiptail --title "Package Installation" --checklist --separate-output "Please Select Software you want to install:" 22 76 16)
    options=(
            1 "MySQL" off    # any option can be set to default to "on"
	        2 "PostgreSQL-14" off
	        3 "NGINX" off
	        4 "Zip/Unzip" off
	        )
	choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    installPackages
    
    while true; do
        read -p "Do you want to change your shell to zsh now? (Recommended) [Y/N] " yn
        case $yn in
            [Yy]* ) sudo chsh -s $(which zsh) $(whoami); break;;
            [Nn]* ) break;;
            * ) echo "Please answer yes or no.";;
        esac
    done

    echo "Setup Done! Log file is located at ${output_file}. Logout and back in to use zsh." >&3

}

function logTimestamp() {
    local filename=${1}
    {
        echo "===================" 
        echo "Log generated on $(date)"
        echo "==================="
    } >>"${filename}" 2>&1
}

function setupTimezone() {
    echo -ne "Enter the timezone for the server (Default is 'America/Chicago'):\n" >&3
    read -r timezone
    if [ -z "${timezone}" ]; then
        timezone="America/Chicago"
    fi
    setTimezone "${timezone}"
    echo "Timezone is set to $(cat /etc/timezone)" >&3
}

main
