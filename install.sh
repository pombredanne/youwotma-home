GIT_ROOT=`pwd`

source utils.sh

if [ ! -e ~/.pcname ]
then
    echo "Donde estas? laptop/pc"
    read TYPE
    echo $TYPE > ~/.pcname
fi

cd ~

[ ! -d dev ] && mkdir dev

cd "$GIT_ROOT/dev"
PROJECTS=`ls`
cd ~/dev/

for proj in $PROJECTS
do
    lnbak $proj dev/
done

cd $GIT_ROOT
for file in `find . | grep install.sh`
do
    dir=`dirname $file`
    name=`basename $file`
    if [ x$dir != 'x.' ]
    then
        echo "Ejecutando $file"
        cd $dir
        source $name
        cd $GIT_ROOT
    fi
done

