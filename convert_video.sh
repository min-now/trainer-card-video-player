#!/usr/bin/env bash

readonly WIDTH=192
readonly HEIGHT=64

if [ $# -ne 1 ]; then
	echo "Usage: $0 input_file"
	exit 1
fi

ffmpeg -i $1\
	-vf "scale=$WIDTH:$HEIGHT,format=gray,eq=contrast=1000,fps=fps=30"\
	"${1%.*}.gif"\
	-y

python3 encode.py "${1%.*}.gif"
