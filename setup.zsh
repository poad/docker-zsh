#!/usr/bin/env zsh

git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

git clone git://github.com/zsh-users/zsh-completions.git  "${ZDOTDIR:-$HOME}/.zsh-completions"

mkdir -p $HOME/.zsh
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o $HOME/.zsh/git-completion.bash
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh -o $HOME/.zsh/_git
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o $HOME/.zsh/git-prompt.sh
