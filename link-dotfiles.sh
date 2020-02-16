#! /bin/bash

install-vim-plug () {
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

install-oh-my-zsh () {
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/.powerlevel10k
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

make-backup () {
  if [[ -f $1 ]] && [[ ! -L $1 ]] 
  then
    new_path="$(dirname $1)/backup.of.$(basename $1)"
    echo "Making a backup of non-symlinked $1 to ${new_path}"
    mv $1 ${new_path}
  fi
}

mkdir -p ~/src/bin
mkdir -p ~/.config/fish
mkdir -p ~/.config/nvim

[[ -d ~/.oh-my-zsh ]] || install-oh-my-zsh

[[ -f ~/.local/share/nvim/site/autoload/plug.vim ]] || install-vim-plug

make-backup ~/.config/fish/config.fish 
make-backup ~/.config/nvim/init.vim
make-backup ~/.zshrc
make-backup ~/.gitconfig

ln -sf $(pwd)/fish/config.fish ~/.config/fish/config.fish
ln -sf $(pwd)/nvim/init.vim ~/.config/nvim/init.vim
ln -sf $(pwd)/zsh/.zshrc ~/.zshrc
ln -sf $(pwd)/.gitconfig ~/.gitconfig

for file in fish/.{functions,exports,aliases,*$(uname)}
do
  make-backup ~/.config/${file}
  echo "Linking ${file}..."
  ln -sf $(pwd)/${file} ~/.config/${file}
done

