# Añadir noatime y discard a /etc/fstab
# Añadir particiones temporales
# tmpfs      /var/log        tmpfs        defaults           0    0
# tmpfs      /tmp            tmpfs        defaults           0    0
# tmpfs      /var/tmp        tmpfs        defaults           0    0


# Crear directorios temporales al iniciar (añadir a /etc/rc.local)
#for dir in apparmor apt cups dist-upgrade fsck gdm installer samba unattended-upgrades ; do
#        if [ ! -e /var/log/$dir ] ; then
#                mkdir /var/log/$dir
#        fi
#done


# Cambiar opciones del kernel a 
# GRUB_CMDLINE_LINUX_DEFAULT="elevator=noop quiet splash"
# en /etc/default/grub


