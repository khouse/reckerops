#!/usr/bin/env bash
sed -i 's/#-RECKEROPS-BOOTSTRAP-UNCOMMENT-#//g' /etc/nginx/nginx.conf
systemctl reload nginx
