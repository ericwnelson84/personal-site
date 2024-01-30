#!/bin/bash

yum update -y
amazon-linux-extras install epel -y # this package has items for certbot used for SSL encryption. may need this command later yum install certbot python2-certbot-nginx
yum install nginx -y
yum install git -y
yum install gcc -y
yum install build-essential -y
yum install python3-pip python3-devel python3-setuptools -y

git config --system credential.https://git-codecommit.us-east-1.amazonaws.com.helper '!aws --profile default codecommit credential-helper $@'
git config --system credential.https://git-codecommit.us-east-1.amazonaws.com.UseHttpPath true

aws configure set region us-east-1

mkdir -p /var/www

# update me
git clone https://git-codecommit.us-east-1.amazonaws.com/v1/repos/personal-site /var/www

cd /var/www

# Run cloudwatch script here. be sure to give full permissions

git config core.fileMode false

# update me. for storing env variables in s3
# aws s3 cp s3://korben-bucket/simple-flask/.env .env

chmod +x scripts/post_userdata.sh

./scripts/post_userdata.sh
