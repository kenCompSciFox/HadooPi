# Update existing slaves
# this module goes out to all of the existing slaves and updates
# thier hosts files

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
for slavenode in ${NODELIST} do
	IFS=":" read -a nodedata <<< ${slavenode}
	noderole="${nodedata[2]}"
	nodeIP="${nodedata[1]}"
	if [[ ${noderole} -eq "master" ]] then

	# Also update the hdfs-site.xml file to represent the correct number
	# of replications -- This should be the lesser of the number of live nodes
	# or the HADOOP_HDFS_REPLICAS variable
	SSH_COMMAND=""
	SSH_COMMAND=${SSH_COMMAND}"sed -i \"s/<value>*<\/value>/<value>${HADOOP_DFS_REPLICAS}<\/value>/g\" ${HADOOP_CONF_DIR}/${HADOOP_HDFS_SITE_FILE};"

	# set the MASTER_NODE -- how will we know what this is ahead of time
	SSH_COMMAND=${SSH_COMMAND}"sed -i \"s/<value>*<\/value>/<value>${HADOOP_MASTER_NODE}<\/value>/g\" ${HADOOP_CONF_DIR}/${HADOOP_MAPRED_SITE_FILE};"

	SSH ${nodeIP}  ${SSH_COMMAND}

	# push the slaves file to this master server
	SCP ${nodeIP} ${SLAVES_FILE} ${HADOOP_CONF_DIR}"/slaves"

	# push the masters file to this master server
	SCP ${nodeIP} ${MASTERS_FILE} ${HADOOP_CONF_DIR}"/masters"

	# push the authorized_keys file to the slave
	SCP ${CONFIGDIR}"/"${PUBKEYS_FILENAME} ${nodeIP}:/home/${HADOOP_USER}/.ssh/authorized_keys2

	# update the /etc/hosts/file on the slaves
	# TODO make this better - want a way to process the hosts file
	# such that we don't have duplicate entries
	# |sort|uniq >
	SCP hosts ${nodeIP}:/tmp/hosts
	SSH ${nodeIP} -C "cat /tmp/hosts | sudo tee -a /etc/hosts"

done

CONSISTENCY_FLAG=1

