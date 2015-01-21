#!/bin/bash
NAME=ubuntu-1404-amd64-love

sudo lxc-create -t download -n $NAME -- -d ubuntu -r trusty -a amd64
sudo lxc-start -d -n $NAME
sudo lxc-attach -n $NAME apt-get update
sudo lxc-attach -n $NAME apt-get upgrade
sudo lxc-attach -n $NAME apt-get install openssh-server xserver-xephyr xdm xpra
sudo lxc-attach -n $NAME apt-get install libasound-dev libpulse-dev

# Need to run manually on container
sed -i "s/DisplayManager.requestPort/!DisplayManager.requestPort/g" /etc/X11/xdm/xdm-config
sed -i "/#any host/c\" /etc/X11/xdm/Xaccess"
xpra start :10 --start-child="Xephyr -ac -screen 800x600 -query localhost -host-cursor -reset -terminate :10" --exit-with-children

# Must retrieve pid; wait a kill it (if its more than 3 seconds its run fine (maybe ? ^^^^))
DISPLAY=:10 ./game.run
echo $?