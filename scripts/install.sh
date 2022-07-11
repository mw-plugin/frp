#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH


curPath=`pwd`
rootPath=$(dirname "$curPath")

wget -O /tmp/mw_plugin.zip https://github.com/mw-plugin/simple-plugin/archive/refs/heads/main.zip
cd /tmp && unzip /tmp/mw_plugin.zip 


mkdir -p /www/server/mdserver-web/plugins/frpc
cp -rf  /tmp/frp_0.44.0_linux_amd64/frpc /www/server/mdserver-web/plugins/frpc/
cp -rf  /tmp/frp_0.44.0_linux_amd64/frpc.ini /www/server/mdserver-web/plugins/frpc/


rm -rf /tmp/frp_0.44.0_linux_amd64
rm -rf /tmp/frp.tar.gz