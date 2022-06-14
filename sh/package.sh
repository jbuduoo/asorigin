#!/bin/bash

name=asorigin
version=1.1.1
oldversion=1.1.0


mkdir $name-$version
cp $name-$oldversion/* $name-$version

cd /root/$name
# copy web/root
tar zcvf /root/$name-$version/$name.tar.gz **
cd ..

tar zcvf /root/rpmbuild/SOURCES/$name-$version.tar.gz $name-$version
rpmbuild -ba /root/rpmbuild/SPECS/$name.spec

echo 'finish'
rm -rf $name-$version
