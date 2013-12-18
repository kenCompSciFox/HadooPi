#!/bin/bash
# scripts/lib/new_host_RPi.bash
# Author: Ken Fox
# December 2013
# version 0.0.0
# New RaspberryPi Host
# Set up a new RaspberryPi over the newtork -
# ----------------------------------------------------------------
# Broke this out because we may be setting up systems that are not
# RPis too - for instance Idle machines, and we may not
# want to alter thier configurations so drastically.
# Phases common to all node setups are in other modules
#
# Configures a new host by doing the following:
# Update the software repository on the machine
# Update the networking
# ----------------------------------------------------------------
WIRELESS=0

log_entry updating software and repositories on  ${TARGETHOST}

# sudo add-apt-repository -y ppa:webupd8team/java; # doesn't work on RPi -- removed
ssh -t -p ${TARGETPORT} ${TARGETHOST} -C "sudo apt-get -y --force-yes install python-software-properties;  sudo apt-get update; "

if [ ${WIRELESS} ]
then
# configure Wireless Networking
source ${NODECONTROLLER_INSTALL}/lib/net_config_wireless.bash
else
# configure wired networking
source ${NODECONTROLLER_INSTALL}/lib/net_config_wired.bash
fi

