#!/bin/sh

is_not_defined=$(echo $TENSORFLOW_HOME)

if [ "$is_not_defined" = "" ]; then
	TENSORFLOW_HOME=/opt/tensorflow
fi

if [ $# -eq 3 ];
then
	python ${TENSORFLOW_HOME}/tensorflow/python/tools/freeze_graph.py \
		--input_graph=$1 \
		--input_checkpoint=$2 \
		--output_graph=model.pb \
		--output_node_names=$3
else
	echo $0' [Input graph file (.pbtxt)] [ Input checkpoint ] [ Ouput node name]'
fi
