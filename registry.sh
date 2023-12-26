#!/bin/bash

set -x

USER=Zhihao
USER_GROUP=containernetwork
INSTALL_DIR=/home/cloudlab-openwhisk
HOST_ETH0_IP=$(ifconfig eth1 | awk 'NR==2{print $2}')
HOST_NAME=$(hostname | awk 'BEGIN{FS="."}{print $1}')

sudo mkdir -p /var/lib/registry
sudo nerdctl run -d -p 35000:5000 -v /var/lib/registry:/var/lib/registry --restart=always --name registry registry:2

sudo nerdctl pull -q qi0523/action-dotnet-v3.1:obd
sudo nerdctl tag qi0523/action-dotnet-v3.1:obd $HOST_ETH0_IP:35000/openwhisk/action-dotnet-v3.1:obd
sudo nerdctl --insecure-registry=true push $HOST_ETH0_IP:35000/openwhisk/action-dotnet-v3.1:obd
sudo nerdctl rmi $HOST_ETH0_IP:35000/openwhisk/action-dotnet-v3.1:obd
sudo nerdctl rmi qi0523/action-dotnet-v3.1:obd

sudo nerdctl pull -q qi0523/action-nodejs-v10:obd
sudo nerdctl tag qi0523/action-nodejs-v10:obd $HOST_ETH0_IP:35000/openwhisk/action-nodejs-v10:obd
sudo nerdctl --insecure-registry=true push $HOST_ETH0_IP:35000/openwhisk/action-nodejs-v10:obd
sudo nerdctl rmi $HOST_ETH0_IP:35000/openwhisk/action-nodejs-v10:obd
sudo nerdctl rmi qi0523/action-nodejs-v10:obd

sudo nerdctl pull -q qi0523/action-nodejs-v12:obd
sudo nerdctl tag qi0523/action-nodejs-v12:obd $HOST_ETH0_IP:35000/openwhisk/action-nodejs-v12:obd
sudo nerdctl --insecure-registry=true push $HOST_ETH0_IP:35000/openwhisk/action-nodejs-v12:obd
sudo nerdctl rmi $HOST_ETH0_IP:35000/openwhisk/action-nodejs-v12:obd
sudo nerdctl rmi qi0523/action-nodejs-v12:obd

sudo nerdctl pull -q qi0523/action-nodejs-v14:obd
sudo nerdctl tag qi0523/action-nodejs-v14:obd $HOST_ETH0_IP:35000/openwhisk/action-nodejs-v14:obd
sudo nerdctl --insecure-registry=true push $HOST_ETH0_IP:35000/openwhisk/action-nodejs-v14:obd
sudo nerdctl rmi $HOST_ETH0_IP:35000/openwhisk/action-nodejs-v14:obd
sudo nerdctl rmi qi0523/action-nodejs-v14:obd

sudo nerdctl pull -q qi0523/action-python-v3.9:obd
sudo nerdctl tag qi0523/action-python-v3.9:obd $HOST_ETH0_IP:35000/openwhisk/action-python-v3.9:obd
sudo nerdctl --insecure-registry=true push $HOST_ETH0_IP:35000/openwhisk/action-python-v3.9:obd
sudo nerdctl rmi $HOST_ETH0_IP:35000/openwhisk/action-python-v3.9:obd
sudo nerdctl rmi qi0523/action-python-v3.9:obd

sudo nerdctl pull -q qi0523/action-php-v7.4:obd
sudo nerdctl tag qi0523/action-php-v7.4:obd $HOST_ETH0_IP:35000/openwhisk/action-php-v7.4:obd
sudo nerdctl --insecure-registry=true push $HOST_ETH0_IP:35000/openwhisk/action-php-v7.4:obd
sudo nerdctl rmi $HOST_ETH0_IP:35000/openwhisk/action-php-v7.4:obd
sudo nerdctl rmi qi0523/action-php-v7.4:obd

sudo nerdctl pull -q qi0523/action-swift-v4.2:obd
sudo nerdctl tag qi0523/action-swift-v4.2:obd $HOST_ETH0_IP:35000/openwhisk/action-swift-v4.2:obd
sudo nerdctl --insecure-registry=true push $HOST_ETH0_IP:35000/openwhisk/action-swift-v4.2:obd
sudo nerdctl rmi $HOST_ETH0_IP:35000/openwhisk/action-swift-v4.2:obd
sudo nerdctl rmi qi0523/action-swift-v4.2:obd

sudo nerdctl pull -q qi0523/python2action:obd
sudo nerdctl tag qi0523/python2action:obd $HOST_ETH0_IP:35000/openwhisk/python2action:obd
sudo nerdctl --insecure-registry=true push $HOST_ETH0_IP:35000/openwhisk/python2action:obd
sudo nerdctl rmi $HOST_ETH0_IP:35000/openwhisk/python2action:obd
sudo nerdctl rmi qi0523/python2action:obd

sudo nerdctl pull -q qi0523/java8action:obd
sudo nerdctl tag qi0523/java8action:obd $HOST_ETH0_IP:35000/openwhisk/java8action:obd
sudo nerdctl --insecure-registry=true push $HOST_ETH0_IP:35000/openwhisk/java8action:obd
sudo nerdctl rmi $HOST_ETH0_IP:35000/openwhisk/java8action:obd
sudo nerdctl rmi qi0523/java8action:obd

# sudo wondershaper -a eth0 -d $1 -u $1
