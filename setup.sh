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
    setupZsh

    echo "Upgrading server... " >&3
    updateServer
    
    echo "Configuring System Time... " >&3
    setupTimezone

    echo "Installing packages... " >&3
   
    installPackages
    
    changeShell

    echo "Setup Done! Log file is located at ${output_file}." >&3

    exit 0

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
