GIT_ROOT=`pwd`
PREOK="[OK]  "
PREFAIL="[FAIL]"

source utils.sh

if [ ! -e ~/.pcname ]
then
    echo "Donde estas? laptop/pc"
    read TYPE
    echo $TYPE > ~/.pcname
fi

cd ~

bak(){
	[ -e $1 ] && mv $1 $1.bak
}
lnbak(){
    destination="$GIT_ROOT/$2$1"
    if [ -L $1 ]
    then
        if [ x`readlink $1` == "x$destination" ]
        then
            echo "$PREOK Enlace simbolico ya existente y correcto: $1"
        else
            echo "$PREOK Enlace simbolico $1 apuntando a "`readlink $1`", cambiando a $destination"
            rm -I $1
            ln -s $destination $1
        fi
    else
    	bak $1
        ln -s $destination $1
    fi
}

lnbin(){
    prev=`pwd`
    destination="$prev/$1"
    cd /usr/bin/

    if [ -L $2 ]
    then
        if [ x`readlink $2` == "x$destination" ]
        then
            echo "$PREOK Enlace simbolico ya existente y correcto: $2"
        else
            echo "$PREOK Enlace simbolico $2 apuntando a "`readlink $2`", cambiando a $destination"
            sudo rm $2
            sudo ln -s $destination $2
        fi
    else
        if [ -e $2 ]
        then
            echo "Enlace existente $2, Borrar?"
            sudo rm -i $2
        fi

        if [ -e $2 ]
        then
            echo "$PREFAIL Archivo existente $2"
        else
            echo "$PREOK Creando enlace $2"
            sudo ln -s $destination $2
        fi
    fi
    cd "$prev"
}

lnbak .bashrc
lnbak .ratpoisonrc
lnbak .vim
lnbak .vimperatorrc
lnbak .vimperator
lnbak .vimrc
lnbak .bash_aliases
lnbak .inputrc

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

