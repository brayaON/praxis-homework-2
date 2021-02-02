#!/usr/bin/env bash

# Requirements for build
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

# Node & NPM
NODEJS=`sudo yum list installed | grep -w nodejs | wc -l`
if [ $NODEJS -eq 0 ]; then
    curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
    sudo yum install -y nodejs
fi

if ! [ -L "/usr/bin/vue" ]; then
    sudo npm install -g @vue/cli
fi
