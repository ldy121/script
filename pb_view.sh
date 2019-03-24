#!/bin/sh

tmp_log_dir=/tmp/log_dir

if [ $# -eq 1 ];
then
	python /opt/tensorflow/tensorflow/python/tools/import_pb_to_tensorboard.py --model_dir $1 --log_dir $tmp_log_dir
	tensorboard --logdir=$tmp_log_dir
else
	echo $0' [pb file] '
fi
