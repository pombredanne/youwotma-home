#!/bin/env python

# Script mas util EVER:
# Toma dos parametros: Nombre de la ventana y un nombre de un ejecutable
# Si encuentra una ventana con ese nombre, cambia a ella
# Si no ejecuta el ejecutable
# Esta pensado para usarsarse con las combinaciones de teclas de ratpoison:
#
# bind y ratopen Navigator firefox
#
# Para ver los nombres de las ventanas:
#
# $ratpoison -c '%n'

from subprocess import Popen, PIPE
import re

def rat_cmd(cmd):
	return Popen(['ratpoison','-c',cmd], stdout = PIPE).stdout.read()

def rat_echo(msg):
  rat_cmd("echo %s" % msg)

def findwindow(windowname):
	output = rat_cmd('windows %n %a')
	
	windows = output.split("\n")
	for window in windows:
		m = re.match("^([0-9]+) (.*)$",window)

		if m and m.group(2) == windowname:
			return int(m.group(1))
	return -1


if __name__ == "__main__":
  import sys
  if len(sys.argv) == 3:
    winname, command = sys.argv[1:]
  elif len(sys.argv) == 2:
    winname = command = sys.argv[1]
  else:
    print "Usage: ratopen.py winname command"
    sys.exit()
  
  wn = findwindow(winname)
  if wn >= 0:
    rat_cmd("select %s" % wn)
  else:
    Popen([command])

