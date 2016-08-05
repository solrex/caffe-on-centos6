#!/bin/bash

if [ "$1" == "" ]; then
    PREFIX=/usr/local
else
    PREFIX=$1
fi

CPU_CORES=`grep processor /proc/cpuinfo | wc -l`
HAS_AVX=`grep flags /proc/cpuinfo | grep avx | wc -l`
HAS_GPU=`lspci | grep VGA | grep NVIDIA | wc -l`

# boost
if [ ! -f boost_1_61_0.tar.bz2 ]; then
    wget -c http://heanet.dl.sourceforge.net/project/boost/boost/1.61.0/boost_1_61_0.tar.bz2 -O boost_1_61_0.tar.bz2 || exit 1
fi
tar -xjf boost_1_61_0.tar.bz2 || exit 1
cd ./boost_1_61_0/
./bootstrap.sh --prefix=$PREFIX || exit 1
./b2 install -j $CPU_CORES || exit 1
cd ..

# opencv
if [ ! -f opencv-2.4.13.zip ]; then
    wget -c https://codeload.github.com/opencv/opencv/zip/2.4.13 -O opencv-2.4.13.zip || exit 1
fi
unzip opencv-2.4.13.zip || exit 1
cd ./opencv-2.4.13/
CMAKE_FLAGS="-DCMAKE_INSTALL_PREFIX=$PREFIX"
if [ $HAS_AVX -ne 0 ]; then
    CMAKE_FLAGS="$CMAKE_FLAGS -DENABLE_AVX=ON"
fi
if [ $HAS_GPU -ne 0 ]; then
    CMAKE_FLAGS="$CMAKE_FLAGS -DCUDA_ARCH_BIN=3.5"
fi
cmake $CMAKE_FLAGS || exit 1
make install -j $CPU_CORES || exit 1
cd ..
