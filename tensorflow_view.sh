#!/bin/sh

tflite_view=/opt/script/tflite_view.sh
pb_view=/opt/script/pb_view.sh

print_help()
{
	echo $0' [ pb file / tflite file ]'
}

if [ $# -eq 1 ];
then
	case "$1" in
	*.tflite )
		${tflite_view} $1
		;;
	*.pb )
		${pb_view} $1
		;;
	* )
		print_help $0
	esac
else
	print_help $0
fi
