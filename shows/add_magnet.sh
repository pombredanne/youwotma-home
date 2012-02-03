#!/bin/sh

RES=`transmission-remote -a $1`
notify-send "$RES"
