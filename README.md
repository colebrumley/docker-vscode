# Containerized VSCode

This repo builds a Docker container for [Visual Studio Code](https://github.com/Microsoft/vscode), which can be used on OSX. I've included a wrapper script to make launching containers a little easier. The script takes a list of files or directories to mount into the container like this: `./start.sh /Users/cole/lib /tmp/stuff /Users/cole/.ssh`. The directories will be mounted at the same path in the container. The `~/.vscode` directory is always mounted if it exists, otherwise a Docker volume will be created for it.

#### *A note about the X11 socket on OSX*
Despite my ~~best~~ efforts I could not get a container to use the XQuartz X11 socket directly, even using `--privileged`. Instead, `socat` is proxying the socket over the default NIC. Since it's a local to local connection it shouldn't introduce latency or performance issues, but it *does* mean that port 6000 needs to be available on your mac and that there will be an unauthenticated connection to X11 available.

If anyone knows of a way to pass XQuartz's socket through to a container that works with OSX 10.11+ please let me know!

### Requirements

 - [Docker for Mac](https://docs.docker.com/engine/installation/mac/#/docker-for-mac)
 - `socat` (to install via Homebrew: `brew install socat`)
 - [XQuartz](https://www.xquartz.org/) (to install via Homebrew: `brew cask install Caskroom/versions/xquartz-beta`)

### Build

Run `make build` to build the container. If you'd like an OSX app wrapper, I've used [Platypus](http://sveinbjorn.org/platypus) successfully.
