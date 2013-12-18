#!/bin/bash
# scripts/lib/update_masters.bash
# Update Master node information
# this module goes out to each of the masters updates thier files
# it is run at the end of processing of the nodecontroller script
# when changes to the system have been made.
# This script could be run from a wrapper other than nodecontroller.bash
# so long as you pick up the settings.txt and source in the support
# functions in the wrapper.

# update the Local copies of the masters and slaves files we want to copy

# write the current contents of the NODELIST where the node's role
# is slave to the local slaves file

log_entry Removing old files: ${SLAVES_FILE} ${MASTERS_FILE}
rm ${SLAVES_FILE} ${MASTERS_FILE}

log_entry creating new masters and slaves files in ${CONFIGDIR}"

for node in ${NODELIST} do
	IFS=":" read -a nodedata <<< ${node}
	nodename="${nodedata[0]}"
	nodeIP="${nodedata[1]}"
	noderole="${nodedata[2]}"

	if [[ ${noderole} -eq "slave" ]] then
	   log_entry ${nodename} - added to slaves file
	   echo ${nodename} >> ${SLAVES_FILE}
	elif [[ ${noderole} -eq "master" ]] then
	   log_entry ${nodename} - added to masters file
	   echo ${nodename} >> ${MASTERS_FILE}
	elif [[ "${node:0:1}" == '#' ]] then
	   log_entry Node Format String: ${node}
	else
	   log_entry ${nodename} - ERROR node entry: \"${node}\"
	   # this should not happen but
	fi
done
log_entry masters and slaves files created successfully



# Set a flag before updating, write it to a file
# the consistency lockfile will be unset at the end of this code.
# the purpose is to indicate that all of update_master.bash file
# ran from beginning to end. if it hasn't then we should have some mechanism
# that causes this code to be re-run. The hazard being that we were interupted
# or SSH/SCP failed such that someting here did not get done.

CONSISTENCY_FLAG=0

# we loop through all of the masters found in the NODELIST
# TODO: push the extraction routines into  functions so
# we can access like master_node.nodetype rather than with
# specific knowledge of file layout scattered all over the place
for masternode in ${NODELIST} do
	IFS=":" read -a nodedata <<< ${masternode}
	noderole="${nodedata[2]}"
	nodeIP="${nodedata[1]}"
	if [[ ${noderole} -eq "master" ]] then

	# Also update the hdfs-site.xml file to represent the correct number
	# of replications -- This should be the lesser of the number of live nodes
	# or the HADOOP_HDFS_REPLICAS variable
	SSH_COMMAND=""
	SSH_COMMAND=${SSH_COMMAND}"sed -i \"s/<value>*<\/value>/<value>${HADOOP_DFS_REPLICAS}<\/value>/g\" ${HADOOP_CONF_DIR}/${HADOOP_HDFS_SITE_FILE};"

	ssh -t -p ${SSHPORT} ${nodeIP} -C ${SSH_COMMAND}

	# push the slaves file to this master server
	scp -P ${SSHPORT} ${SLAVES_FILE} ${nodeIP}":"${HADOOP_CONF_DIR}"/slaves"

	# push the masters file to this master server
	scp -P ${SSHPORT} ${nodeIP} ${MASTERS_FILE} ${HADOOP_CONF_DIR}"/masters"

done

CONSISTENCY_FLAG=1


