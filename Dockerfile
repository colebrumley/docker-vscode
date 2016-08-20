FROM        ubuntu:xenial

ENV         DEBIAN_FRONTEND=noninteractive \
            VSC_DL_URL=https://go.microsoft.com/fwlink/?LinkID=760868

RUN         apt-get update && \
            apt-get install -y \
                openssl \
                nodejs \
                npm \
                git \
                wget \
                libgtk2.0 \
                libgconf-2-4 \
                libasound2 && \
            npm install -g typescript

ENV         HOME=/home/code

RUN         wget -O /tmp/vsc.deb $VSC_DL_URL && \
            apt install -y /tmp/vsc.deb && \
            rm -f /tmp/vsc.deb && \
            useradd --user-group --create-home --home-dir $HOME code && \
            mkdir -p $HOME/.vscode/extensions $HOME/.config/Code/User && \
            touch $HOME/.config/Code/storage.json && \
            chown -R code:code $HOME

USER        code
WORKDIR     $HOME
VOLUME 	    $HOME/.vscode
VOLUME 	    $HOME/.config/Code
ENTRYPOINT  ["/usr/bin/code","--wait","--verbose"]
