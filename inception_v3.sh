#!/bin/sh

python_script=cnn_neural_network.py
input_path=/home/ldy121/tensorflow/pretrained_inception_v3/inception_v3.ckpt
input_name=input
output_name=InceptionV3/Predictions/Reshape_1
QUANTIZATION_TFLITE=quantized_model.tflite
CONVERT_TFLITE=convert_model.tflite

pre_process() {
	rm -rf ${name}
	mkdir ${name}
}

post_process() {
	/opt/script/optimize_inference.sh \
		model.pb \
		${input_name} \
		${output_name}

	mv model.pb ${name}/${name}.pb 
	mv opt_model.pb ${name}/opt_${name}.pb 

	quantization_tflite ${name}/opt_${name}.pb
	convert_tflite ${name}/opt_${name}.pb

	mv ${QUANTIZATION_TFLITE} ${name}
	mv ${CONVERT_TFLITE} ${name}
}

inception_v3_freeze() {
	/opt/script/freeze_graph.sh \
		${name}/${name}.pbtxt \
		${name}/${name} \
		${output_name}
}

prunable_inception_v3_freeze() {
	/opt/script/freeze_pruning_graph.sh \
		${name}/ \
		${output_name}
}

generate_pretrained_inception_v3() {
	python3 ${python_script} ${name} ${input_path} ${name}/${name}
	inception_v3_freeze
}

generate_pretrained_prunable_inception_v3() {
	python3 ${python_script} ${name} ${input_path} ${name}/${name}
	prunable_inception_v3_freeze
}

generate_prunable_inception_v3() {
	python3 ${python_script} ${name} ${name}/${name}
	prunable_inception_v3_freeze
}

generate_zero_inception_v3() {
	python3 ${python_script} ${name} ${name}/${name}
	inception_v3_freeze
}

convert_tflite() {
	pb_file=$1

	/opt/script/toco_tflite.sh convert \
		${pb_file} ${input_name} ${output_name}
}

quantization_tflite() {
	pb_file=$1

	/opt/script/toco_tflite.sh quant \
		${pb_file} ${input_name} ${output_name}
}
