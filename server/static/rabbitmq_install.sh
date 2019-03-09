#!/bin/bash
key_server="hkps.pool.sks-keyservers.net"
rabbit_signing_key="0x6B73A36E6026DFCA"
rabbit_repo="http://www.rabbitmq.com/debian/ testing main"
source_list="/etc/apt/sources.list"


print_error() {
	echo "Could not $1. Error: $2"
	exit 1
}



if [[ $EUID -ne 0 ]]
then 
    echo "Please run this script as root!"
    exit 126
fi


echo -n -e "This script will install rabbitmq. Continue(y/n) ?\n"
read key
case "$key" in
	y|Y)
	    ;;
	*) echo "Installation canceled"
	    exit 0
            ;;
esac	

echo "Installing dirmngr..."
apt-get install dirmngr
error=$?
if [[ $error -ne 0 ]]
then
    print_error "install dirmngr" $error
fi

echo "Adding key..."
apt-key adv --keyserver $key_server --recv-keys $rabbit_signing_key
error=$?
if [[ $error -ne 0 ]]
then
    print_error "add key(apt-key)" $error
fi

echo "Add repo..."
echo "deb $rabbit_repo" >> $source_list
error=$?
if [[ $error -ne 0 ]]
then
    print_error "add repo" $error
fi

echo "Updating package index..."
apt-get update
error=$?
if [[ $error -ne 0 ]]
then
    print_error "update apt-get" $error
fi

echo "Installing rabbitmq..."
apt-get install -y rabbitmq-server
error=$?
if [[ $error -ne 0 ]]
then
    print_error "install rabbitmq" $error
fi

echo "Package successfully installed"
exit 0