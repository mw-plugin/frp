#!/bin/bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH


curPath=`pwd`
rootPath=$(dirname "$curPath")

wget -O /tmp/frp.tar.gz https://github.com/fatedier/frp/releases/download/v0.44.0/frp_0.44.0_linux_amd64.tar.gz
cd /tmp && tar -zxvf /tmp/frp.tar.gz


mkdir -p /www/server/mdserver-web/plugins/frpc
cp -rf  /tmp/frp_0.44.0_linux_amd64/frpc /www/server/mdserver-web/plugins/frpc/
cp -rf  /tmp/frp_0.44.0_linux_amd64/frpc.ini /www/server/mdserver-web/plugins/frpc/


rm -rf /tmp/frp_0.44.0_linux_amd64
rm -rf /tmp/frp.tar.gz