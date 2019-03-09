#!/bin/bash
key_server="hkp://keyserver.ubuntu.com:80"
mongo_signing_key="9DA31620334BD75D9DCB49F368818C72E52529D4"
mongo_repo="http://repo.mongodb.org/apt/debian stretch/mongodb-org/4.0 main"
source_list="/etc/apt/sources.list.d/mongodb-org-4.0.list"


print_error() {
	echo "Could not $1. Error: $2"
	exit 1
}



if [[ $EUID -ne 0 ]]
then 
    echo "Please run this script as root!"
    exit 126
fi


echo -n -e "This script will install mongodb. Continue(y/n) ?\n"
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
apt-key adv --keyserver $key_server --recv $mongo_signing_key
error=$?
if [[ $error -ne 0 ]]
then
    print_error "add key(apt-key)" $error
fi

echo "Add repo..."
echo "deb $mongo_repo" | tee $source_list
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

echo "Installing mongodb..."
apt-get install -y mongodb-org
error=$?
if [[ $error -ne 0 ]]
then
    print_error "install mongodb" $error
fi

echo "Package successfully installed"
exit 0