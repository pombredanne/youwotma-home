#!/bin/bash

wina=`ratpoison -c 'fdump 0' | cut -d ' ' -f 3`
winb=`ratpoison -c 'fdump 1' | cut -d ' ' -f 3`
ratpoison -c "swap $wina $winb"

