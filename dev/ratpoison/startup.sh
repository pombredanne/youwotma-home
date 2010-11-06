
sudo /home/carl/dev/ratpoison/startup-root.sh

ratpoison -c 'echo Iniciando dropbox...'
dropboxd &
ratpoison -c 'echo Todo iniciado'

