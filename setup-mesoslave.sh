#!/bin/bash

echo "deploying custom slave configs"
rpm -Uvh http://repos.mesosphere.com/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm
yum -y install mesos
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jre-8u60-linux-x64.rpm
rpm -ivh jre-8u60-linux-x64.rpm
sed  -i '/127.0.1.1/d' /etc/hosts
echo "zk://10.141.141.10:2181/mesos" > /etc/mesos/zk
echo "IP=$1
MASTER=`cat /etc/mesos/zk`" > /etc/default/mesos-slave
yum -y install docker
service docker start
echo 'docker,mesos' | sudo tee /etc/mesos-slave/containerizers
touch /etc/mesos-slave/no-switch_user
systemctl stop mesos-master.service
systemctl disable mesos-master.service
service mesos-slave stop
service mesos-slave start
mkdir -p /data/spark
cd /data/spark
wget http://apache.mirror.anlx.net/spark/spark-1.6.0/spark-1.6.0-bin-hadoop2.6.tgz
chmod 755 *
docker pull jupyter/all-spark-notebook
