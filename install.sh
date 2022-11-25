#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

curPath=`pwd`
rootPath=$(dirname "$curPath")
rootPath=$(dirname "$rootPath")
serverPath=$(dirname "$rootPath")
sysName=`uname`

install_tmp=${rootPath}/tmp/mw_install.pl


sysName=`uname`
echo "use system: ${sysName}"


bash ${rootPath}/scripts/getos.sh
OSNAME=`cat ${rootPath}/data/osname.pl`
OSNAME_ID=`cat /etc/*-release | grep VERSION_ID | awk -F = '{print $2}' | awk -F "\"" '{print $2}'`


VERSION=0.44.0

Install_Plugin()
{
	echo '正在安装脚本文件...' > $install_tmp

	APP_DIR=${serverPath}/source/frpc

	mkdir -p $serverPath/frpc
	mkdir -p $APP_DIR


	wget -O $APP_DIR/frp.tar.gz https://github.com/fatedier/frp/releases/download/v${VERSION}/frp_${VERSION}_linux_amd64.tar.gz
	cd $APP_DIR && tar -zxvf $APP_DIR/frp.tar.gz
	

	mv $APP_DIR/frp_${VERSION}_linux_amd64/* $serverPath/frpc

	# rm -rf $APP_DIR/frp.tar.gz
	# rm -rf $APP_DIR/frp_${VERSION}_linux_amd64

	echo ${VERSION} > $serverPath/frpc/version.pl
	echo 'install frpc' > $install_tmp
}

serDir=/usr/lib/systemd/system
if [ ! -d $serDir ];then
	serDir=/lib/systemd/system
fi

Uninstall_Plugin()
{
	rm -rf $serverPath/frpc

	if [ ! -d $serDir ];then
		echo "pass"
	else
		systemctl stop frpc
	  	rm -rf $serDir/frpc.service
	  	systemctl daemon-reload
	fi

	echo "Uninstall_frpc" > $install_tmp
}

action=$1
if [ "${1}" == 'install' ];then
	Install_Plugin
else
	Uninstall_Plugin
fi
