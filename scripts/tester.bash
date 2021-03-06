#!/bin/bash
# scripts/testerr.bash
# tester shell script for the HadooPi project
# Purpose: modularize the confiuration and update of Hadoop Cluster nodes
# at Drexel University
# created by Kenneth Fox, 2013.

# A couple basic settings
# path where this system is installed
NODECONTROLLER_INSTALL="/home/kwf26/CS498/HadooPi/scripts"


# First. Source in the Settings file from the lib directory to pick up all the
# site specific stuff - need to come up with a clean way to specify a different
# settings file such that it get's loaded before any other argumnets get processed
# off the commandline. What we don't want to do is pull arguments off the commandline
# that set variables only to have them overwritten by the defaults if the settings
# file was specified after some other option. This is relevant where we want to have
# a single NodeController manage more than one cluster -- for instance a cluster of
# RPis and a cluster of idling desktop computers or a psuedo-cluster on the Tux Server
# garden (it's not quite a farm).

source ${NODECONTROLLER_INSTALL}/configdata/settings.txt
# load the logging functions
source ${NODECONTROLLER_INSTALL}/lib/logger.bash
# load the utility functions
source ${NODECONTROLLER_INSTALL}/lib/deploy_hadoop_util.bash


# want to write data to a local log file for troubleshooting - this should happen after
# we process the commandline in case we've had a different log file identified, logging has
# been supressed, or we are using the default logfile
echo DEBUG $LOGPATH

set_logfile_name ${LOGPATH}"/tester-"${LOGDATE}".log"
# Write the first log entry.
log_entry tester started


# Next open the configuration file and load all of the data
# -- store in a an array
# -- count the number of nodes
# this block of code should be moved to a function that ignores commented out lines
# when loading data
log_entry loading node configuration data from ${DBFILE}
NODELIST=(`cat "${DBFILE}"`)
# print the file header/layout
log_entry format: ${NODELIST[0]}

# number of nodes - remember to exclude header/format line
NUMNODES=$[ ${#NODELIST[*]} - 1 ]
log_entry Current number of nodes: ${NUMNODES}


#echo $(gen_ipv4_address ${NETOCTET1} ${NETOCTET2} ${GWSUBNET} ${GWNODE})

#echo gateway before $GW
#set_ipv4_gateway 3 4 5 6
#echo gateway after $GW
set_ipv4_gateway ${NETOCTET1} ${NETOCTET2} ${GWSUBNET} ${GWNODE}


#echo netmask before $NETMASK
#set_ipv4_netmask 1 2 3 4
#echo netmask after $NETMASK
set_ipv4_netmask 255 255 255 0


#echo broadcast before $BROADCAST
#set_ipv4_broadcast 5 6 7 8
#echo broadcast after $BROADCAST
set_ipv4_broadcast ${NETOCTET1} ${NETOCTET2} ${SUBNET} 255

#echo node IP before $NODEIP
#set_ipv4_nodeip 9 10 11 12
#echo node IP  after $NODEIP
set_ipv4_nodeip ${NETOCTET1} ${NETOCTET2} ${SUBNET} 61


CURRENTHOST="node-02"
SSH_COMMAND=""
#SSH_COMMAND="pushd /usr/local/hadoop/conf ; ls >> ~/confdirlist2.txt;"

#SSH  hduser@192.168.3.61 ${SSH_COMMAND}

#SCP ${CURRENTHOST} ${SLAVES_FILE} ${HADOOP_CONF_DIR}"/slaves"

#write the data (including header) to the file when done
for node in ${NODELIST[*]}; do
	echo ${node}
	# echo $node > ${DBFILE}
done

# --------------------------
# test the net_config_wired script sourcing
TARGETHOSTNAME=node-02
NODENAME=${CURRENTHOST}
echo   ${TARGETHOSTNAME}/${NODENAME} ${IFACE} $NODEIP $GW $NETMASK $BROADCAST
echo
source ${NODECONTROLLER_INSTALL}/lib/net_config_wired.bash


cat $LOGFILE_NAME
