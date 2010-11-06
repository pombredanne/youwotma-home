#/bin/sh
ratpoison -c "echo `date +'%R - %A %n    %D - %B'`  `cal | tail -n +2 | sed -e 's/^Su/\n\n Su/' ` "
