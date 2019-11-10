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
   /usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
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

sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

source ~/.zshrc
p10k configure
mkdir $ZSH_CUSTOM/colors
cp $(dirname $0)/powerlevel10k/p10k.solarized.zsh $ZSH_CUSTOM/colors/ 
ln -sf $ZSH_CUSTOM/colors/p10k.solarized.zsh $HOME/.p10k.zsh

