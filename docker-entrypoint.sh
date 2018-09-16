#!/bin/bash
set -e

askbot-setup --force --dir-name=. --db-engine=${ASKBOT_DATABASE_ENGINE:-1} --db-name=${ASKBOT_DATABASE_NAME:-db.sqlite} --db-user="${ASKBOT_DATABASE_USER}" --db-password="${ASKBOT_DATABASE_PASSWORD}" --db-host="${ASKBOT_DATABASE_HOST}" --db-port=${ASKBOT_DATABASE_PORT}

sed "s/SECRET_KEY.*/SECRET_KEY = '`head /dev/urandom | tr -dc a-f0-9 | head -c 32`'/" settings.py -i

sed "s/ROOT_URLCONF.*/ROOT_URLCONF = 'urls'/" settings.py -i

python manage.py makemigrations
python manage.py migrate --noinput
python manage.py collectstatic --noinput



exec "$@"

