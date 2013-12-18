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
# TARGETPORT - sshPORT

# I want to make this more readable!!!
log_entry configuring  wired network on ${TARGETHOST}
ssh -t -p ${TARGETPORT} ${TARGETHOST} -C "sudo hostname ${NODENAME}; sudo sed -i \"s/${TARGETHOST}/${NODENAME}/g\" /etc/hosts; sudo sed -i \"s/${TARGETHOST}/${NODENAME}/g\" /etc/hostname; echo allow-hotplug eth1 | sudo tee -a /etc/network/interfaces; echo auto ${IFACE} | sudo tee -a /etc/network/interfaces; echo iface ${IFACE} inet static | sudo tee -a /etc/network/interfaces; echo address ${NODEIP} | sudo tee -a /etc/network/interfaces; echo gateway ${GW} | sudo tee -a /etc/network/interfaces; echo netmask ${NETMASK} | sudo tee -a /etc/network/interfaces; echo network ${NETWORK} | sudo tee -a /etc/network/interfaces; echo broadcast ${BROADCAST} | sudo tee -a /etc/network/interfaces"

# Try this
SSH_COMMAND=""
SSH_COMMAND="sudo hostname ${NODENAME};"
SSH_COMMAND=${SSH_COMMAND}" sudo sed -i \"s/${TARGETHOST}/${NODENAME}/g\" /etc/hosts;"
SSH_COMMAND=${SSH_COMMAND}" sudo sed -i \"s/${TARGETHOST}/${NODENAME}/g\" /etc/hostname;"
SSH_COMMAND=${SSH_COMMAND}" echo allow-hotplug eth1 | sudo tee -a /etc/network/interfaces;"
SSH_COMMAND=${SSH_COMMAND}" echo auto ${IFACE} | sudo tee -a /etc/network/interfaces; "
SSH_COMMAND=${SSH_COMMAND}" echo iface ${IFACE} inet static | sudo tee -a /etc/network/interfaces; "
SSH_COMMAND=${SSH_COMMAND}" echo address ${NODEIP} | sudo tee -a /etc/network/interfaces;"
SSH_COMMAND=${SSH_COMMAND}" echo gateway ${GW} | sudo tee -a /etc/network/interfaces;"
SSH_COMMAND=${SSH_COMMAND}" echo netmask ${NETMASK} | sudo tee -a /etc/network/interfaces;"
SSH_COMMAND=${SSH_COMMAND}" echo network ${NETWORK} | sudo tee -a /etc/network/interfaces;"
SSH_COMMAND=${SSH_COMMAND}" echo broadcast ${BROADCAST} | sudo tee -a /etc/network/interface"
# ssh -t -p ${TARGETPORT} ${TARGETHOST} -C \"${SSH_COMMAND}\"






# SSH_COMMAND=${SSH_COMMAND}"sed -i \"s/<value>*<\/value>/<value>${HADOOP_DFS_REPLICAS}<\/value>/g\" ${HADOOP_CONF_DIR}/${HADOOP_HDFS_SITE_FILE};"
