#!/bin/bash
#build classes

yum install dos2unix
dos2unix /opt/temp/sh/start.sh
chmod +x /opt/temp/sh/start.sh
/opt/temp/sh/start.sh

# Repository URL
# https://192.168.101.231/svn/asorigin/trunk
# jackydai/Weitech1616
# yum install rpm-build ，需要按y