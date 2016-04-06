#!/bin/bash

echo "deploying custom master configs"
rpm -Uvh http://repos.mesosphere.com/el/7/noarch/RPMS/mesosphere-el-repo-7-1.noarch.rpm
yum -y install mesos marathon
yum -y install mesosphere-zookeeper
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u60-b27/jre-8u60-linux-x64.rpm
rpm -ivh jre-8u60-linux-x64.rpm
yum -y install haproxy
sed  -i '/127.0.1.1/d' /etc/hosts
echo "10" > /var/lib/zookeeper/myid
cp /vagrant/zookeeper/zoo.cfg /etc/zookeeper/conf/zoo.cfg
cp /vagrant/zookeeper/zk /etc/mesos/zk
echo "1" > /etc/mesos-master/quorum

echo "IP=$1
PORT=5050
ZK=`cat /etc/mesos/zk`" > /etc/default/mesos-master

systemctl restart zookeeper.service
systemctl stop mesos-slave.service
systemctl disable mesos-slave.service

service mesos-master stop
service marathon restart
service mesos-master start
