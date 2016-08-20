#!/bin/bash -x
[[ -d ${HOME}/.vscode ]] && VSC_USER_DIR="-v ${HOME}/.vscode:/home/code/.vscode"

HERE=$(pwd)
VOLUME_STRING="--volume=$HERE:$HERE "

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

docker run --rm \
    --workdir $HERE \
    -e DISPLAY \
    -v /tmp:/tmp \
    $VSC_USER_DIR \
    $VOLUME_STRING \
    elcolio/vscode $@ &
