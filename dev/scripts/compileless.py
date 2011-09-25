#!/bin/env python
# -*- coding: utf-8 -*-

import sys,os,subprocess,re
assert len(sys.argv) == 2

file=sys.argv[1]
absfile = os.path.abspath(file)


name = os.path.basename(absfile)
newname = re.sub("\.less$","",name) + ".css"

print "escribiendo a %s" % newname

contdir = os.path.dirname(absfile)

args = ["lessc",absfile]

f=open(os.path.join(contdir,newname),"w")

s=subprocess.Popen(args,stdout=f).wait()

f.close()

#sys.stdin.read(1)

