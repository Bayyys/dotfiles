rm ~/.vimrc
rm ~/.tmux.conf
rm -rf ~/.vim
rm -rf ~/.jupyter
echo "ing..."

ln -s ~/dotfiles/vim ~/.vim
ln -s ~/dotfiles/tmux.conf ~/.tmux.conf
ln -s ~/dotfiles/vimrc ~/.vimrc
ln -s ~/dotfiles/jupyter ~/.jupyter
