#!/bin/bash
# scripts/lib/software_install.bash
# Author: Ken Fox
# December 2013
# version 0.0.0
# Description: Download and install software onto node
# this was broken out so that we can install java and hadoop
# seprately from configuring it -- systems that already have java
# and hadoop installed can (should) skip this step.
#
# Software Install proceedes Identically for Master and slave nodes
# ----------------------------------------------------------------
# install java
# update the java_home variable
# install hadoop
# update the hadoop_env.sh file
# update the bash rc file
# change the ownership of the hadoop directory tree
# move hadoop from the initial location to the final location

retval=0

# java installs differently on differnt host types
if [[ "${NODE_TYPE_CURRENT}" == "RPI" ]] ; then
	# This is a new RPi host

	JAVA_VERSION=${JAVA_VERSION_RPI}
	HADOOP_HEAPSIZE=${HADOOP_HEAPSIZE_RPI}

elif [[ "${NODE_TYPE_CURRENT}" == "QCOW" ]] ; then
	# Qcow install would go here
	JAVA_VERSION=${JAVA_VERSION_QCOW}
	HADOOP_HEAPSIZE=${HADOOP_HEAPSIZE_QCOW}

        #sudo add-apt-repository -y ppa:webupd8team/java;
	#sudo apt-get -y --force-yes install oracle-java8-installer;
	#sudo update-java-alternatives -s java-8-oracle;
	#sudo mkdir /usr/java;
	#sudo chmod 755 /usr/java;
	#sudo ln -s /usr/lib/jvm/java-8-oracle /usr/java/default;

elif [[ "${NODE_TYPE_CURRENT}" == "ENGRIdle" ]] ; then
	# ENGRIdle install of software
	JAVA_VERSION=${JAVA_VERSION_ENGRIdle}
	HADOOP_HEAPSIZE=${HADOOP_HEAPSIZE_ENGRIdle}

       #sudo add-apt-repository -y ppa:webupd8team/java;
	#sudo apt-get -y --force-yes install oracle-java8-installer;
	#sudo update-java-alternatives -s java-8-oracle;
	#sudo mkdir /usr/java;
	#sudo chmod 755 /usr/java;
	#sudo ln -s /usr/lib/jvm/java-8-oracle /usr/java/default;


else
	errmsg="Unsupported node type: "${NODE_TYPE_CURRENT}
	echo ${errmsg}
	log_entry ${errmsg}
	retval=1

fi
if [[ ${retval}" -eq "0" ]] ; then
	# isn't this so much prettier and easier to follow than the massive one liner?
	SSH_COMMAND=""
	# Assuming Debian style repositories and apt-get, install the architecture
	# specific java version
	#TODO determine if we need to have special treatment of JAVA install
	# by host type, in which case we'll need to move this up.
	SSH_COMMAND=${SSH_COMMAND}" sudo apt-get install ${JAVA_VERSION} ;"

	# create the Hadoop install directory, set up permissions, make it the CWD, and download the tarball
	# at some point this should be robustified to handle problems such as the tarball
	# not being available or other connectivity issues - we should abort the process
	# if "something terrible has happened"
	SSH_COMMAND=${SSH_COMMAND}" sudo mkdir ${INSTALL_DIR};"
	SSH_COMMAND=${SSH_COMMAND}" sudo chmod 755 ${INSTALL_DIR};"
	SSH_COMMAND=${SSH_COMMAND}" pushd ${INSTALL_DIR};"
	SSH_COMMAND=${SSH_COMMAND}" sudo wget ${HADOOP_DOWNLOAD};"

	# expand the tarball into the installation directory (typically /opt/hadoop)
	SSH_COMMAND=${SSH_COMMAND}" sudo tar xzf ${HADOOP_TAR};"

	# update the ownership and permissions of the newly created Hadoop installtion
	SSH_COMMAND=${SSH_COMMAND}" sudo chmod 755 ${HADOOP_INSTALL};"
	SSH_COMMAND=${SSH_COMMAND}" sudo chown -R hduser:hadoop ${HADOOP_INSTALL};"

	# notice that we lock the INSTALL and CONF directories down to root ownership
	# but allow users in the HADOOP_GROUP
	SSH_COMMAND=${SSH_COMMAND}" sudo chown root:${HADOOP_GROUP} ${HADOOP_INSTALL};"
	SSH_COMMAND=${SSH_COMMAND}" sudo chown root:${HADOOP_GROUP} ${HADOOP_CONF_DIR};"

	# go back to the base directory and update the config files
	SSH_COMMAND=${SSH_COMMAND}" pushd ${HADOOP_INSTALL};"
	# update the hadoop-env.sh script with environment variables
	SSH_COMMAND=${SSH_COMMAND}" echo export HADOOP_OPTS=-Djava.net.preferIPv4Stack=true >>${HADOOP_CONF_DIR}/hadoop-env.sh;"
	SSH_COMMAND=${SSH_COMMAND}" echo export JAVA_HOME=${JAVA_HOME} >>${HADOOP_CONF_DIR}/hadoop-env.sh;"
	# the heap size gets set because the RPis don;t have a lot of memory, so we have to override this
	SSH_COMMAND=${SSH_COMMAND}" echo export HADOOP_HEAPSIZE=${HADOOP_HEAPSIZE} >>${HADOOP_CONF_DIR}/hadoop-env.sh;"

	# update the user's bash resources file
	SSH_COMMAND=${SSH_COMMAND}" echo export HADOOP_HOME=${HADOOP_INSTALL} >>/home/${HADOOP_USER}/.bashrc;"
	SSH_COMMAND=${SSH_COMMAND}" echo export JAVA_HOME=${JAVA_HOME} >>/home/${HADOOP_USER}/.bashrc;"
	# note that HADOOP_HOME is deprecated but it's still found in many of the shell scripts
	# update both the INSTALL as HOME to be safe -- basically we want to be able to find the various
	# scripts as needed
	SSH_COMMAND=${SSH_COMMAND}" echo 'export PATH=${PATH}:${HADOOP_HOME}/bin' >>/home/${HADOOP_USER}/.bashrc;"
	SSH_COMMAND=${SSH_COMMAND}" echo 'export PATH=${PATH}:${HADOOP_INSTALL}/bin' >>/home/${HADOOP_USER}/.bashrc;"

	SSH_COMMAND=${SSH_COMMAND}" pushd ${HADOOP_INSTALL};"

	# run the hadoop-setup-conf.sh script in automatic mode
	SSH_COMMAND=${SSH_COMMAND}" sudo ./sbin/hadoop-setup-conf.sh"
	# flags, options, and arguments for it:
	SSH_COMMAND=${SSH_COMMAND}" --conf-dir=${HADOOP_CONF_DIR}"
	SSH_COMMAND=${SSH_COMMAND}" --hdfs-user=${HADOOP_USER}"
	SSH_COMMAND=${SSH_COMMAND}" --group=${HADOOP_GROUP}"
	SSH_COMMAND=${SSH_COMMAND}" --mapreduce-user=${HADOOP_USER}"

	# set the location of the Distributed File System
	# We may need to override this for the RPIs
	SSH_COMMAND=${SSH_COMMAND}" --hdfs-dir=/opt/hadoop/hdfs"
	SSH_COMMAND=${SSH_COMMAND}" --namenode-dir=/opt/hadoop/hdfs/namenode"
	SSH_COMMAND=${SSH_COMMAND}" --mapred-dir=/opt/hadoop/mapred"

	# specify distributed procseeing roles,probably just the master node
	SSH_COMMAND=${SSH_COMMAND}" --jobtracker-host=${HADOOP_JOB_TRACKER_NODE}"
	SSH_COMMAND=${SSH_COMMAND}" --namenode-host=${HADOOP_TASK_TRACKER_NODE}"
	SSH_COMMAND=${SSH_COMMAND}" --auto"

  #	ssh -t -p ${TARGETPORT} ${TARGETHOST} -C ${SSH_COMMAND}
	SSH  ${TARGETHOST} ${SSH_COMMAND}

	# copy the XML file temmplates over to the new system
	SCP ${CONFDIR}"/"${HADOOP_CORE_SITE_FILE} ${HADOOP_CONF_DIR}"/"${HADOOP_CORE_SITE_FILE}
	SCP ${CONFDIR}"/"${HADOOP_HDFS_SITE_FILE} ${HADOOP_CONF_DIR}"/"${HADOOP_HDFS_SITE_FILE}
	SCP ${CONFDIR}"/"${HADOOP_MAPRED_SITE_FILE} ${HADOOP_CONF_DIR}"/"${HADOOP_MAPRED_SITE_FILE}

	# The following update MAGIC DUMMY fields in the core-site and mapred-site TEMPLATE files on
	# the Node COntroller - this only works during the install stage.
	# WE need to come up with something more flexible and robust to update live files
	SSH_COMMAND=""
	SSH_COMMAND=${SSH_COMMAND}"sed -i \"s/<value>XXXXXX:PPPPP<\/value>/<value>${HADOOP_MASTER_NODE}:${HADOOP_JOB_TRACKER_WEB_PORT}<\/value>/g\" ${HADOOP_CONF_DIR}/${HADOOP_MAPRED_SITE_FILE};"
	SSH_COMMAND=${SSH_COMMAND}"sed -i \"s/<value>XXXXXX:PPPPP<\/value>/<value>${HADOOP_MASTER_NODE}:${HADOOP_HDFS_WEB_PORT}<\/value>/g\" ${HADOOP_CONF_DIR}/${HADOOP_CORE_SITE_FILE};"
	SSH_COMMAND=${SSH_COMMAND}"sed -i \"s/<value>FFFFFFFFFFFFFFFF<\/value>/<value>${HADOOP_TMP_DIR}<\/value>/g\" ${HADOOP_CONF_DIR}/${HADOOP_CORE_SITE_FILE};"

	SSH  ${TARGETHOST} ${SSH_COMMAND}

fi
