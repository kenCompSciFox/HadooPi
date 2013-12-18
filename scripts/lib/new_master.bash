# New Slave Node
# this module creates a new slave node
# Generate the NODE ID, NAME  and IPADDRESS
NODENAME=node-0${NODENUM}
NODEADDR={${HOSTNODE} plus ${NODENUM}}
IP=${NETOCTET1}.${NETOCTET2}.${SUBNET}.${NODEADDR}


# =========================================
# New Hosts
# put some sort of selector around the host types this is straight forward
# until we hit 10 host types then we need to think about
# objectifying this some more - YALOA - yet another layer of abstraction

# This is a new RPi host, we'll add functionality to handle other types later
# the new RPi host updates the System software and reconfigures the networking
# for a RaspberryPi
source ${NODECONTROLLER_INSTALL}/lib/new_host_RPi.bash

# new Qcow would go here
# source ${NODECONTROLLER_INSTALL}/lib/new_host_QCOW.bash

# new ENGRIdle host would go here
# source ${NODECONTROLLER_INSTALL}/lib/new_host_ENGRIdle.bash

# =========================================



# The remaining functions are common to most other host types.

# Add the hduser and genrate the ssh keys if needed

ssh -t -p ${TARGETPORT} ${TARGETHOST} -C "sudo addgroup ${HADOOP_GROUP}; sudo adduser --disabled-password --ingroup ${HADOOP_GROUP} --gecos '' ${HADOOP_USER}; echo ${HADOOP_USER}:${HADOOP_GROUP} | sudo chpasswd; sudo usermod -a -G sudo ${HADOOP_USER}; echo 'Enter ${HADOOP_USER} password when prompted.'; su ${HADOOP_USER} -c 'mkdir /home/${HADOOP_USER}/.ssh';  su ${HADOOP_USER} -c 'ssh-keygen -t rsa -P \"\" -f /home/${HADOOP_USER}/.ssh/id_rsa'; "




#sudo apt-get -y --force-yes install oracle-java8-installer;
#sudo update-java-alternatives -s java-8-oracle;
#sudo mkdir /usr/java;
#sudo chmod 755 /usr/java;
#sudo ln -s /usr/lib/jvm/java-8-oracle /usr/java/default;



# update the hadoop-env.sh file
#JAVA_HOME=/usr/lib/jvm/java-7-openjdk-armhf
#HADOOP_HEAPSIZE=272



#update the hduser .bashrc file
#export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-armhf
#export HADOOP_INSTALL=/usr/local/hadoop
#export PATH=$PATH:$HADOOP_INSTALL/bin

# working backwards
# update the masters file
# update the slaves file
# update the authorized_hosts file
# update the hosts file

# update the core-site.xml file
scp -P ${SSHPORT} ${TARGETHOST} ${NODECONTROLLER_INSTALL}"/"${CONFIGDIR}"/"${HADOOP_CORE_SITE_FILE} ${HADOOP_CONF_DIR}"/"${HADOOP_CORE_SITE_FILE}

# update the hdfs-site.xml file
scp -P ${SSHPORT} ${TARGETHOST} ${NODECONTROLLER_INSTALL}"/"${CONFIGDIR}"/"${HADOOP_HDFS_SITE_FILE} ${HADOOP_CONF_DIR}"/"${HADOOP_HDFS_SITE_FILE}

# update the mapred_site.xml
scp -P ${SSHPORT} ${TARGETHOST} ${NODECONTROLLER_INSTALL}"/"${CONFIGDIR}"/"${HADOOP_MAPRED_SITE_FILE} ${HADOOP_CONF_DIR}"/"${HADOOP_MAPRED_SITE_FILE}

# move hadoop from the initial location to the final location

# change the ownership of the haddop directory tree
# update the bash rc file
# update the hadoop_env.sh file
# install hadoop
# update the java home variable
# install java
