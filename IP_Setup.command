#!/bin/bash


# This will set either En0 or En1 up to be run with the 10.0.0.5 IP address.

y=$(ifconfig | grep -A 3 "en0" | tail -1 | tr -d [a-z] | awk -F' ' '{print $1}')
x=$(ifconfig | grep -A 3 "en1" | tail -1 | tr -d [a-z] | awk -F' ' '{print $1}')

#------

ports="EthernetPort1 EthernetPort2"

echo "Which ethernet port do you wish to configure?"
select port in $ports;
do 
	if [ "$port" = "EthernetPort1" ]; then
		echo "Setting En0 to have the IP: 10.0.0.5."
		ifconfig en0 10.0.0.5
		ifconfig en1 10.0.0.6
		echo -e "$en0"
		echo -e "$en1"
		exit 0;

	elif [ "$port" = "EthernetPort2" ]; then
		echo "Setting En1 to have the IP: 10.0.0.5."
		ifconfig en1 10.0.0.5
		ifconfig en0 10.0.0.6
		echo -e "$en1"
		echo -e "$en0"
		exit 0;

	else 
		sleep 5
		echo "you stupid!!!" 
	fi
done




