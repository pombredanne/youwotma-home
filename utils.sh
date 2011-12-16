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

