#!/usr/bin/python

import sys
import numpy as np
import tensorflow as tf
from tensorflow.python.platform import gfile
from tensorflow.python.framework import tensor_util

def print_pb_weight (pb_file) :
	graph_info = {};
	with tf.Session() as sess:
		with gfile.FastGFile(pb_file, 'rb') as f:
			graph_def = tf.GraphDef()
			graph_def.ParseFromString(f.read())
			sess.graph.as_default()
			tf.import_graph_def(graph_def, name='')
			graph_nodes=[n for n in graph_def.node]
			wts = [n for n in graph_nodes if n.op=='Const']

			for n in wts:
				graph_info.update({n.name : tensor_util.MakeNdarray(n.attr['value'].tensor)});
	
	total_weight = 0;
	non_zero_weight = 0;
	for key in graph_info.keys() :
		total_weight = (graph_info[key].size) + total_weight;
		non_zero_weight = np.count_nonzero(graph_info[key]) + non_zero_weight;
	print ("Total : %d / Zero : %d / Non-Zero : %d" % (total_weight, (total_weight - non_zero_weight), non_zero_weight));

def print_help (cmd) :
	print ('%s [pb file]' % cmd);

if __name__ == '__main__' :
	if len(sys.argv) == 2 :
		if (sys.argv[1][-3:] == '.pb') :
			print_pb_weight (sys.argv[1]);
		else :
			print_help(sys.argv[0]);
	else :
		print_help(sys.argv[0]);
