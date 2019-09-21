#!/bin/sh

checkpoint_dir=/tmp/checkpoint_dir

if [ $# -eq 1 ];
then
	python /opt/script/tensorflow_view_checkpoint.py $1 ${checkpoint_dir}
	tensorboard --logdir ${checkpoint_dir}
else
	echo $0' [ checkpoint metafile (.meta) ] '
fi
