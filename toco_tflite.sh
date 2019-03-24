#!/bin/sh

TFLITE_CONVERT=/opt/tensorflow/bazel-bin/tensorflow/lite/python/tflite_convert
OUTPUT_TFLITE=model.tflite

tflite_quantization() {
	pb_file=$1
	input=$2
	output=$3

	${TFLITE_CONVERT} \
		--output_file=${OUTPUT_TFLITE} \
		--graph_def_file=${pb_file} \
		--inference_type=QUANTIZED_UINT8 \
		--input_arrays=${input} \
		--output_arrays=${output} \
		--mean_values=128 \
		--std_dev_values=127
}

tflite_convert() {
	pb_file=$1
	input=$2
	output=$3

	${TFLITE_CONVERT} \
		--output_file=${OUTPUT_TFLITE} \
		--graph_def_file=${pb_file} \
		--input_arrays=${input} \
		--output_arrays=${output}
}

if [ $# -eq 4 ];
then
	case $1 in
		quant)
			tflite_quantization $2 $3 $4
			;;
		convert)
			tflite_convert $2 $3 $4
			;;
	esac
else
	echo $0' [ convert / quant ] [ pb file ] [ input node ] [ output node ]'
fi
