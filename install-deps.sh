#!/bin/bash
PREFIX=/usr/local
ANACONDA_PATH=/opt/anaconda2

if [ $(whoami) != "root" ]; then
    echo 'Please use "root" to run this install script.'
    exit 1
fi

cd RPMS && ./rpms-installer.sh || exit 1
cd ..

CPU_ONLY=1
lspci | grep VGA | grep NVIDIA
if [ $? -eq 0 ]; then
    CPU_ONLY=0
fi

#if [ $CPU_ONLY -eq 0 ]; then
#    CUDA_VERSION=7.5
#    cd CUDA && ./cuda-installer.sh $CUDA_VERSION || exit 1
#    ln -sf /opt/nvidia/cudnn/cudnn_v3/include/cudnn.h ${PREFIX}/include/cudnn.h
#    ln -sf /opt/nvidia/cudnn/cudnn_v3/lib64/libcudnn.so.7.0.64 ${PREFIX}/lib64/libcudnn.so.7.0.64
#    ln -sf /opt/nvidia/cudnn/cudnn_v3/lib64/libcudnn_static.a ${PREFIX}/lib64/libcudnn_static.a
#    cd ${PREFIX}/lib64/
#    ln -sf libcudnn.so.7.0.64 libcudnn.so.7.0
#    ln -sf libcudnn.so.7.0 libcudnn.so
#    cd -
#    cd ..
#fi

cd python && ./python-installer.sh $ANACONDA_PATH || exit 1
cd ..
cd SOURCE && ./source-installer.sh $PREFIX || exit 1
cd ..
cp /etc/bashrc etc_bashrc.bak
echo -ne "\n# added by caffe on centos 6 installer\nexport LD_LIBRARY_PATH=\"${ANACONDA_PATH}/lib:${PREFIX}/lib64:${PREFIX}/lib:\$LD_LIBRARY_PATH\"" >> /etc/bashrc
