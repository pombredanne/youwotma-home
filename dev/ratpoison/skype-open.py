#!/usr/bin/env python

import ratopen
import dbus
from plumbum.cmd import ps, skype

wn = ratopen.findwindow("skype")
if wn >= 0:
    print "ch window"
    ratopen.chwindow(wn)
elif ps["-C","skype"].run(retcode=None)[0] == 0:
    print "focusing"
    remote_bus = dbus.SessionBus()

    out_connection = remote_bus.get_object('com.Skype.API', '/com/Skype')

    out_connection.Invoke('NAME skypeOpen')
    out_connection.Invoke('PROTOCOL 5')
    out_connection.Invoke('FOCUS')
else:
    print "run"
    skype()
