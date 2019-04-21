#!/bin/sh

page_size=4096
swapfile=/swapfile

swap_off()
{
	sudo swapoff -a
	sudo rm ${swapfile}
}

swap_on()
{
	size=$1
	sudo fallocate --length ${size}G ${swapfile}
	sudo chmod 600 ${swapfile}
	sudo mkswap ${swapfile}
	sudo swapon ${swapfile}
}

print_command()
{
	echo $1' [ 1 or 2 or 3 or 4 or 5 (GB for swap partition) ]'
}

if [ $# -eq 1 ];
then
	if [ $1 -ge 1 -a $1 -le 5 ];
	then
		swap_off
		swap_on $1
	else
		print_command $0
	fi
else
	print_command $0
fi
