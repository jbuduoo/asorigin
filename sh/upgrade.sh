#!/bin/bash

# upgrade
version=1.1.1

mkdir /root/web
mkdir /root/web/webapps
# cp root root
# rm -rf lic
# rm -rf data.dll
cd web
tar zcvf /root/upgrade$version.tar.gz **
cd ..
# rm -rf web