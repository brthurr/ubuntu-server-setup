# Bash setup script for Ubuntu servers
[![Build Status](https://travis-ci.org/jasonheecs/ubuntu-server-setup.svg?branch=master)](https://travis-ci.org/jasonheecs/ubuntu-server-setup)

This is a setup script to automate the setup and provisioning of Ubuntu servers. This is based on code from https://github.com/jasonheecs/ubuntu-server-setup and https://gist.github.com/waleedahmad/a5b17e73c7daebdd048f823c68d1f57a.

It does the following:
* Updates APT and upgrades installed Ubuntu packages
* Installs build-essentials and other Python build prerequisites
* Installs ZSH, ZSH-oh-my-god, powerlevel10k theme and addins
* Copies pre-configured powerlevel10k configuration
* Installs pyenv and related tools for Python virtual envs
* Optional installation of MySQL, PostgreSQL-14, NGINX and Zip/Unzip (more to come)
* Setup the timezone for the server (Default to "America/Chicago")
* Asks to change default shell to zsh

# Installation
SSH into your server and install git if it is not installed:
```bash
sudo apt-get update
sudo apt-get install git
```

Clone this repository into your home directory:
```bash
cd ~
git clone https://github.com/brthurr/ubuntu-server-setup.git
```

Run the setup script
```bash
cd ubuntu-server-setup
bash setup.sh
```

# Setup prompts
Most of this installation is automated.

You will be prompted to install MySQL, etc. with whiptail. These are optional.

Finally, you will be prompted to specify a [timezone](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) for the server. It will be set to 'America/Chicago' if you do not specify a value.

# Supported versions
This setup script has been tested against Ubuntu 22.04.

# Running tests
Tests are run against a set of Vagrant VMs. To run the tests, run the following in the project's directory:  
`./tests/tests.sh`
