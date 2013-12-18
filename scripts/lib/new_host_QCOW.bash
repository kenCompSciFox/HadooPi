#!/bin/bash
# scripts/lib/new_host_QCOW.bash
# Author: Ken Fox
# December 2013
# version 0.0.0
# New QCOW Host
# Set up a new QEMU QCOW image  over the newtork -
# ----------------------------------------------------------------
# Broke this out because we may be setting up systems that are not
# RPis too - for instance Idle machines, and we may not
# want to alter thier configurations so drastically.
# Phases common to all node setups are in other modules
#
# Configures a new host by doing the following:
# creates a new QCOW
# Update the software repository on the machine
# Update the networking
# ----------------------------------------------------------------

log_entry creating a new qcow as ${TARGETHOST}
# qcow stuff goes here

# WARNING All of the variable names and options need to be modified to
# conform to the structure of the nodecontroller.bash script - what's
# below was taken straight from bill's deploy.sh script

# Create base image
#	qemu-img create -f qcow2 base.qcow2 80G
#	kvm -drive file=base.qcow2 -cdrom /data/Installs/System/Ubuntu/iso/ubuntu-13.04-server-amd64.iso -vga std -m 8G
# Create master and slave images
#   qemu-img create -f qcow2 -b base.qcow2 {master,slave1,slave2}.qcow2
#	Run as
#		master
#			kvm -drive file=master.qcow2 -vga std -smp cores=4 -cpu host -m 8G -redir tcp:2222::22 -net nic,vlan=1 -net user,vlan=1 -net nic,vlan=2,macaddr=52:54:00:12:34:17 -net socket,vlan=2,listen=localhost:12346
#		slave
#			kvm -drive file=slave1.qcow2 -vga std -smp cores=4 -cpu host -m 8G -redir tcp:2223::22 -net nic,vlan=1 -net user,vlan=1 -net nic,vlan=2,macaddr=52:54:00:12:34:18 -net socket,vlan=2,connect=localhost:12346
# For each host (one at a time!):
# 	Run script with -i -d name -t user@localhost -p 2222 -u XX -g YY
#	where YY is the XX of the master
# OK to optionally make a new base set of images from master, slave1 and slave2 for backup purposes (so you don't have to redo -i on a mistake)
# For each host (after all done with -i, one at a time!):
#	Run script with -c -m namenodehost -t hduser@localhost -p 2222 -l master,slave1,slave2
#	where localhost -p 2222 corresponds to that node
# For name node only:
# 	Run script with -a -t hduser@localhost -p 2222
#	where localhost -p 2222 corresponds to the nameserver (master)


log_entry updating software and repositories on  ${TARGETHOST}

ssh -t -p ${TARGETPORT} ${TARGETHOST} -C "sudo apt-get -y --force-yes install python-software-properties; sudo add-apt-repository -y ppa:webupd8team/java; sudo apt-get update; "

# configure wired networking
source ${NODECONTROLLER_INSTALL}/lib/net_config_wired.bash



