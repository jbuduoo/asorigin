pipeline {
    agent{
    	 label 'linux'
    }
    
    environment {
        CLASS='true'
        TEST='true'
        BUILD='true'
        UPGRADE='true' 
        RPMBUILD='true'                       
        RPM='true'
        APITest='true'
     
        VERSION='1.1.1'   
        NAME='asorigin'
		BNAME='ASOrigin'
		OLDVERSION='1.1.0'
	}
    
    stages {
		//生成class
        stage('class') {
            when { expression { return env.CLASS == 'true'} }
            steps {
            	sh 'cp -rf /opt/temp2/workspace/pipeSvn/src/. /opt/temp2/workspace/pipeSvn/classes'
       	    	dir("classes") {
            	    sh 'pwd'
            		sh 'find -name *.java > /opt/temp2/workspace/pipeSvn/classes/source.txt'
            		sh 'javac -cp /opt/temp2/workspace/pipeSvn/webapps/ROOT/WEB-INF/lib/*:/opt/asorigin/web/lib/*:/opt/asorigin/java/lib/* -sourcepath /opt/temp2/workspace/pipeSvn/classes @source.txt'
    				sh 'find -name *.java -exec rm -rf {} \\;'
    				sh 'rm -rf /opt/temp2/workspace/pipeSvn/classes/source.txt'
				}
            }
        }
        //測試
        stage('Test') {
            when { expression { return env.TEST == 'true'} }
            steps {
            	sh 'pwd'
//            	sh 'ant -version'
//            	dir("classes") {
          			//sh 'java -cp .:/opt/temp2/workspace/pipeSvn/webapps/ROOT/WEB-INF/lib/junit-4.12.jar:/opt/temp2/workspace/pipeSvn/webapps/ROOT/WEB-INF/lib/hamcrest-core-1.3.jar org.junit.runner.JUnitCore test.ExampleUnitTestTest >/root/testreport.txt'
            		sh '/usr/local/ant/bin/ant -f buildlinux.xml clean init compile run-test'
 //           	}
 				//顯示報告
 				script{
 				    publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'build/report/html', reportFiles: 'index.html', reportName: 'UnitTest Report', reportTitles: 'UnitTest Report'])
 				    
 				}
 			 }
        }
        
        //部署
        stage('Build') {
            when { expression { return env.BUILD == 'true'} }
            steps {
				sh '\\cp -rf /opt/temp2/workspace/pipeSvn/webapps/ROOT/. /opt/asorigin/web/webapps/ROOT'				
				sh 'rm -rf /opt/asorigin/web/webapps/ROOT/WEB-INF/classes'
				sh 'cp -rf /opt/temp2/workspace/pipeSvn/classes/. /opt/asorigin/web/webapps/ROOT/WEB-INF/classes'
				sh 'rm -rf /opt/temp2/workspace/pipeSvn/classes'
				sh 'service asoriginweb restart'
            }
        }     
        
        //APITest
        stage('APITest') {
            when { expression { return env.APITest == 'true'} }
            steps {
               // sh 'yum install -y nodejs'
			   //sh 'node -v'
               //sh 'npm install newman -g'
			   //sh 'newman -v'
				sh 'newman run /opt/temp2/workspace/pipeSvn/newman/ASOrigin.postman_collection.json -e /opt/temp2/workspace/pipeSvn/newman/env.json -r html --reporter-html-export /opt/temp2/workspace/pipeSvn/build/report/ApiTest/index.html'				
             				//顯示報告
 				script{
 				    publishHTML([allowMissing: false, alwaysLinkToLastBuild: false, keepAll: false, reportDir: 'build/report/ApiTest', reportFiles: 'index.html', reportName: 'ApiTest Report', reportTitles: 'ApiTest Report'])
 				    
 				}
            }
        }  
        
        //生成升級檔
        stage('upgrade') {
        	when { expression { return env.UPGRADE == 'true'} }
            steps {

				sh '''
					if [ ! -d "/root/web" ]; then
						mkdir /root/web
						mkdir /root/web/webapps
					fi
				'''

				sh 'cp -r /opt/asorigin/web/webapps/ROOT/ /root/web/webapps'
				sh 'rm -rf /root/web/webapps/ROOT/lic'
				sh 'rm -rf /root/web/webapps/ROOT/data.dll'
				sh 'pwd'
				dir("/root/web") {
				    sh "tar zcvf /root/upgrade${env.VERSION}.tar.gz **"
					sh 'pwd'
				}
				dir("/root/") {
				    sh 'rm -rf web'
				    sh 'rm -rf web@tmp'
					sh "mv upgrade${env.VERSION}.tar.gz upgrade${env.VERSION}.OPS"
				}
            }
        }
        
        //打包成rpm
        // > %{SOURCE0}
        stage('rpmbuild') {
        	when { expression { return env.RPMBUILD == 'true'} }
            steps {
				
				sh "echo 'rpmbuild -ba SPECS/${env.NAME}.spec' > /root/rpmbuild/build.sh"
				sh 'chmod +x /root/rpmbuild/build.sh'
				
				sh 	"""
cat > /root/rpmbuild/SPECS/${env.NAME}.spec <<_EOF_
%define SOURCE_DIR ${env.NAME}-${env.VERSION}
%define SOURCE_NAME %{SOURCE_DIR}.tar.gz
Name:       ${env.NAME}
Version:    ${env.VERSION}
Release:    1
Vendor:     ascentac
Summary:    ${env.BNAME} X86_64
License:    ascentac
Source0:    ${env.NAME}-${env.VERSION}.tar.gz
%description
${env.BNAME} package


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
./install.sh > /dev/null
cd ..
rm -rf %{SOURCE_DIR}
> /tmp/%{SOURCE_NAME}
%files
/tmp/%{SOURCE_NAME}
%defattr (-,root,root)
%postun
service ${env.NAME}db stop
service ${env.NAME}web stop
rm -rf /opt/${env.NAME}
/sbin/chkconfig --del ${env.NAME}web
/sbin/chkconfig --del ${env.NAME}db
rm -f /etc/init.d/${env.NAME}web
rm -f /etc/init.d/${env.NAME}db

_EOF_
					"""
			sh "chmod +x /root/rpmbuild/SPECS/${env.NAME}.spec"
					
           }
        }
        
        
                //打包成rpm
        stage('rpm') {
        	when { expression { return env.RPM == 'true'} }
            steps {
            	//複製資料庫
 				dir("/opt/${env.NAME}") {
					sh "service ${env.NAME}db stop"
					sh "tar zcvf ${env.NAME}_db.tar.gz db"
					sh "mv -f /opt/${env.NAME}/${env.NAME}_db.tar.gz /root/${env.NAME}/${env.NAME}_db.tar.gz"		
					sh "service ${env.NAME}db start"
					sh "service ${env.NAME}web start"
				}
				dir("/root/${env.NAME}"){
					sh "rm -rf db"
					sh "tar zxvf ${env.NAME}_db.tar.gz"
					sh "rm -rf ${env.NAME}_db.tar.gz"
				}	           
            	//產製資料
				sh "mkdir -p /root/${env.NAME}-${env.VERSION}"
				sh "cp -rf /root/${env.NAME}-${env.OLDVERSION}/* /root/${env.NAME}-${env.VERSION}"
				//複製root
				dir("/root/${env.NAME}") {
					sh "cp -rf /opt/${env.NAME}/web/webapps/*/ /root/${env.NAME}/web/webapps"
					sh "tar zcvf /root/${env.NAME}-${env.VERSION}/${env.NAME}.tar.gz **"
				}
				//打包
				dir("/root") {
					sh "tar zcvf /root/rpmbuild/SOURCES/${env.NAME}-${env.VERSION}.tar.gz ${env.NAME}-${env.VERSION}"
					sh "yum -y install rpm-build"
					sh "rpmbuild -ba /root/rpmbuild/SPECS/${env.NAME}.spec"
					sh "rm -rf ${env.NAME}-${env.VERSION}"
				}
				sh "mv -f /root/rpmbuild/RPMS/x86_64/${env.NAME}-${env.VERSION}-1.x86_64.rpm /root/${env.NAME}-${env.VERSION}-1.x86_64.rpm"				
           }
        }  
    }
    
}