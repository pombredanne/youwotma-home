#!/bin/env python

import ratopen as rat
from subprocess import Popen, PIPE
import re,time
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

def firefox_proxy(on):
  rat.rat_echo("Proxy %s" % on)
  if on:
    mode = 1
  else:
    mode = 0
  import socket

  HOST = 'localhost'    # The remote host
  PORT = 4242              # The same port as used by the server
  s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
  s.connect((HOST, PORT))
  time.sleep(0.1)
  data = s.recv(1024)
  s.send("""Application.prefs.setValue("network.proxy.type",%s);""" % mode)
  s.close()

def wget_proxy(on):
    foo = ["sed", "-i"]
    if on:
        foo += ["s/^use_proxy/#use_proxy/"]
    else:
        foo += ["s/^#use_proxy/use_proxy/"]
    foo += ["/etc/wgetrc"]
    Popen(foo).read()


def proxy(on):
  try:
    firefox_proxy(on)
  except:
    pass
  try:
      wget_proxy(on)
  except:
    pass

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

