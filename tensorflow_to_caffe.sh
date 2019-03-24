#!/bin/sh



if [ $# -eq 3 ];
then
	mmconvert -sf tensorflow -iw $1 --inNodeName input --inputShape $2 --dstNodeName $3 -df caffe -om tf_model
	echo "genearted file : tf_model.caffemodel / tf_model.prototxt"
else
	echo $0' [ input pb file ] [ model shape ] [ dst node name ]'
fi
