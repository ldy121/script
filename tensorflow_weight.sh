#!/bin/sh

TENSORFLOW_PB_WEIGHT=/opt/script/tensorflow_pb_weight.py

if [ $# -eq 1 ];
then
	python ${TENSORFLOW_PB_WEIGHT} $1
else
	echo $0' [pb file]'
fi
