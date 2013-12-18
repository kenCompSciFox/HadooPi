# New Slave Node
# this module creates a new slave node


# =========================================
# New Hosts
# straight forward until we hit 10 host types then we need to think about
# objectifying this some more - YALOA - yet another layer of abstraction

if [[ "${NODE_TYPE_CURRENT}" == "RPI" ]]
then
	# This is a new RPi host, we'll add functionality to handle other types later
	# the new RPi host updates the System software and reconfigures the networking
	# for a RaspberryPi
	source ${NODECONTROLLER_INSTALL}/lib/new_host_RPi.bash
elif [[ "${NODE_TYPE_CURRENT}" == "QCOW" ]]
then
	# new Qcow would go here
	# source ${NODECONTROLLER_INSTALL}/lib/new_host_QCOW.bash
elif [[ "${NODE_TYPE_CURRENT}" == "ENGRIdle" ]]
then
	# new ENGRIdle host would go here
	# source ${NODECONTROLLER_INSTALL}/lib/new_host_ENGRIdle.bash
else
	errmsg="Unsupported node type: "${NODE_TYPE_CURRENT}
	echo ${errmsg}
	log_entry ${errmsg}

fi
# =========================================

# The remaining functions are common to most other host types.

# Add the hduser and genrate the ssh keys
SSH_COMMAND=""
# create a hadoop group
SSH_COMMAND=${SSH_COMMAND}" sudo addgroup ${HADOOP_GROUP};"

# create the hduser and screw up its password
SSH_COMMAND=${SSH_COMMAND}" sudo adduser --disabled-password --ingroup ${HADOOP_GROUP} --gecos '' ${HADOOP_USER};"
SSH_COMMAND=${SSH_COMMAND}" echo ${HADOOP_USER}:${HADOOP_GROUP} | sudo chpasswd;"

# give the hadoop user the ability to sudo
SSH_COMMAND=${SSH_COMMAND}" sudo usermod -a -G sudo ${HADOOP_USER};"

# create thw .ssh directory fir the HADOOP_USER and generate the ssh keys
SSH_COMMAND=${SSH_COMMAND}" su ${HADOOP_USER} -c 'mkdir /home/${HADOOP_USER}/.ssh';"

# the \"\" provides a null previous passphrase to keygen.
SSH_COMMAND=${SSH_COMMAND}" su ${HADOOP_USER} -c 'ssh-keygen -t rsa -P \"\" -f /home/${HADOOP_USER}/.ssh/id_rsa'; "

SSH ${TARGETHOST} ${SSH_COMMAND}

# get a copy of the public key for the host and store it locally
SSH ${TARGETHOST} 'cat /home/hduser/.ssh/id_rsa.pub' >> ${CONFIGDIR}"/"${PUBKEYS_FILENAME}

# Install and configure java and hadoop on target Node
source ${NODECONTROLLER_INSTALL}/lib/software_install.bash

# update the core-site.xml file
SCP ${TARGETHOST} ${CONFIGDIR}"/"${HADOOP_CORE_SITE_FILE} ${HADOOP_CONF_DIR}"/"${HADOOP_CORE_SITE_FILE}

# update the hdfs-site.xml file
SCP ${TARGETHOST} ${CONFIGDIR}"/"${HADOOP_HDFS_SITE_FILE} ${HADOOP_CONF_DIR}"/"${HADOOP_HDFS_SITE_FILE}

# update the mapred_site.xml
SCP ${TARGETHOST} ${CONFIGDIR}"/"${HADOOP_MAPRED_SITE_FILE} ${HADOOP_CONF_DIR}"/"${HADOOP_MAPRED_SITE_FILE}

