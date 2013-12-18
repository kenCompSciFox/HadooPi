#!/bin/bash
# scripts/lib/net_config_wired.bash
# Author: ken Fox
# December 2013
# configures wired networking with static IP address
#
#iface eth0 inet static
#        address ${IP}
#        netmask 255.255.255.0
#        gateway ${GW}
#
# variable DEPNEDENCIES
# NODENAME is the hostname
# NODEIP   Ip address of the node
# GW       Gateway
# NETWORK
# BROADCAST
# TARGETHOST - host we are sshing into
# TARGETHOST can be different than the NODENAME or NODEIP because we could be changing that

# the network needs to be bounced if we change this however, we probably want to
# finish all of our installation and configuration changes before we bounce it

# TODO redesign this so it pulls in the existing file and edits it instead of
# simply appending things to the end of the file - if this were run more than once
# I think it owuld break stuff, while it should really result in an unchanged file
# unles the data changed somehow (different gateway or something)


log_entry configuring  wired network on ${TARGETHOSTNAME}

# Try this
SSH_COMMAND=""
# change the hostname to NODENAME
SSH_COMMAND="sudo hostname ${NODENAME};"
# Change the hostname to NODENAME  in /etc/hosts and /etc/hostname
SSH_COMMAND=${SSH_COMMAND}" sudo sed -i \"s/${TARGETHOSTNAME}/${NODENAME}/g\" /etc/hosts;"
SSH_COMMAND=${SSH_COMMAND}" sudo sed -i \"s/${TARGETHOSTNAME}/${NODENAME}/g\" /etc/hostname;"

# reconfigure the network interfaces file from DHCP to wired static IP Address
SSH_COMMAND=${SSH_COMMAND}" echo allow-hotplug eth1 | sudo tee -a /etc/network/interfaces;"
SSH_COMMAND=${SSH_COMMAND}" echo auto ${IFACE} | sudo tee -a /etc/network/interfaces; "
SSH_COMMAND=${SSH_COMMAND}" echo iface ${IFACE} inet static | sudo tee -a /etc/network/interfaces; "
SSH_COMMAND=${SSH_COMMAND}" echo address ${NODEIP} | sudo tee -a /etc/network/interfaces;"
SSH_COMMAND=${SSH_COMMAND}" echo gateway ${GW} | sudo tee -a /etc/network/interfaces;"
SSH_COMMAND=${SSH_COMMAND}" echo netmask ${NETMASK} | sudo tee -a /etc/network/interfaces;"
SSH_COMMAND=${SSH_COMMAND}" echo network ${NETWORK} | sudo tee -a /etc/network/interfaces;"
SSH_COMMAND=${SSH_COMMAND}" echo broadcast ${BROADCAST} | sudo tee -a /etc/network/interfaces"

SSH ${TARGETHOSTNAME} ${SSH_COMMAND}

