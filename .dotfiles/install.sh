#!/bin/bash

echo -n "Name: "
read name
echo -n "E-mail: "
read email

sudo apt install -y vim cmake tmux git

git config --global user.name $name
git config --global user.email $email  

# Clone this repository and apply the dotfiles to the HOME directory
git clone --bare git@github.com:johanLsp/Dotfiles.git $HOME/.dotfiles
function dotfiles {
   git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}
mkdir -p .dotfiles-backup
dotfiles checkout
if [ $? = 0 ]; then
  echo "Checked out dotfiles.";
  else
    echo "Backing up pre-existing dotfiles.";
    dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .dotfiles-backup/{}
fi;
dotfiles checkout
dotfiles config status.showUntrackedFiles no


# Install scmpuff
arch=$(dpkg --print-architecture)
if [[ $arch == "armhf" ]]; then
  cp $(dirname $0)/bin/scmpuff-arm /usr/local/bin/
else
  wget https://github.com/mroth/scmpuff/releases/download/v0.3.0/scmpuff_0.3.0_linux_x64.tar.gz -P /tmp/
  tar -xf /tmp/scmpiff_0.3.0_linux_x64.tar.gz -C /tmp/
  mv /tmp/scmpuff /usr/local/bin/
fi


sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

source ~/.zshrc
p10k configure
ln -sf $(dirname $0)/powerlevel10k/p10k.solarized.zsh $HOME/.p10k.zsh

