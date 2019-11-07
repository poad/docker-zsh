FROM buildpack-deps:bionic-curl

LABEL maintenar="Kenji Saito <ken-yo@mbr.nifty.com>"

RUN apt-get update -qq \
 && apt-get full-upgrade -qqy \
 && apt-get install -qqy --no-install-recommends curl gnupg2 software-properties-common ca-certificates \
 && add-apt-repository ppa:git-core/ppa -y \
 && apt-get install -qqy --no-install-recommends git zsh \
 && chsh -s /usr/bin/zsh \
 && rm -rf /var/lib/apt/lists

RUN groupadd -g 1000 zsh \
 && useradd -g 1000 -l -m -s /usr/bin/zsh -u 1000 zsh

WORKDIR /home/zsh

USER zsh

COPY --chown=zsh:zsh setup.zsh /home/zsh/setup.zsh
COPY --chown=zsh:zsh assets/zshrc /tmp/zshrc

RUN chmod 744 $HOME/setup.zsh \
 && zsh -c $HOME/setup.zsh \
 && rm -rf setup.zsh \
 && rm -rf $HOME/.zprezto/runcoms/zshrc \
 && cat /tmp/zshrc > $HOME/.zprezto/runcoms/zshrc \
 && mv .zpreztorc .zpreztorc.bak \
 && sed -e "s/'sorin'/'redhat'/g" .zpreztorc.bak > .zpreztorc \
 && rm -rf .zpreztorc.bak /tmp/zshrc $HOME/.zprezto/modules/prompt/external/powerlevel9k/docker $HOME/.zsh-completions/.git $HOME/.zprezto/.git $HOME/.zprezto/modules/autosuggestions/external/Dockerfile

HEALTHCHECK CMD [ "zsh", "--version" ]

CMD [ "zsh" ]
