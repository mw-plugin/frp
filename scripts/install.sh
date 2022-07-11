#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH


curPath=`pwd`
rootPath=$(dirname "$curPath")


wget -O /tmp/mw_plugin.zip https://github.com/mw-plugin/frpc/archive/refs/heads/main.zip
cd /tmp && unzip /tmp/mw_plugin.zip 

mkdir -p /www/server/mdserver-web/plugins/frpc
cp -rf  /tmp/frpc-main/* /www/server/mdserver-web/plugins/frpc


rm -rf /tmp/mw_plugin.zip
rm -rf /tmp/frpc-main