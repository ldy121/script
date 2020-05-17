#!/bin/sh

if [ $# -eq 2 ];
then
	docker run --name $2 $1
else
	echo $0' [ image name ] [ container name ]'
fi
