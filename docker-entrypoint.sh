#!/bin/bash
set -e

askbot-setup --force --dir-name=. --db-engine=${ASKBOT_DATABASE_ENGINE:-1} --db-name=${ASKBOT_DATABASE_NAME:-db.sqlite} --db-user="${ASKBOT_DATABASE_USER}" --db-password="${ASKBOT_DATABASE_PASSWORD}" --db-host="${ASKBOT_DATABASE_HOST}" --db-port=${ASKBOT_DATABASE_PORT}

sed "s/SECRET_KEY.*/SECRET_KEY = '`head /dev/urandom | tr -dc a-f0-9 | head -c 32`'/" settings.py -i

sed "s/ROOT_URLCONF.*/ROOT_URLCONF = 'urls'/" settings.py -i



# sed "s/LANGUAGES.*/ASKBOT_LANGUAGE_MODE = 'user-lang'\nfrom django.utils.translation import ugettext_lazy as _\nLANGUAGES = (('en', 'English'),('ja','japanese'))\nASKBOT_TRANSLATE_URL = False/" settings.py -i
# sed "s/#'askbot.middleware.locale.LocaleMiddleware',/'django.middleware.locale.LocaleMiddleware',/" settings.py -i


echo "import sys" >> settings.py
echo "reload(sys)" >> settings.py
echo "sys.setdefaultencoding('UTF8')" >> settings.py

python manage.py makemigrations
python manage.py migrate --noinput
python manage.py collectstatic --noinput



exec "$@"

