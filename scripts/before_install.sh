#!/bin/bash
# Stop the web server
systemctl stop httpd
# Clean up existing web files
rm -rf /var/www/html/*