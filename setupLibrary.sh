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
    for choice in $choices
		do
		    case $choice in
	        	1)
                    echo "Installing Mysql Server"
                    sudo apt-get install mysql-server -y
                    ;;
                2)
                    echo "Installing PostgreSQL-14"
                    sudo apt-get install postgresql-14 -y
                    ;;
                3)
                    echo "Installing NGINX"
                    sudo apt-get install nginx -y
                    ;;
                4)
                    echo "Installing Zip/Unzip"
                    sudo apt-get install zip unzip -y
            esac
        done
}