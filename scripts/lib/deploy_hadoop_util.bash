#!/bin/bash
# scripts/lib/deploy_hadoop_util.bash
# Author: Ken Fox
# December 2013
# version 0.0.0
# Description: various function definitions common to deployment
# script modules such as computing the next node number or splitting
# an IP Address
#
# organization to be added at a later date
# ----------------------------------------------------------------

# Needs error checking
# facade for secure copy
# assumes current user has passwordless permission to access
# destination host
# actually, just specify a user@host combination for HOST
# adds logging, simplifies innvocation, supplies consistency
function SCP {
	HOST=$1
	SOURCE=$2
	DEST=$3
	log_entry copying from ${SOURCE} to ${HOST}":"${DEST}
	scp -P ${SSHPORT} ${SOURCE} ${HOST}":"${DEST}
	retval=$?
	return ${retval}
}

# Needs error checking
# facade for Secure Shell
#adds logging, simplifies innvocation, supplies consistency

function SSH {
	HOST=$1
	CMD=$2
	log_entry Executing command ${CMD} on ${HOST}
	ssh -t -p ${SSHPORT} ${HOST} -C ${CMD}
	retval=$?
	return ${retval}
}

#makes a valid IPV4 address from four octets
#TODO filter for non nummeric
#TODO ensure each octet 0 < OCTET < 255
# produces output to be caputured by caller
function gen_ipv4_address {
	addr=""
	rv=0
	if [[ "${#@}" -lt 4 ]]
	then
		## not enough Args
		rv=1
	else
		A=$1
		B=$2
		C=$3
		D=$4
		addr=${A}"."${B}"."${C}"."${D}
	fi
	echo ${addr}
	return ${rv}
}

# set specific variables
function set_ipv4_gateway {
	TMP=$(gen_ipv4_address $@)
	retval=$?
	if [[ "$retval" -gt "0" ]]
	then
		log_entry ERROR gateway address specification error \("${retval}"\) args: "${@}"
	else
		log_entry Changing gateway from ${GW} to ${TMP}
		GW=${TMP}
	fi
}

function set_ipv4_netmask {
	TMP=$(gen_ipv4_address $@)
	retval=$?
	if [[ "$retval" -gt "0" ]]
	then
		log_entry ERROR netmask specification error \("${retval}"\) args: "${@}"
	else
		log_entry Changing netmask from ${NETMASK} to ${TMP}
		NETMASK=${TMP}
	fi
}

function set_ipv4_broadcast {
	TMP=$(gen_ipv4_address $@)
	retval=$?
	if [[ "$retval" -gt "0" ]]
	then
		log_entry ERROR broadcast address specification error \("${retval}"\) args: "${@}"
	else
		log_entry Changing broadcast from ${BROADCAST} to ${TMP}
		BROADCAST=${BROADCAST}
	fi
}

function set_ipv4_nodeip {
	TMP=$(gen_ipv4_address $@)
	retval=$?
	if [[ "$retval" -gt "0" ]]
	then
		log_entry ERROR NODE IP address specification error \("${retval}"\) args: "${@}"
	else
		log_entry Changing NODE IP from ${NODEIP} to ${TMP}
		NODEIP=${TMP}
	fi
}

# TODO TEST THIS
# Need to allow for different HADOOP_SBIN_DIR at some point
# for now we'll assume they're all the same
# might want to expand this to include arguments

function hdfs_format {
	SSH_COMMAND="sudo ${HADOOP_SBIN_DIR}/hadoop-setup-hdfs.sh --format --hdfs-user=${HADOOP_USER} --mapreduce-user=${HADOOP_USER}"

	ssh -t -p ${SSHPORT} ${HADOOP_MASTER_NODE} -C ${SSH_COMMAND}

	SSH_COMMAND=""

}



echo "deploy_hadoop_util.bash loaded"
