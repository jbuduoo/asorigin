#!/bin/bash  

name=asorigin
bname=ASOrigin
version=1.1.1

echo "rpmbuild -ba SPECS/$name.spec" > /root/rpmbuild/build.sh
chmod +x /root/rpmbuild/build.sh

cat > /root/rpmbuild/SPECS/$name.spec <<_EOF_
%define SOURCE_DIR $name-$version
%define SOURCE_NAME %{SOURCE_DIR}.tar.gz
Name:       $name
Version:    $version
Release:    1
Vendor:     ascentac
Summary:    $bname X86_64
License:    ascentac
Source0:    $name-$version.tar.gz
%description
$bname package


%prep
%setup -q

%install
rm -rf %{buildroot}
mkdir -p %buildroot/tmp
cp %{SOURCE0} %buildroot/tmp


%clean
rm -rf %{buildroot}
%post
cd /tmp
tar zxvf %{SOURCE_NAME} > /dev/null
cd %{SOURCE_DIR}
fileName=$(date +/tmp/${name}_"%s".log)
./install.sh > /dev/null
cd ..
rm -rf %{SOURCE_DIR}
> %{SOURCE0}
%files
/tmp/%{SOURCE_NAME}
%defattr (-,root,root)
%postun
service ${name}db stop
service ${name}web stop
rm -rf /opt/${name}
/sbin/chkconfig --del ${name}web
/sbin/chkconfig --del ${name}db
rm -f /etc/init.d/${name}web
rm -f /etc/init.d/${name}db

_EOF_

chmod +x /root/rpmbuild/SPECS/$name.spec