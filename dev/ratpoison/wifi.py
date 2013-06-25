#!/bin/env python

import ratopen as rat
from subprocess import Popen, PIPE
import re,time, os
def start_wpa():
  rat.rat_echo("Iniciando WPA")
  Popen(["wpa_supplicant","-c/etc/wpa_supplicant.conf","-iwlan0","-B"])


def stop_wpa():
  rat.rat_echo("Parando WPA")
  Popen(["wpa_cli","terminate"])

def wpa_status():
  cli = Popen(["wpa_cli","status"],stdout=PIPE,stderr=PIPE)
  stdout = cli.stdout.read() + cli.stderr.read()
  print "__%s__" % stdout
  if re.search("Failed to connect to wpa_supplicant",stdout):
    return "off"
  m = re.search("wpa_state=([A-Z]+)",stdout)
  if m:
    return m.group(1)
  return "unknown"

def wait_wpa(finstatus="COMPLETED"):
  n = 0
  ant = ""
  while n<60:
    print n
    status = wpa_status()
    print status
    if status != ant:
      rat.rat_echo("WPA_STATUS = %s" % status)
      ant = status
    if status == finstatus:
      return True
    elif status == "off" or status == "unknown":
      return False

    n+=1
    time.sleep(1)
  return False

def dhcpd():
  rat.rat_echo("DHCP discover...")
  dhc = Popen(["dhclient","wlan0"],stdout=PIPE,stderr=PIPE)
  rat.rat_echo(dhc.stdout.read() + dhc.stderr.read())


proxy_actions = []
def proxyaction(act):
    proxy_actions.append(act)
    return act

@proxyaction
def firefox_proxy(on):
  if on:
    cmd = "proxyon"
  else:
    cmd = "proxyoff"
  import socket

  HOST = 'localhost'    # The remote host
  PORT = 3144              # The same port as used by the server
  s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  s.connect((HOST, PORT))
  s.send(cmd + "\n")
  s.close()

def sed_proxy(on, offcmd, oncmd, file):
    if os.path.exists(file):
        foo = ["sed", "-i"]
        if on:
            foo += [oncmd]
        else:
            foo += [offcmd]
        foo += [file]
        Popen(foo).wait()

@proxyaction
def wget_proxy(on):
    sed_proxy(on,"s/^use_proxy/#use_proxy/","s/^#use_proxy/use_proxy/","/home/carl/.wgetrc")

@proxyaction
def apt_proxy(on):
    sed_proxy(on,"s?^Acquire::http::Proxy?//Acquire::http::Proxy?","s?^//Acquire::http::Proxy?Acquire::http::Proxy?","/etc/apt/apt.conf.d/95proxy")

@proxyaction
def s3_proxy(on):
    sed_proxy(on,"s/^proxy/#proxy/","s/^#proxy/proxy/","/home/carl/.s3cfg")

@proxyaction
def svn_proxy(on):
    sed_proxy(on,"s/^http-proxy/#http-proxy/","s/^#http-proxy/http-proxy/","/home/carl/.subversion/servers")

def proxy(on):
    for f in proxy_actions:
        try:
            f(on)
        except Exception, ex:
            print ex

    for protocol in ("http","https","ftp"):
        remp = {"p":protocol,"P":protocol.upper()}
        if on:
            rat.rat_cmd("setenv %(p)s_proxy %(p)s://proxy.alu.uma.es:3128/" % remp)
            rat.rat_cmd("setenv %(P)s_PROXY %(p)s://proxy.alu.uma.es:3128/" % remp)
        else:
            rat.rat_cmd("unsetenv %(p)s_proxy" % remp)
            rat.rat_cmd("unsetenv %(P)s_PROXY" % remp)
        f = open("/home/carl/.proxy","w")
        if on:
            f.write("proxy.alu.uma.es:3128")
        f.close()


if __name__ == "__main__":
  import sys
  action = sys.argv[1]
  if action == "uni":
    proxy(True)
    stop_wpa()
    print "=============="
    start_wpa()
    print "=============="
    time.sleep(2) #dat tiempo a wpa_supplicant para iniciar
    res = wait_wpa()
    if res:
      print "=============="
      dhcpd()
    else:
      rat.rat_echo("Error conexion (timeout o apagado inesperado)")
      print "No se ha podido conectar"
  elif action == "casa":
    stop_wpa()
    proxy(False)
  elif action == "proxy":
    proxy(True)
  elif action == "noproxy":
    proxy(False)

