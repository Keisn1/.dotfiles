# a comment
sudo apt update && sudo apt upgrade
snap refresh

sudo apt install git-all

git config --global user.name "Keisn1"
git config --global user.email kay.freyer@icloud.com

git clone https://github.com/Keisn1/.dotfiles.git
cd ~/.dotfiles
git checkout ubuntu_asus
git pull origin ubuntu_asus
cd

sudo apt install ubuntu-restricted-extras

curl -OL https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
# FONT_VERSION=$(curl -s "https://api.github.com/repos/JetBrains/JetBrainsMono/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+')
# curl -sSLo jetbrains-mono.zip https://download.jetbrains.com/fonts/JetBrainsMono-$FONT_VERSION.zip
# unzip -qq jetbrains-mono.zip -d jetbrains-mono
unzip -qq JetBrainsMono.zip -d jetbrains-mono-nerd
sudo mkdir ~/.local/share/fonts/
sudo mv jetbrains-mono-nerd ~/.local/share/fonts
rm -r jetbrains-mono-nerd
rm JetBrainsMono.zip

sudo apt install gnome-tweaks dconf-editor

dconf load / < ~/.dotfiles/gnome/dconf-settings-asus-ubuntu.ini

dconf load /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ < ~/.dotfiles/terminal/profiles/ubuntu1.dconf

sudo snap install firefox

sudo apt install emacs          # no email configuration
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
PATH=$PATH:~/.config/emacs/bin
doom install

sudo apt install git-core zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

sudo apt install fonts-powerline

curl -sS https://starship.rs/install.sh | sh

git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

git clone https://github.com/jeffreytse/zsh-vi-mode $ZSH_CUSTOM/plugins/zsh-vi-mode

ssh-keygen -t ed25519 -C "kay.freyer@icloud.com"
# - ssh-keygen -t ed25519 -C "kay.freyer@icloud.com"
#   - save under .ssh/{username}{PC}{OS}_rsa
#   - add passphrase to lastPass {username}{PC}{OS}

sudo apt-get install keychain
eval $(keychain --eval ~/.ssh/KayProAsusUbuntu_rsa)
# eval "$(ssh-agent -s)"
# ssh-add ~/.ssh/KayProAsusUbuntu_rsa

sudo apt-get -y install stow
stow .

doom sync

sudo apt install ripgrep

sudo apt-get install markdown

sudo apt-get install wl-clipboard

sudo apt-get install gnome-screenshot

sudo apt-get install graphviz

sudo snap install shfmt

sudo apt install shellcheck

sudo apt install fd-find

sudo apt install gcc g++

sudo apt install nodejs

sudo apt install npm

git clone https://github.com/pyenv/pyenv.git ~/.pyenv
pyenv install $(pyenv install --list | grep -v - | grep -v b | grep 3.11 | tail -n 1)
pyenv global $(pyenv install --list | grep -v - | grep -v b | grep 3.11 | tail -n 1)

sudo apt install \
    build-essential \
    curl \
    libbz2-dev \
    libffi-dev \
    liblzma-dev \
    libncursesw5-dev \
    libreadline-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    libxmlsec1-dev \
    llvm \
    make \
    tk-dev \
    wget \
    xz-utils \
    zlib1g-dev

pip install ~/.dotfiles/python/requirements-dev.txt
