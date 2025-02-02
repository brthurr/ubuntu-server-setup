#!/bin/bash

# Setup the ZSH
function setupZsh() {
    sudo apt-get install zsh -y
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
    sudo apt-get -y upgrade
    sudo apt-get install whiptail -y # Used for install packages later
}

function setupPyEnv() {
    sudo apt install build-essential libssl-dev zlib1g-dev \
    libbz2-dev libreadline-dev libsqlite3-dev curl llvm \
    libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
    libffi-dev liblzma-dev libpq-dev -y
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
             5 "Postfix" off
             6 "PyEnv" off
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
                    sudo snap install --classic certbot
                    ;;
                4)
                    echo "Installing Zip/Unzip" >&3
                    sudo apt-get install zip unzip -y
                    ;;
                5)
                    echo "Installing Postfix" >&3
                    sudo apt-get install postfix -y
                    ;;
                6)
                    echo "Install pyenv... " >&3
                    setupPyEnv
                    ;;
            esac
        done
}

function changeShell() {    
    while true; do
    echo -ne "Do you want to change your shell to zsh? (Recommended) [Y/N] " >&3
    read -r yn
    case $yn in
        [Yy]* ) sudo chsh -s $(which zsh) $(whoami); break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done
}
