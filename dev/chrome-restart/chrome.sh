#!/bin/sh

export no_proxy=127.0.0.1
chromium-browser --disable-web-security --remote-debugging-port=9222 $@
