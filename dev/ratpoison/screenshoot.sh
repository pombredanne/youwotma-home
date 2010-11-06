fn=~/Pictures/screenshots/`date +"%m-%d-%Y-%T"`.png
scrot -q 100 -d 01 "$fn" 
ratpoison -c "echo Screenshot saved!"
/home/carl/dev/ratpoison/crop.py "$fn"

accion=`zenity --list --column 'accion' 'twitpic' 'portapapeles' 'ver'`

if [ "$accion" = "twitpic" ]
then
  /home/carl/dev/ratpoison/twitpic.py "$fn"
elif [ "$accion" = "portapapeles" ]
then
  echo $fn | xsel -i -b
elif [ "$accion" = "ver" ]
then
  display "$fn"
fi
