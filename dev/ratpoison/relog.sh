#/bin/sh
#ratpoison -c "echo `date +'%R - %A %n%D - %B'` `cal | tail -n +2 | sed -e 's/^lu/\n\nlu/' | sed -e 's/sá/sa/' ` "

$ESP="             "

CAL=`date +'%R - %A %n%D - %B' | sed -e 's/á/a/g' -e 's/é/e/g' -e 's/í/i/g' -e 's/ó/o/g' -e 's/ú/u/g'`
CAL="$CAL

"`ncal -3MCh | sed -e 's/á/a/g' -e 's/é/e/g' -e 's/í/i/g' -e 's/ó/o/g' -e 's/ú/u/g'`"
LA: "`TZ='America/Los_Angeles' date +'%R %D'`"        ESP: "`TZ='Europe/Madrid' date +'%R %D'`"
NY: "`TZ='America/New_York'    date +'%R %D'`"         CA: "`TZ='Canada/Atlantic' date +'%R %D'`"
UK: "`TZ='Europe/London'       date +'%R %D'`"      TOKIO: "`TZ='Japan' date +'%R %D'`



ratpoison -c "echo $CAL"
