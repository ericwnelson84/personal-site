#!/bin/bash

python3 -m venv venv
. venv/bin/activate
pip install -r /var/www/config/requirements.txt

chown -R ec2-user:nginx /var/www

mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf-orig
cp /var/www/config/nginx.conf /etc/nginx/nginx.conf

cp /var/www/config/flaskapp.conf /etc/nginx/conf.d/flaskapp.conf

cp /var/www/config/flaskapp.service /etc/systemd/system/flaskapp.service

mkdir /var/log/uwsgi
chown -R ec2-user:nginx /var/log/uwsgi

systemctl start flaskapp.service
systemctl enable flaskapp.service

systemctl restart nginx
systemctl enable nginx

echo 'Install complete'
