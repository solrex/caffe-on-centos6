#!/bin/bash

ls | grep Anaconda2
if [ $? -ne 0 ]; then
    wget -c http://repo.continuum.io/archive/Anaconda2-4.1.1-Linux-x86_64.sh -O Anaconda2-4.1.1-Linux-x86_64.sh
fi
if [ "$1" == "" ]; then
    PREFIX=/opt/anaconda2
else
    PREFIX=$1
fi
sh Anaconda2*.sh -b -p $PREFIX
$PREFIX/bin/easy_install protobuf-2.6.1-py2.7.egg
cp /etc/bashrc etc_bashrc.bak
echo -ne "\n# added by Anaconda2 4.1.1 installer\nexport PATH=\"${PREFIX}/bin:\$PATH\"" >> /etc/bashrc
