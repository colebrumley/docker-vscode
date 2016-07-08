#!/usr/bin/env bash
# REQUIRES: socat xquartz docker
sock_pid_file=~/.socat_x11_sock_proxy

get_ip() {
    /sbin/ifconfig en0 inet | \
    /usr/bin/egrep -o '([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3})' | \
    /usr/bin/head -n 1
}

new_proxy() {
    /usr/local/bin/socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &
    /bin/echo $! > $sock_pid_file
    trap "/usr/bin/pkill -F $sock_pid_file; /bin/rm -f $sock_pid_file" EXIT
}

handle_data_dir() {
    if [[ -d $HOME/.vscode ]]; then
        VOL_MAP="--volume=$HOME/.vscode:/home/code/.vscode"
        return
    elif ! /usr/local/bin/docker volume inspect vscode_data >/dev/null 2>&1; then
        /usr/local/bin/docker volume create --name vscode_data
    fi
    VOL_MAP="--volume=vscode_data:/home/code/.vscode"
}

/usr/bin/osascript -e 'tell application "XQuartz" to activate'

# Set up a socat proxy to the XQuartz socket only if one doesn't exist
[[ -f $sock_pid_file ]] || new_proxy

/usr/local/bin/docker run -i --rm -e DISPLAY=$(get_ip):0 $VOL_MAP ${1:-elcolio/vscode}
