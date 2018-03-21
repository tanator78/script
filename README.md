#!/bin/bash

echo "Veuillez saisir l'adresse Ip du Proxy"
read $proxy
echo "Veuillez saisir le port du Proxy"
read $port
PROXY_URL='$proxy'
PROXY_PORT='$port'

echo "proxy=http://$PROXY_URL:$PROXY_PORT" >> /etc/yum.conf
export http_proxy=http://$PROXY_URL:$PROXY_PORT
export https_proxy=https://$PROXY_URL:$PROXY_PORT
yum -y update
setenforce 0 
systemctl stop firewalld 
systemctl disable firewalld 
yum -y install https://rdoproject.org/repos/rdo-release.rpm 
yum -y install centos-release-openstack-mitaka
yum -y update 
yum -y install openstack-packstack
systemctl stop NetworkManager
systemctl disable NetworkManager

#packstack --answer-file= <EOF a completer .....
