# Containerized VSCode

This repo builds a Docker container for [Visual Studio Code](https://github.com/Microsoft/vscode), which can be used on OSX and Linux. Linux usage is more straightforward and covered elsewhere on the internet so I'll skip it here. I've included a wrapper script and app template for OSX to make the containerized version behave more like a native app.

After building, you can copy `Containerized VSCode.app` into `/Applications`, or just start VSCode with `start.sh` directly. Then as long as Docker is running you can launch VSCode instances at will.

#### *A note about the X11 socket on OSX*
Despite my ~~best~~ efforts I could not get a container to use the XQuartz X11 socket directly, even using `--privileged`. Instead, `socat` is proxying the socket over the default NIC. Since it's a local to local connection it shouldn't introduce latency or performance issues, but it *does* mean that port 6000 needs to be available on your mac and that there will be an unauthenticated connection to X11 available.

If anyone knows of a way to pass XQuartz's socket through to a container that works with OSX 10.11+ please let me know!

### Requirements

 - [Docker for Mac](https://docs.docker.com/engine/installation/mac/#/docker-for-mac)
 - `socat` (to install via Homebrew: `brew install socat`)
 - [XQuartz](https://www.xquartz.org/) (to install via Homebrew: `brew cask install Caskroom/versions/xquartz-beta`)

### Build

 - To build the container: `make build`
 - To build the app (just downloads some files and moves things into the right places): `make app`
 - To build everything: `make all`
