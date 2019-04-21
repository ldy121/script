#!/usr/bin/env python
# Copyright 2017 The TensorFlow Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================
"""This tool creates an html visualization of a TensorFlow Lite graph.

Example usage:

python visualize.py foo.tflite foo.html
"""

import json
import os
import sys
import numpy as np

from tensorflow.python.platform import resource_loader

# Schema to use for flatbuffers
_SCHEMA = "third_party/tensorflow/lite/schema/schema.fbs"

# TODO(angerson): fix later when rules are simplified..
_SCHEMA = resource_loader.get_path_to_datafile("/opt/tensorflow/tensorflow/lite/schema/schema.fbs")
_BINARY = resource_loader.get_path_to_datafile("/opt/tensorflow/bazel-bin/tensorflow/lite/tools/visualize.runfiles/flatbuffers/flatc")
# Account for different package positioning internal vs. external.
if not os.path.exists(_BINARY):
	_BINARY = resource_loader.get_path_to_datafile("../../../../flatbuffers/flatc")

if not os.path.exists(_SCHEMA):
	raise RuntimeError("Sorry, schema file cannot be found at %r" % _SCHEMA)
if not os.path.exists(_BINARY):
	raise RuntimeError("Sorry, flatc is not available at %r" % _BINARY)

class Tensor :
	def __init__(self, tensor) :
		self.name = tensor['name'];
		self.shape = tensor['shape'];
		self.type = tensor['type'];
		if len(self.shape) > 0 :
			j = 1;
			for i in self.shape :
				j = j * i;
			self.size = j;
		else :
			self.size = 0;

	def set_buffer(self, data) :
		if self.type == 'INT32' :
			i = 0;
			dat = [];
			while i < len(data) :
				k = 0;
				for j in range(4) :
					k = (k << 8) | data[i + j];
				i = i + 4;
				dat.append(k);
			self.filter_data = np.array(dat, dtype='int32');

		elif self.type == 'UINT8' :
			self.filter_data = np.array(data, dtype='uint8');

		if (len(self.filter_data) != self.size) :
			print (('filter buffer and shape size mismatch layer : %s') % self.name);
		else :
			self.filter_data = self.filter_data.reshape(self.shape[0], -1);

	
	def get_nonzero(self) :
		return np.count_nonzero(self.filter_data);

def parse_tflite(tflite_input) :
	# Convert the model into a JSON flatbuffer using flatc (build if doesn't
	# exist.
	if not os.path.exists(tflite_input):
		raise RuntimeError("Invalid filename %r" % tflite_input)
	if tflite_input.endswith(".tflite") or tflite_input.endswith(".bin"):
	# Run convert
		cmd = (
			_BINARY + " -t "
			"--strict-json --defaults-json -o /tmp {schema} -- {input}".format(
			input=tflite_input, schema=_SCHEMA))
		print(cmd)
		os.system(cmd)
		real_output = ("/tmp/" + os.path.splitext(os.path.split(tflite_input)[-1])[0] + ".json")

		data = json.load(open(real_output))
	elif tflite_input.endswith(".json"):
		data = json.load(open(tflite_input))
	else :
		raise RuntimeError("Input file was not .tflite or .json")

	tensors = [];
	filter_buffer = data['buffers'];
	for subgraph_idx, g in enumerate(data["subgraphs"]):
	# Subgraph local specs on what to display
		for tensor in g['tensors'] :
			buffer_index = tensor['buffer'];
			t = Tensor(tensor);
			if ( t.size > 0 ) :
				t.set_buffer(filter_buffer[buffer_index]['data']);
				tensors.append(t);
	return tensors;

def main(argv):
	try:
		tflite_input = argv[1]
	except IndexError:
		print("Usage: %s <input tflite>" % (argv[0]))
	else :
		tensors = parse_tflite(tflite_input);
		total = 0;
		nonzero = 0;
		for i in tensors :
			total = total + i.size;
			nonzero = nonzero + i.get_nonzero(); 
		print ('Total weight : %d / Zero values : %d / Non-Zero values : %d' %
				(total, (total - nonzero), nonzero));

if __name__ == "__main__":
	main(sys.argv)
