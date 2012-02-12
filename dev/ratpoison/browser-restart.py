#!/usr/bin/env python

import ratopen as rat

old = rat.activewindow()

for id in filter(lambda x: x>=0, [
        rat.findwindow("Navigator"), # Firefox
        rat.findwindow("chromium-browser"), # chrome
    ]):
    rat.chwindow(id)
    rat.rat_cmd("meta F5")
    rat.chwindow(old) # If you don't do this inside the loop, you can end in a different frame

