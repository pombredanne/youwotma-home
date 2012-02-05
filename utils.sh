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
    mkln "$destination" "$1"
}

lnbin(){
    mkln "$1" "/usr/bin/$2"
}

mkln(){
    link_target=`readlink -f "$1"`
    link_name="$2"
    if [ -L "$link_name" ]
    then
        if [ x`readlink "$link_name"` == "x$link_target" ]
        then
            echo "$PREOK Enlace simbolico ya existente y correcto: $link_name"
        else
            echo "$PREOK Enlace simbolico $link_name apuntando a "`readlink "$link_name"`", cambiando a $link_target"
            sudo rm "$link_name"
            sudo ln -s "$link_target" "$link_name"
        fi
    else
        if [ -e "$link_name" ]
        then
            echo "Archivo existente $link_name, Borrar?"
            sudo rm -i "$link_name"
        fi

        if [ -e "$link_name" ]
        then
            echo "$PREFAIL Archivo existente $link_name"
        else
            echo "$PREOK Creando enlace $link_name"
            sudo ln -s "$link_target" $link_name
        fi
    fi
}

