from pyshutils import *

for name in find(glob("~/tmp")):
    print ">" , repr(name)

