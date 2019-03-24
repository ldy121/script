#!/bin/sh

is_not_defined=$(echo $TENSORFLOW_HOME)

if [ "$is_not_defined" = "" ]; then
	TENSORFLOW_HOME=/opt/tensorflow
fi

if [ $# -eq 3 ];
then
	python ${TENSORFLOW_HOME}/tensorflow/python/tools/optimize_for_inference.py \
		--input=$1 \
		--output=opt_model.pb \
		--frozen_graph=True \
		--input_names=$2 \
		--output_names=$3
else
	echo $0' [Input graph file (.pb)] [ Input node name ] [ Ouput node name]'
fi
