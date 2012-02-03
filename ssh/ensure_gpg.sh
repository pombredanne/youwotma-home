#!/bin/sh
set -e
cd /tmp

gpg -k | grep 'EF8A8761' || {
    echo "PGP keypair no encontrado!"
    echo "Introduce la localización de la clave privada (local o remota)"
    read key_loc
    scp "$key_loc" pgp_private.gpg
    gpg -d pgp_private.gpg > pgp_private
    wget http://bengoarocandio.com/pgp_public
    rm pgp_private.gpg
    gpg --import pgp_public
    gpg --allow-secret-key-import --import pgp_private
    rm pgp_public
    rm pgp_private
}

