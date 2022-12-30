#!/bin/bash

# Setup the ZSH
function setupZsh() {
    sudo apt-get install zsh
    yes y | sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
    git clone https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k
    echo -e "$(cat pl10kconfig.cfg)\n\n$(cat ~/.zshrc)" > ~/.zshrc
    sed -i 's/robbyrussell/powerlevel10k\/powerlevel10k/gi' ~/.zshrc
    echo '[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh' >> ~/.zshrc
    cp .p10k.zsh ~/.p10k.zsh
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    sed -i 's/(git)/(git zsh-syntax-highlighting zsh-autosuggestions)/gi' ~/.zshrc
}

# Set the machine's timezone
# Arguments:
#   tz data timezone
function setTimezone() {
    local timezone=${1}
    sudo timedatectl set-timezone ${timezone}
}

function updateServer() {
    sudo apt-get update
    sudo apt-get install -y dialog
    sudo apt-get install build-essential -y
    sudo apt-get install libssl-dev libffi-dev libncurses5-dev zlib1g zlib1g-dev libreadline-dev libbz2-dev libsqlite3-dev -y
    sudo apt-get -y upgrade
}

function setupPyEnv() {
    sh -c "$(curl https://pyenv.run)"
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
    echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
    echo 'eval "$(pyenv init -)"' >> ~/.zshrc
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.zshrc
}

function installPackages(){
    cmd=(whiptail --separate-output --title "Package Installation" --checklist "Please Select Software you want to install:" 22 76 16)
	options=(1 "MySQL" off    # any option can be set to default to "on"
	         2 "PostgreSQL-14" off
	         3 "NGINX" off
	         4 "Zip/Unzip" off
    )
    choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
	clear   
    for choice in $choices
		do
		    case $choice in
	        	1)
                    echo "Installing Mysql Server" >&3
                    sudo apt-get install mysql-server -y
                    ;;
                2)
                    echo "Installing PostgreSQL-14" >&3
                    sudo apt-get install postgresql-14 -y
                    ;;
                3)
                    echo "Installing NGINX" >&3
                    sudo apt-get install nginx -y
                    ;;
                4)
                    echo "Installing Zip/Unzip" >&3
                    sudo apt-get install zip unzip -y
                    ;;
            esac
        done
}

function changeShell() {    
    while true; do
    echo -ne "Do you want to change your shell to zsh? (Recommended) [Y/N] " >&3
    read -r yn
    case $yn in
        [Yy]* ) make install; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done
}