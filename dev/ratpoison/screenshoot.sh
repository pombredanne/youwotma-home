
set -e
fn=~/Pictures/screenshots/`date +"%m-%d-%Y-%T"`.png
scrot -q 100 -d 01 "$fn" 
ratpoison -c "echo Screenshot saved!"
/home/carl/dev/ratpoison/crop.py "$fn"

prompt(){

accion=`zenity --list --column 'accion' 'imgur' 'twitpic' 'portapapeles' 'inspiracion' 'ver' 'gimp'`

if [ "$accion" = "twitpic" ]
then
    /home/carl/dev/ratpoison/twitpic.py "$fn"
elif [ "$accion" = "imgur" ]
then
    curl -F "image=@$fn" -F "key=ed6bd99a77b8b791f647f6a2783ab051" http://api.imgur.com/2/upload.json > "$fn".upload
    url=`node /home/carl/dev/ratpoison/imgurparse.js "$fn".upload`
    if zenity --question --text $url
    then
        echo $url | xsel -i -b
    fi
elif [ "$accion" = "portapapeles" ]
then
    echo $fn | xsel -i -b
elif [ "$accion" = "inspiracion" ]
then
    name=`zenity --entry`
    name="$name-"`date +"%m-%d-%Y-%T"`.png
    mv "$fn" ~/Pictures/inspiracion/"$name"
elif [ "$accion" = "ver" ]
then
  display "$fn"
elif [ "$accion" = "gimp" ]
then
  gimp "$fn"
  prompt
fi

}
prompt

