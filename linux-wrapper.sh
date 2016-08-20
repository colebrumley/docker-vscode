#!/bin/bash
HERE=$(pwd)
[[ -d ${HOME}/.vscode ]] && VOLUME_STRING="--volume=${HOME}/.vscode:/home/code/.vscode "
[[ -f ${HOME}/.gitconfig ]] && VOLUME_STRING="${VOLUME_STRING}--volume=${HOME}/.gitconfig:/home/code/.gitconfig "
VOLUME_STRING="${VOLUME_STRING}--volume=$HERE:$HERE "

for f in ${@}; do
    flink=$(readlink -f $f)
    if [[ -f $flink ]]; then
        fdir=$(dirname $flink)
        if [[ -d $fdir ]]; then
            [[ $fdir =~ $VOLUME_STRING ]] || VOLUME_STRING="${VOLUME_STRING}--volume=$fdir:$fdir "
        fi
    elif [[ -d $flink ]] && [[ $flink =~ $VOLUME_STRING ]]; then
        VOLUME_STRING="${VOLUME_STRING}--volume=$flink:$flink "
    fi
done
set -x
docker run --rm \
    --workdir=$HERE \
    --env=DISPLAY \
    --volume=/tmp:/tmp \
    $VOLUME_STRING \
    elcolio/vscode $@ &
