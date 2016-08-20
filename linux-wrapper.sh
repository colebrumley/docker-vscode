#!/bin/bash -x
[[ -d ${HOME}/.vscode ]] && VSC_USER_DIR="-v ${HOME}/.vscode:/home/code/.vscode"

for f in ${@}; do
    if [[ -f $f ]]; then
        fdir=$(dirname $(readlink -f $f))
        if [[ -d $fdir ]]; then
            [[ $fdir =~ $VOLUME_STRING ]] || VOLUME_STRING="${VOLUME_STRING}--volume=$fdir:$fdir "
        fi
    elif [[ -d $f ]] && [[ $f =~ $VOLUME_STRING ]]; then
        VOLUME_STRING="${VOLUME_STRING}--volume=$f:$f "
    fi
done

docker run --rm -e DISPLAY -v /tmp:/tmp $VSC_USER_DIR $VOLUME_STRING elcolio/vscode $@

