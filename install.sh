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

if [ ${sysName} == "Darwin" ]; then
	OSNAME='macos'
elif grep -Eqi "CentOS" /etc/issue || grep -Eq "CentOS" /etc/*-release; then
	OSNAME='centos'
elif grep -Eqi "Fedora" /etc/issue || grep -Eq "Fedora" /etc/*-release; then
	OSNAME='fedora'
elif grep -Eqi "Debian" /etc/issue || grep -Eq "Debian" /etc/*-release; then
	OSNAME='debian'
elif grep -Eqi "Ubuntu" /etc/issue || grep -Eq "Ubuntu" /etc/*-release; then
	OSNAME='ubuntu'
elif grep -Eqi "Raspbian" /etc/issue || grep -Eq "Raspbian" /etc/*-release; then
	OSNAME='raspbian'
else
	OSNAME='unknow'
fi



Install_Plugin()
{
	echo '正在安装脚本文件...' > $install_tmp
	wget -O /tmp/frp.tar.gz https://github.com/fatedier/frp/releases/download/v0.44.0/frp_0.44.0_linux_amd64.tar.gz
	cd /tmp && tar -zxvf /tmp/frp.tar.gz
	mkdir /usr/local/frp
	mv /tmp/frp_0.44.0_linux_amd64/* /usr/local/frp
	rm -rf /tmp/frp.tar.gz
	rm -rf /tmp/frp_0.44.0_linux_amd64
	cp /www/server/mdserver-web/plugins/frpc/frps.service /usr/lib/systemd/system/frps.service
	mkdir -p $serverPath/frpc
	echo '0.1' > $serverPath/frpc/version.pl
	echo '安装完成' > $install_tmp
}

Uninstall_Plugin()
{
	rm -rf $serverPath/frpc
	systemctl stop frp
	rm -rf /usr/lib/systemd/system/frps.service
	rm -rf /usr/local/frp
	systemctl daemon-reload
	echo "Uninstall_sphinx" > $install_tmp
}

action=$1
if [ "${1}" == 'install' ];then
	Install_Plugin
else
	Uninstall_Plugin
fi
