tmux
fish_vi_key_bindings

alias c "clear"
alias dotfile="/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME"

bind \cL 'clear; commandline -f repaint'

colorscript -r

