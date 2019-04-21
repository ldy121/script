#!/bin/sh

html_file=tflite.html

if [ $# -eq 1 ];
then
	/opt/tensorflow/bazel-bin/tensorflow/lite/tools/visualize $1 ${html_file}
	echo 'generated html file : '${html_file}
else
	echo $0' [tflite file] '
fi
