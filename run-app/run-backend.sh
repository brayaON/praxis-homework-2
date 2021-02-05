#!/usr/bin/env bash

# Env vars
echo "export PORT=4001" > /home/vagrant/.profile

# Run in background
source /home/vagrant/.profile
/shared/vuego-demoapp &> /dev/null &
disown -h
exit
