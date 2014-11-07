#!/bin/bash
yum -y update
useradd -m nodejs
passwd –-stdin nodejs

wget http://nodejs.org/dist/node-latest.tar.gz
tar zxvf node-latest.tar.gz
cd node-v0.10.33
./configure
make install
yum install -y git
yum install -y automake
yum install -y unzip
yum install -y npm
npm install upstart

mkdir ImageMagick
cd ImageMagick
wget http://www.imagemagick.org/download/linux/CentOS/x86_64/ImageMagick-6.8.9-10.x86_64.rpm

yum localinstall ImageMagick-6.8.9-10.x86_64.rpm --skip-broken
cd
mkdir REPO1
mkdir REPO2

cd REPO1
git clone git://github.com/utong/nexus
cd
cd REPO2
git clone git://github.com/pencil/galaxy
cd

yum update all
yum install -y gcc libstdc++-devel gcc-c++ fuse fuse-devel curl-devel libxml2-devel openssl-devel mailcap
git clone git://github.com/s3fs-fuse/s3fs-fuse.git
cd s3fs-fuse
./autogen.sh
./configure
make
make install

sudo sh -c 'echo "uoc-bucket:accesskey:secretkey" >> /etc/passwd-s3fs'
chmod 640 /etc/passwd-s3fs
cd
mkdir /content-s3
mkdir /tmp/cache
chmod 777 /tmp/cache/

s3fs -o use_cache=/tmp/cache uoc-bucket /content-s3

