#!/bin/bash
\cp -rf /opt/temp/webapps/ROOT/. /opt/asorigin/web/webapps/ROOT

dos2unix /opt/temp2/sh/javacclass.sh
dos2unix /opt/temp2/sh/upgrade.sh
dos2unix /opt/temp2/sh/rpmbuild.sh
dos2unix /opt/temp2/sh/package.sh
dos2unix /opt/temp2/sh/config.sh

chmod +x /opt/temp2/sh/javacclass.sh
chmod +x /opt/temp2/sh/upgrade.sh
chmod +x /opt/temp2/sh/rpmbuild.sh
chmod +x /opt/temp2/sh/package.sh
chmod +x /opt/temp2/sh/config.sh

/opt/temp2/sh/javacclass.sh

restart web
service asoriginweb restart

/opt/temp2/sh/rpmbuild.sh
/opt/temp2/sh/package.sh

