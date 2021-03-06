#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys,os,subprocess
assert len(sys.argv) == 2

file=sys.argv[1]
absfile = os.path.abspath(file)

contdir = os.path.dirname(absfile)
contdir_last = os.path.basename(contdir)

args = ["compass","compile",absfile,"--boring","--sass-dir",contdir,"--css-dir",contdir]

if contdir_last == "css":
    args += ["--images-dir",os.path.join(contdir,"..","img")]

p = subprocess.Popen(args,stdout=subprocess.PIPE,stderr=subprocess.PIPE)

stdout, stderr = p.communicate()

if p.returncode != 0:
    subprocess.Popen(["zenity","--error","--text=" + stdout + stderr])

#sys.stdin.read(1)

