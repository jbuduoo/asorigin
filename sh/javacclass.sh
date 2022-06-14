#!/bin/bash
#build classes

cp -rf /opt/temp2/src/. /opt/temp2/classes
cd /opt/temp2/classes
find -name *.java >source.txt
javac -cp /opt/temp2/webapps/ROOT/WEB-INF/lib/*:/opt/asorigin/web/lib/*:/opt/asorigin/java/lib/* -sourcepath /opt/temp2/classes @source.txt
find -name *.java -exec rm -f {} \;
rm -rf /opt/temp2/classes/source.txt
\cp -rf /opt/temp2/classes/. /opt/asorigin/web/webapps/ROOT/WEB-INF/classes
#rm -rf /opt/temp2/classes
