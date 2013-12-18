#!/bin/bash
# scripts/nodecontroller.bash
# Master shell script for the HadooPi project
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


# process the commandline arguments to figure out what we are going to be doing
# first items in list are present/not present switches
# items with optarg have arguments
# compound args aren't trivially supported

while getopts "c:l:p:h" opt; do
	case "$opt" in


     	c)
		DCONFIGURE=1
		;;
	l)
		LOGFILENAME=$OPTARG
		;;
	p)
		LOGFILEPATH=$OPTARG
		;;

	h)
		echo -c host: Install and configure hadoop
		echo -l logfilename: use this logfile
		echo -p logpath: override path to log files
		echo -d name: Specify when installing the child node to be called name
		echo -h: Help
		exit
		;;
	esac
done




# want to write data to a local log file for troubleshooting - this should happen after
# we process the commandline in case we've had a different log file identified, logging has
# been supressed, or we are using the default logfile
echo DEBUG $LOGPATH
#echo DEBUG log file path "${LOGFILEPATH}"
#if [ -n ${LOGFILEPATH}]
#then
	# overwrite the default log path from settings.txt
#	LOGPATH=${LOGFILEPATH}
#	echo logpath: $LOGPATH
#fi
if [ -n "${LOGFILENAME}" ]
then
	# Make the complete logfile name if necessary
	LOGFILE_NAME=${LOGPATH}/${LOGFILENAME}
else
	default_logfile
fi
#  echo DEBUG ${LOGFILE_NAME}
# Write the first log entry.
log_entry NodeController started


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


# ===================================================================
# Determine what we are doing



# if we are adding a node, we need to append or insert it into the file assuming it
# was successfully created
# add node to array
# thisnode="node03:192.168.3.62:slave"
# log_entry new node "${thisnode}" added
# data[3]="${thisnode}"




#write the data (including header) to the file when done
for node in ${NODELIST[*]}; do
	echo ${node}
	# echo $node > ${DBFILE}
done
