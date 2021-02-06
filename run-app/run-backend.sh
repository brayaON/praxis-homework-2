#!/usr/bin/env bash

# Env vars
echo "export PORT=4001" > /home/vagrant/.profile
source /home/vagrant/.profile

# NOTE: This part is a try to execute the Go artifact every time the system is reboot
#       but there is a couple of bugs here. The first one, is that seems that when we
#       we run a service at a boot time, it cannot read environmental variables (or 
#       at least that's what i think) so it always going to execute on PORT 4000.
#       Another bug i wasn't able to fix, was that when i run localhost:4000/api/info on
#       the host machine, it will output a error, but if I run 10.0.0.8/api/info, then it will
#       show the proper info.

# sudo cat > /etc/systemd/system/demoapp.service << 'end'
# [Unit]
# Description=Vuego Demoapp

# [Service]
# ExecStart=/shared/vuego-demoapp

# [Install]
# WantedBy=multi-user.target
# end
# sudo systemctl start demoapp
# sudo systemctl enable demoapp

# Run in background

# Check if that process isn't already running
PID_DEMO=`pidof vuego-demoapp | wc -l`
if [ $PID_DEMO -eq 0 ]; then
    /shared/vuego-demoapp &> /dev/null &
    disown -h
    echo "Backend running"
    exit
else
    echo "Backend running"
fi


