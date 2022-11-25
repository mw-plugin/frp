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
    return 'frpc'


def getPluginDir():
    return mw.getPluginDir() + '/' + getPluginName()


def getServerDir():
    return mw.getServerDir() + '/' + getPluginName()


def status():
    def status():
    data = mw.execShell(
        "ps -ef|grep frp |grep -v grep | grep -v python | awk '{print $2}'")
    if data[0] == '':
        return 'stop'

    return 'start'


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
    return 'ok'


def stop():
    return 'ok'


def restart():
    return 'ok'


def reload():
    return 'ok'


def initdStatus():
    return 'ok'


def initdInstall():
    return 'ok'


def initdUinstall():
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
    else:
        print('error')
