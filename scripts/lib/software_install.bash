#!/bin/bash
# scripts/lib/software_install.bash
# Author: Ken Fox
# December 2013
# version 0.0.0
# Description: Download and install software onto node
# this was broken out so that we can install java and hadoop
# seprately from configuring it -- systems that already have java
# and hadoop installed can (should) skip this step.
# ----------------------------------------------------------------
# install java
# update the java_home variable
# install hadoop
# update the hadoop_env.sh file
# update the bash rc file
# change the ownership of the hadoop directory tree
# move hadoop from the initial location to the final location


# java installs different;ly on differnt host types
if [[ "${NODE_TYPE_CURRENT}" == "RPI" ]]
then
	# This is a new RPi host

	JAVA_VERSION=${JAVA_VERSION_RPI}

	ssh -t -p ${TARGETPORT} ${TARGETHOST} -C "sudo apt-get install ${JAVA_VERSION} ; sudo mkdir ${INSTALL_DIR}; sudo chmod 755 ${INSTALL_DIR}; pushd ${INSTALL_DIR}; sudo wget ${HADOOP_DOWNLOAD}; sudo tar xzf ${HADOOP_TAR}; sudo chmod 755 ${HADOOP_INSTALL}; sudo chown -R hduser:hadoop ${HADOOP_INSTALL}; sudo chown root:hadoop ${HADOOP_INSTALL}; sudo chown root:hadoop ${HADOOP_CONF_DIR}; pushd ${HADOOP_INSTALL}; echo export HADOOP_OPTS=-Djava.net.preferIPv4Stack=true >>${HADOOP_CONF_DIR}/hadoop-env.sh; echo export HADOOP_HOME=${HADOOP_INSTALL} >>/home/${HADOOP_USER}/.bashrc; echo export JAVA_HOME=${JAVA_HOME} >>/home/${HADOOP_USER}/.bashrc; echo 'export PATH=${PATH}:${HADOOP_HOME}/bin' >>/home/${HADOOP_USER}/.bashrc; echo 'export PATH=${PATH}:${HADOOP_INSTALL}/bin' >>/home/${HADOOP_USER}/.bashrc; pushd ${HADOOP_INSTALL}; sudo ./sbin/hadoop-setup-conf.sh --conf-dir=${HADOOP_CONF_DIR} --hdfs-user=${HADOOP_USER} --group=${HADOOP_GROUP} --mapreduce-user=${HADOOP_USER} --hdfs-dir=/opt/hadoop/hdfs --namenode-dir=/opt/hadoop/hdfs/namenode 	--mapred-dir=/opt/hadoop/mapred --jobtracker-host=${HADOOP_MASTER_NODE} --namenode-host=${HADOOP_MASTER_NODE} --auto"


elif [[ "${NODE_TYPE_CURRENT}" == "QCOW" ]]
then
	# Qcow install would go here
        #sudo add-apt-repository -y ppa:webupd8team/java;
	#sudo apt-get -y --force-yes install oracle-java8-installer;
	#sudo update-java-alternatives -s java-8-oracle;
	#sudo mkdir /usr/java;
	#sudo chmod 755 /usr/java;
	#sudo ln -s /usr/lib/jvm/java-8-oracle /usr/java/default;

	JAVA_VERSION=${JAVA_VERSION_QCOW}

elif [[ "${NODE_TYPE_CURRENT}" == "ENGRIdle" ]]
then
	# ENGRIdle install of software
        #sudo add-apt-repository -y ppa:webupd8team/java;
	#sudo apt-get -y --force-yes install oracle-java8-installer;
	#sudo update-java-alternatives -s java-8-oracle;
	#sudo mkdir /usr/java;
	#sudo chmod 755 /usr/java;
	#sudo ln -s /usr/lib/jvm/java-8-oracle /usr/java/default;

	JAVA_VERSION=${JAVA_VERSION_ENGRIdle}
else
	errmsg="Unsupported node type: "${NODE_TYPE_CURRENT}
	echo ${errmsg}
	log_entry ${errmsg}

fi
	SSH_COMMAND=""
	SSH_COMMAND=${SSH_COMMAND}" sudo apt-get install ${JAVA_VERSION} ;"
	SSH_COMMAND=${SSH_COMMAND}" sudo mkdir ${INSTALL_DIR};"
	SSH_COMMAND=${SSH_COMMAND}" sudo chmod 755 ${INSTALL_DIR};"
	SSH_COMMAND=${SSH_COMMAND}" pushd ${INSTALL_DIR};"

	SSH_COMMAND=${SSH_COMMAND}" sudo wget ${HADOOP_DOWNLOAD};"

	SSH_COMMAND=${SSH_COMMAND}" sudo tar xzf ${HADOOP_TAR};"
	SSH_COMMAND=${SSH_COMMAND}" sudo chmod 755 ${HADOOP_INSTALL};"
	SSH_COMMAND=${SSH_COMMAND}" sudo chown -R hduser:hadoop ${HADOOP_INSTALL};"
	SSH_COMMAND=${SSH_COMMAND}" sudo chown root:hadoop ${HADOOP_INSTALL};"
	SSH_COMMAND=${SSH_COMMAND}" sudo chown root:hadoop ${HADOOP_CONF_DIR};"
	SSH_COMMAND=${SSH_COMMAND}" pushd ${HADOOP_INSTALL};"
	SSH_COMMAND=${SSH_COMMAND}" echo export HADOOP_OPTS=-Djava.net.preferIPv4Stack=true >>${HADOOP_CONF_DIR}/hadoop-env.sh;"
	SSH_COMMAND=${SSH_COMMAND}" echo export HADOOP_HOME=${HADOOP_INSTALL} >>/home/${HADOOP_USER}/.bashrc;"
	SSH_COMMAND=${SSH_COMMAND}" echo export JAVA_HOME=${JAVA_HOME} >>/home/${HADOOP_USER}/.bashrc;"
	SSH_COMMAND=${SSH_COMMAND}" echo 'export PATH=${PATH}:${HADOOP_HOME}/bin' >>/home/${HADOOP_USER}/.bashrc;"
	SSH_COMMAND=${SSH_COMMAND}" echo 'export PATH=${PATH}:${HADOOP_INSTALL}/bin' >>/home/${HADOOP_USER}/.bashrc;"

	SSH_COMMAND=${SSH_COMMAND}" pushd ${HADOOP_INSTALL};"
	SSH_COMMAND=${SSH_COMMAND}" sudo ./sbin/hadoop-setup-conf.sh"
	SSH_COMMAND=${SSH_COMMAND}" --conf-dir=${HADOOP_CONF_DIR}"
	SSH_COMMAND=${SSH_COMMAND}" --hdfs-user=${HADOOP_USER}"
	SSH_COMMAND=${SSH_COMMAND}" --group=${HADOOP_GROUP}"
	SSH_COMMAND=${SSH_COMMAND}" --mapreduce-user=${HADOOP_USER}"
	SSH_COMMAND=${SSH_COMMAND}" --hdfs-dir=/opt/hadoop/hdfs"
	SSH_COMMAND=${SSH_COMMAND}" --namenode-dir=/opt/hadoop/hdfs/namenode"
	SSH_COMMAND=${SSH_COMMAND}" --mapred-dir=/opt/hadoop/mapred"
	SSH_COMMAND=${SSH_COMMAND}" --jobtracker-host=${HADOOP_MASTER_NODE}"
	SSH_COMMAND=${SSH_COMMAND}" --namenode-host=${HADOOP_MASTER_NODE}"
	SSH_COMMAND=${SSH_COMMAND}" --auto"

# 	ssh -t -p ${TARGETPORT} ${TARGETHOST} -C ${SSH_COMMAND}


