
[ ! -d /home/carl/dev/TagTime/ ] && confirm "instalar tagtime" && {
    git clone https://github.com/dreeves/TagTime.git /home/carl/dev/TagTime
    cp settings.pl /home/carl/dev/TagTime/
}

