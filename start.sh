rm ~/.vimrc
rm ~/.tmux.conf
rm -rf ~/.vim
echo "ing..."

ln -s ~/dotfiles/vim ~/.vim
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/vimrc ~/.vimrc
