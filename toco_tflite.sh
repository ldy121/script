#!/bin/sh

TOCO=/opt/tensorflow/bazel-bin/tensorflow/lite/toco/toco
QUANTIZATION_TFLITE=quantized_model.tflite
CONVERT_TFLITE=convert_model.tflite

tflite_quantization() {
	pb_file=$1
	input=$2
	output=$3

	${TOCO} \
		--input_file=${pb_file} \
		--output_file=${QUANTIZATION_TFLITE} \
		--inference_type=QUANTIZED_UINT8 \
		--input_arrays=${input} \
		--output_arrays=${output} \
		--mean_values=128 \
		--std_dev_values=127 \
		--default_ranges_min=0 \
		--default_ranges_max=255
}

tflite_convert() {
	pb_file=$1
	input=$2
	output=$3

	${TOCO} \
		--input_file=${pb_file} \
		--output_file=${CONVERT_TFLITE} \
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
