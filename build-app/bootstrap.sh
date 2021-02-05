#!/usr/bin/env bash

# INSTALLING REQUIREMENTS
sudo yum update

# Git
GIT=`sudo yum list installed | grep -w git | wc -l`
if [ $GIT -eq 0 ]; then
    sudo yum install -y git
fi

# Golang
if ! [ -d "/usr/local/go" ]; then
    wget -q https://golang.org/dl/go1.15.7.linux-amd64.tar.gz -P /home/vagrant
    sudo tar -C /usr/local -xzf /home/vagrant/go1.15.7.linux-amd64.tar.gz
    rm /home/vagrant/go1.15.7.linux-amd64.tar.gz
fi
echo "export PATH=$PATH:/usr/local/go/bin" > /etc/profile.d/sh.local
echo "export PORT=4001" >> /etc/profile.d/sh.local

# Node & NPM
NODEJS=`sudo yum list installed | grep -w nodejs | wc -l`
if [ $NODEJS -eq 0 ]; then
    curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
    sudo yum install -y nodejs
fi

if ! [ -L "/usr/bin/vue" ]; then
    sudo npm install -g @vue/cli
fi

# BUILD PROCESS
if ! [ -d "/home/vagrant/vuego-demoapp" ]; then
    git clone https://github.com/jdmendozaa/vuego-demoapp.git /home/vagrant/vuego-demoapp
fi

# Golang
cd /home/vagrant/vuego-demoapp/server
/usr/local/go/bin/go build && mv vuego-demoapp /shared

# Vue
echo 'VUE_APP_API_ENDPOINT="http://10.0.0.8:4001/api"' > /home/vagrant/vuego-demoapp/spa/.env.production.local
cd /home/vagrant/vuego-demoapp/spa
sudo npm install
sudo npm run build
tar -czf dist.tar.gz dist && mv dist.tar.gz /shared
