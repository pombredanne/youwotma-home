#/bin/sh
#ratpoison -c "echo `date +'%R - %A %n%D - %B'` `cal | tail -n +2 | sed -e 's/^lu/\n\nlu/' | sed -e 's/sá/sa/' ` "


CAL=`date +'%R - %A %n%D - %B' | sed -e 's/á/a/g' -e 's/é/e/g' -e 's/í/i/g' -e 's/ó/o/g' -e 's/ú/u/g'`
CAL="$CAL

"`ncal -3MCh | sed -e 's/á/a/g' -e 's/é/e/g' -e 's/í/i/g' -e 's/ó/o/g' -e 's/ú/u/g'`
ratpoison -c "echo $CAL"
