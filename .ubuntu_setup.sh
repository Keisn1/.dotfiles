# a comment
sudo apt update && sudo apt upgrade

sudo apt install git-all

git config --global user.name "Keisn1"
git config --global user.email kay.freyer@icloud.com

git clone https://github.com/Keisn1/.dotfiles.git
cd ~/.dotfiles
git checkout ubuntu_asus
git pull origin ubuntu_asus
cd

sudo apt install ubuntu-restricted-extras

FONT_VERSION=$(curl -s "https://api.github.com/repos/JetBrains/JetBrainsMono/releases/latest" | grep -Po '"tag_name": "v\K[0-9.]+')
curl -sSLo jetbrains-mono.zip https://download.jetbrains.com/fonts/JetBrainsMono-$FONT_VERSION.zip
unzip -qq jetbrains-mono.zip -d jetbrains-mono
sudo mkdir ~/.local/share/fonts/
sudo mkdir ~/.local/share/fonts/jetbrains-mono-nerd/
sudo mv jetbrains-mono/fonts/ttf/*.ttf ~/.local/share/fonts/jetbrains-mono-nerd/
rm -r jetbrains-mono
rm jetbrains-mono.zip

sudo apt install gnome-tweaks dconf-editor

dconf load / < ~/.dotfiles/gnome/dconf-settings-asus-ubuntu.ini

dconf load /org/gnome/terminal/legacy/profiles:/:b1dcc9dd-5262-4d8d-a863-c897e6d979b9/ < ~/.dotfiles/terminal/profiles/ubuntu1.dconf

sudo apt install emacs          # no email configuration
git clone --depth 1 https://github.com/doomemacs/doomemacs ~/.config/emacs
PATH=$PATH:~/.config/emacs/bin
doom install

sudo apt install git-core zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
sudo apt install fonts-powerline
git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.oh-my-zsh/custom/plugins/
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/

sudo apt-get -y install stow

sudo apt-get install keychain
eval $(keychain --eval ~/.ssh/KayProAsusUbuntu_rsa)
# eval "$(ssh-agent -s)"
# ssh-add ~/.ssh/KayProAsusUbuntu_rsa

git clone https://github.com/pyenv/pyenv.git ~/.pyenv
pyenv install $(pyenv install --list | grep -v - | grep -v b | grep 3.11 | tail -n 1)

 pip install ~/.dotfiles/python/requirements-dev.txt
