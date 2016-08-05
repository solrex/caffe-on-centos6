#!/bin/bash
PREFIX=/usr/local
ANACONDA_PATH=/opt/anaconda2

EABLE_GPU=`lspci | grep VGA | grep NVIDIA | wc -l`
CUDA_VERSION=7.5

if [ $(whoami) != "root" ]; then
    echo 'Please use "root" to run this install script.'
    exit 1
fi

cd RPMS && ./rpms-installer.sh || exit 1
cd ..

# if [ $ENABLE_GPU -ne 0 ]; then
#     cd CUDA && ./cuda-installer.sh $CUDA_VERSION || exit 1
#     cd ..
# fi

cd python && ./python-installer.sh $ANACONDA_PATH || exit 1
cd ..

cd SOURCE && ./source-installer.sh $PREFIX || exit 1
cd ..

cp /etc/bashrc etc_bashrc.bak
echo -ne "\n# added by caffe on centos 6 installer\nexport LD_LIBRARY_PATH=\"${ANACONDA_PATH}/lib:${PREFIX}/lib64:${PREFIX}/lib:\$LD_LIBRARY_PATH\"" >> /etc/bashrc
