# Caffe Build Environment on CentOS 6.x

Root User

    git clone https://github.com/solrex/caffe-on-centos6.git
    cd caffe-on-centos6
    install-deps.sh

Normal User:

    wget https://raw.githubusercontent.com/solrex/caffe-on-centos6/master/Makefile.config
    mv Makefile.config caffe_source_path/Makefile.config
    # Link with -lopenblasp which can make use of multi-core CPU
    sed -i 's/openblas/openblasp/g' Makefile
    CPU_CORES=$(grep processor /proc/cpuinfo | wc -l)
    make -j $CPU_CORES
    make test -j $CPU_CORES
    make distribute
    make runtest
