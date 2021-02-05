#!/usr/bin/env bash

# Decompress dist artifact
if ! [ -d "/shared/dist" ]; then
    tar -C /shared -xzf /shared/dist.tar.gz
fi

# Set up the nginx repo
sudo cat > /etc/rum.repos.d/nginx.repo << 'end'
[nginx]
nme=nginx repo
baseurl=https://nginx.org/packages/mainline/centos/7/$basearch/
gpgcheck=0
enabled=1
end

# Update w/ new repositories
sudo yum update

# Install nginx
NGINX=`sudo yum list installed | grep -w nginx | wc -l`
if [ $NGINX -eq 0 ]; then
    sudo yum install -y nginx
fi

# Running nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Updating nginx.conf
sudo cat > /etc/nginx/nginx.conf << 'end'
user  nginx;
worker_processes  1;
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;
events {
  worker_connections  1024;
}
http {
  include       /etc/nginx/mime.types;
  default_type  application/octet-stream;
  log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                    '$status $body_bytes_sent "$http_referer" '
                    '"$http_user_agent" "$http_x_forwarded_for"';
  access_log  /var/log/nginx/access.log  main;
  sendfile        on;
  keepalive_timeout  65;
  server {
    listen       80;
    server_name  localhost;
    location / {
      root   /shared/dist;
      index  index.html;
      try_files $uri $uri/ /index.html;
    }
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
      root   /usr/share/nginx/html;
    }
  }
}
end

# Update changes
sudo systemctl reload nginx
