#/bin/sh

# Regenera las ctags para usar con vim

cd ~
ctags -R --exclude '*site-packages*' -f .stdlib-tags /usr/lib/python2.6/
ctags -R --exclude='*.js' -f .django-tags /usr/lib/python2.6/site-packages/django/
