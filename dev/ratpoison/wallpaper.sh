# Cambiar fondo de escritorio aleatoriamente
# https://wiki.archlinux.org/index.php/Feh

while true
do
    find /home/carl/dev/youwotma-home/backgrounds/ -type f \( -name '*.jpg' -o -name '*.png' \) -print0 | shuf -n1 -z | xargs -0 feh --bg-max
    sleep 20m
done
