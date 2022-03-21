ARG DISTRIBUTION=ubuntu
ARG DIST_VERION_CODE=focal

FROM buildpack-deps:${DIST_VERION_CODE} AS downloader

RUN curl -sSL https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash -o /tmp/git-completion.bash \
 && curl -sSL https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh -o /tmp/_git \
 && curl -sSL https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh -o /tmp/git-prompt.sh \
 && git clone --recursive https://github.com/sorin-ionescu/prezto.git /tmp/prezto \
 && git clone https://github.com/zsh-users/zsh-completions.git /tmp/zsh-completions \
 && rm -rf /tmp/prezto/modules/prompt/external/powerlevel9k/docker /tmp/zsh-completions/.git /tmp/prezto/.git $/tmp/prezto/modules/autosuggestions/external/Dockerfile


FROM ${DISTRIBUTION}:${DIST_VERION_CODE}

LABEL maintenar="Kenji Saito <ken-yo@mbr.nifty.com>"

RUN export DEBIAN_FRONTEND="noninteractive" \
 && rm -rf /var/lib/apt/lists/* \
 && apt-get update -qq \
 && apt-get install -qqy --no-install-recommends gnupg2 ca-certificates software-properties-common \
 && add-apt-repository ppa:git-core/ppa -y \
 && apt-get update -qq \
 && apt-get install -qqy --no-install-recommends zsh \
 && chsh -s /usr/bin/zsh \
 && apt-get autoremove --purge -qqy ca-certificates gnupg2 software-properties-common \
 && apt-get autoremove --purge -qqy \
 && apt-get autoremove --purge -qqy --allow-remove-essential bash \ 
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/log/apt/* /var/log/alternatives.log /var/log/dpkg.log /var/log/faillog /var/log/lastlog \
 && unset DEBIAN_FRONTEND

RUN groupadd -g 10000 zsh \
 && useradd -g 10000 -l -m -s /usr/bin/zsh -u 10000 zsh

WORKDIR /home/zsh

USER zsh

COPY --chown=zsh:zsh setup.zsh /home/zsh/setup.zsh
COPY --chown=zsh:zsh assets/zshrc /tmp/zshrc
COPY --chown=zsh:zsh --from=downloader /tmp/git-completion.bash /home/zsh/.zsh/git-completion.bash
COPY --chown=zsh:zsh --from=downloader /tmp/_git /home/zsh/.zsh/_git
COPY --chown=zsh:zsh --from=downloader /tmp/git-prompt.sh /home/zsh/.zsh/git-prompt.sh
COPY --chown=zsh:zsh --from=downloader /tmp/prezto /home/zsh/.zprezto
COPY --chown=zsh:zsh --from=downloader /tmp/zsh-completions /home/zsh/.zsh-completions

RUN chmod 744 $HOME/setup.zsh \
 && zsh -c $HOME/setup.zsh \
 && rm -rf setup.zsh \
 && rm -rf $HOME/.zprezto/runcoms/zshrc \
 && cat /tmp/zshrc > $HOME/.zprezto/runcoms/zshrc \
 && mv .zpreztorc .zpreztorc.bak \
 && sed -e "s/'sorin'/'redhat'/g" .zpreztorc.bak > .zpreztorc \
 && rm -rf .zpreztorc.bak /tmp/zshrc

HEALTHCHECK CMD [ "zsh", "--version" ]

CMD [ "zsh" ]
