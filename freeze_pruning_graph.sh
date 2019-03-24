#!/bin/sh

is_not_defined=$(echo $TENSORFLOW_HOME)

if [ "$is_not_defined" = "" ]; then
	TENSORFLOW_HOME=/opt/tensorflow
fi


if [ $# -eq 2 ];
then
	python ${TENSORFLOW_HOME}/tensorflow/contrib/model_pruning/python/strip_pruning_vars.py \
		--checkpoint_dir=$1 \
		--output_dir=./ \
		--filename=model.pb \
		--output_node_names=$2
else
	echo $0' [ Checkpoint directory ] [ Ouput node name]'
fi
