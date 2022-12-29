#!/bin/bash

# Setup the ZSH
function setupZsh() {
    sudo apt-get install zsh
}

# Set the machine's timezone
# Arguments:
#   tz data timezone
function setTimezone() {
    local timezone=${1}
    sudo timedatectl set-timezone ${timezone}
}