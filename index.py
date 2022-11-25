# coding:utf-8

import sys
import io
import os
import time
import re
import string
import subprocess

sys.path.append(os.getcwd() + "/class/core")
import mw

app_debug = False
if mw.isAppleSystem():
    app_debug = True


def getPluginName():
    return 'frp'


def getPluginDir():
    return mw.getPluginDir() + '/' + getPluginName()


def getServerDir():
    return mw.getServerDir() + '/' + getPluginName()


def status():
    data = mw.execShell(
        "ps -ef|grep frp |grep -v grep | grep -v python | awk '{print $2}'")
    if data[0] == '':
        return 'stop'

    return 'start'


def confClient():
    return getServerDir() + "/frpc.ini"


def confServer():
    return getServerDir() + "/frps.ini"


def initDreplace():
    # systemd
    systemDir = mw.systemdCfgDir()
    systemService = systemDir + '/frpc.service'
    systemServiceTpl = getPluginDir() + '/init.d/frpc.service.tpl'
    if os.path.exists(systemDir) and not os.path.exists(systemService):
        service_path = mw.getServerDir()
        se_content = mw.readFile(systemServiceTpl)
        se_content = se_content.replace('{$SERVER_PATH}', service_path)
        mw.writeFile(systemService, se_content)
        mw.execShell('systemctl daemon-reload')

    systemService = systemDir + '/frps.service'
    systemServiceTpl = getPluginDir() + '/init.d/frps.service.tpl'
    if os.path.exists(systemDir) and not os.path.exists(systemService):
        service_path = mw.getServerDir()
        se_content = mw.readFile(systemServiceTpl)
        se_content = se_content.replace('{$SERVER_PATH}', service_path)
        mw.writeFile(systemService, se_content)
        mw.execShell('systemctl daemon-reload')


def ftOp(method):
    if mw.isAppleSystem():
        return 'fail'

    initDreplace()

    cmd = 'systemctl ' + method + ' ' + getPluginName()
    data = mw.execShell(cmd)
    if data[1] != '':
        return 'fail'

    return 'ok'


def start():
    return ftOp('start')


def stop():
    return ftOp('stop')


def restart():
    return ftOp('restart')


def reload():
    return ftOp('reload')


def initdStatus():
    if mw.isAppleSystem():
        return "Apple Computer does not support"

    cmd = 'systemctl status frpc | grep loaded | grep "enabled;"'
    data = mw.execShell(cmd)
    if data[0] == '':
        return 'fail'
    return 'ok'


def initdInstall():
    if mw.isAppleSystem():
        return "Apple Computer does not support"

    mw.execShell('systemctl enable frpc')
    return 'ok'


def initdUinstall():
    if mw.isAppleSystem():
        return "Apple Computer does not support"

    mw.execShell('systemctl disable frpc')
    return 'ok'

if __name__ == "__main__":
    func = sys.argv[1]
    if func == 'status':
        print(status())
    elif func == 'start':
        print(start())
    elif func == 'stop':
        print(stop())
    elif func == 'restart':
        print(restart())
    elif func == 'reload':
        print(reload())
    elif func == 'initd_status':
        print(initdStatus())
    elif func == 'initd_install':
        print(initdInstall())
    elif func == 'initd_uninstall':
        print(initdUinstall())
    elif func == 'conf':
        print(conf())
    else:
        print('error')
