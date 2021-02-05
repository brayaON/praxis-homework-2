#!/usr/bin/env bash

# Env vars
echo "export PORT=4001" > /home/vagrant/.profile
source /home/vagrant/.profile

# Run in background

# Check if that process isn't already running
PID_DEMO=`pidof vuego-demoapp | wc -l`
if [ PID_DEMO -eq 0 ]; then
    /shared/vuego-demoapp &> /dev/null &
    disown -h
    exit
fi
