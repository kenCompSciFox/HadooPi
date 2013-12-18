# configures wireless networking with static IP address
#!/bin/bash
# scripts/lib/net_config_wireless.bash
# Author: ken Fox
# December 2013
# configures wireless networking with static IP address
#
#iface eth0 inet static
#        address ${IP}
#        netmask 255.255.255.0
#        gateway ${GW}
#
# variable DEPNEDENCIES
# RPI_IFACE  - replace this with a generic IFACE that gets set to RPI_IFACE
# NODENAME
# NODEIP
# GW
# NETWORK
# BROADCAST
# TARGETHOST
# TARGETPORT

# NOT READY FOR PRIME TIME YET
log_entry ALERT Wireless networking configuration has not been implemented yet

# I want to make this more readable!!!
#log_entry configuring  wired network on ${TARGETHOST}
# ssh -t -p ${TARGETPORT} ${TARGETHOST} -C "sudo hostname ${NODENAME}; sudo sed -i \"s/${TARGETHOST}/${NODENAME}/g\" /etc/hosts; sudo sed -i \"s/${TARGETHOST}/${NODENAME}/g\" /etc/hostname; echo allow-hotplug eth1 | sudo tee -a /etc/network/interfaces; echo auto ${RPI_IFACE} | sudo tee -a /etc/network/interfaces; echo iface ${RPI_IFACE} inet static | sudo tee -a /etc/network/interfaces; echo address ${NODEIP} | sudo tee -a /etc/network/interfaces; echo gateway ${GW} | sudo tee -a /etc/network/interfaces; echo netmask ${NETMASK} | sudo tee -a /etc/network/interfaces; echo network ${NETWORK} | sudo tee -a /etc/network/interfaces; echo broadcast ${BROADCAST} | sudo tee -a /etc/network/interfaces"


