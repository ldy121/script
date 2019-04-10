#!/bin/sh

/opt/tensorflow/bazel-bin/tensorflow/lite/toco/toco

python /opt/tensorflow/tensorflow/contrib/quantize/python/quantize_graph.py "$@"
