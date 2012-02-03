#!/bin/sh

chromium-browser --disable-web-security --remote-debugging-port=9222 $@
