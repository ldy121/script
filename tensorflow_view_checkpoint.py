import tensorflow as tf
import sys

def generate_checkpoint_log_dir(meta_file, output_dir) :
	g = tf.Graph()

	with g.as_default() as g:
		tf.train.import_meta_graph(meta_file);

	with tf.Session(graph=g) as sess:
		file_writer = tf.summary.FileWriter(logdir=output_dir, graph= g);


if __name__ == '__main__' :

	if (len(sys.argv) == 3) :
		generate_checkpoint_log_dir(sys.argv[1], sys.argv[2])
	else :
		print ('%s [ checkpoint (.meta) ] [ output log checkpoint directory ]' % sys.argv[0]);
	

