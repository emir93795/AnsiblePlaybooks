#!/bin/bash
yum -y update
useradd -m nodejs
passwd –-stdin nodejs

yum install -y epel-release
yum install -y git
yum install -y nodejs
yum install -y npm
npm install upstart

mkdir ImageMagick
cd ImageMagick
wget http://www.imagemagick.org/download/linux/CentOS/x86_64/ImageMagick-6.8.9-10.x86_64.rpm

yum localinstall ImageMagick-6.8.9-10.x86_64.rpm --skip-broken
cd
rm -r -f ImageMagick
mkdir REPO1
mkdir REPO2

#cd REPO1
#git clone git://github.com/utong/nexus
#cd
#cd REPO2
#git clone git://github.com/pencil/galaxy
