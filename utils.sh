PREOK="[OK]  "
PREFAIL="[FAIL]"

confirm(){
    echo "$1 (y/n)?"
    read res
    while [ "x$res" != "xy" ] && [ "x$res" != "xn" ]
    do
        echo "please, write y or n"
        read res
    done
    if [ x"$res" = "xy" ]
    then
        return 0
    else
        return 1
    fi
}

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

