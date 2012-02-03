#!/bin/env python

# Python bash-style scripting helpers

from os import chdir as cd
import glob as builtin_glob
import os, pickle, sys
import shlex
import subprocess

__all__ = ["cd","load","save","cmd","pipe","find","glob","retcode","size","os","sys","ssh","itercmd"]

def load(filename,default):
    try:
        return pickle.load(open(filename,"r"))
    except IOError,e:
        return default

def save(filename,obj):
    pickle.dump(obj,open(filename,"w"))

def cmd(desc,stdin=subprocess.PIPE,stdout=subprocess.PIPE):
    if isinstance(desc,basestring):
        return subprocess.Popen(shlex.split(desc),stdin=stdin,stdout=stdout)
    elif isinstance(desc,list):
        return subprocess.Popen(desc,stdin=stdin,stdout=stdout)
    elif isinstance(desc,subprocess.Popen):
        return desc
    raise Exception("argument passed to cmd inconvertible to Popen")

def pipe(*cmds,**kwargs):
    assert len(cmds) >= 2

    stdin = kwargs.get("stdin",subprocess.PIPE)
    stdout = kwargs.get("stdout",subprocess.PIPE)
    last = cmd(cmds[0],stdin=stdin,stdout=subprocess.PIPE)

    for cm in cmds[1:-1]:
        last = cmd(cm,stdin=last.stdout,stdout=subprocess.PIPE)

    last = cmd(cmds[-1],stdin=last.stdout,stdout=stdout)
    return last

def retcode(obj,stdin=subprocess.PIPE,stdout=subprocess.PIPE):
    return cmd(obj,stdin=stdin,stdout=stdout).wait()

def ssh(*args):
    cm = cmd(["ssh"] + list(args))
    out,err = cm.communicate()
    return (out,err,cm.returncode)

def itercmd(args):
    return cmd(args,stdin=sys.stdin,out=sys.stdout).wait()

def strip_iter(iterator):
    for line in iterator:
        yield line.strip()

def flattern_list(lst):
    for elm in lst:
        if type(elm) in (str,unicode):
            yield elm
        else:
            for elmm in flattern_list(elm):
                yield elmm

def find(roots=".",followlinks=False,includedirs=False):
    for root in flattern_list([roots]):
        for path, dirlist, filelist in os.walk(root,followlinks=followlinks):
            if includedirs:
                for name in dirlist:
                    yield os.path.join(path,name)
            for name in filelist:
                yield os.path.join(path,name)


def rm(*args,**kwargs):
    arg = ["rm"]
    if kwargs.get("r",False):
        arg.append("-r")
    if kwargs.get("f",False):
        arg.append("-f")
    arg.extend(flattern_list(args))
    rmcmd = cmd(arg,stdout=sys.stdout)
    return rmcmd.wait() == 0

def glob(s):
    return builtin_glob.iglob(os.path.expanduser(s))

def size(path):
    return os.path.getsize(path)
