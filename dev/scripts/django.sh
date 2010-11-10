#!/bin/sh

for module in django.bin django.core django.forms django.shortcuts django.test django.conf django.db django.http django.template django.utils django.contrib django.dispatch django.middleware django.templatetags django.views
do
    export DJANGO_SETTINGS_MODULE=settings
    export PYTHONPATH=/home/carl/dev/zenosfood/
    python pydiction.py "$module"
done
