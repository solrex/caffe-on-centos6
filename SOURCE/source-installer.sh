#!/bin/bash

if [ "$1" == "" ]; then
    PREFIX=/opt/anaconda2
else
    PREFIX=$1
fi
BUILD_THREAD=20

# boost
if [ ! -f boost_1_61_0.tar.bz2 ]; then
    wget -c http://heanet.dl.sourceforge.net/project/boost/boost/1.61.0/boost_1_61_0.tar.bz2 -O boost_1_61_0.tar.bz2 || exit 1
fi
tar -xjf boost_1_61_0.tar.bz2 || exit 1
cd ./boost_1_61_0/
./bootstrap.sh --prefix=$PREFIX || exit 1
./b2 install -j $BUILD_THREAD || exit 1
cd ..

# opencv
if [ ! -f opencv-2.4.13.zip ]; then
    wget -c https://codeload.github.com/opencv/opencv/zip/2.4.13 -O opencv-2.4.13.zip || exit 1
fi
unzip opencv-2.4.13.zip || exit 1
cd ./opencv-2.4.13/
cmake -DCMAKE_INSTALL_PREFIX=$PREFIX -DENABLE_AVX=ON -DCUDA_ARCH_BIN="3.5" || exit 1
make install -j $BUILD_THREAD || exit 1
cd ..
