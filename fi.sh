#!/bin/bash

set -x

USER=Zhihao
USER_GROUP=containernetwork
MASTER_PORT=3000
INVOKER_PORT=3001
INSTALL_DIR=/home/cloudlab-openwhisk
HOST_ETH0_IP=$(ifconfig eth0 | awk 'NR==2{print $2}')
HOST_NAME=$(hostname | awk 'BEGIN{FS="."}{print $1}')

# change hostname
sudo hostnamectl set-hostname $HOST_NAME
sudo sed -i "4a 127.0.0.1 $HOST_NAME" /etc/hosts

## modify containerd, TODO:
sudo apt update
sudo apt install -y apparmor apparmor-utils
## cni plugins TODO:
pushd $INSTALL_DIR/install
# sudo wget https://github.com/containernetworking/plugins/releases/download/v1.1.1/cni-plugins-linux-amd64-v1.1.1.tgz
sudo tar Cxzvf /opt/cni/bin cni-plugins-linux-amd64-v1.1.1.tgz
popd

## memory.memsw
# sudo sed -i 's/GRUB_CMDLINE_LINUX="/GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1,/' /etc/default/grub
# sudo update-grub

## modify containerd
configure_docker_storage() {
    printf "%s: %s\n" "$(date +"%T.%N")" "Configuring containerd storage"
    sudo mkdir -p /mydata/var/lib/containerd
    sudo sed -i 's#root = "/var/lib/containerd"#root = "/mydata/var/lib/containerd"#g' /etc/containerd/config.toml
    sudo systemctl restart containerd || (echo "ERROR: containerd installation failed, exiting." && exit -1)
    printf "%s: %s\n" "$(date +"%T.%N")" "Configured containerd storage to use mountpoint"
}

disable_swap() {
    # Turn swap off and comment out swap line in /etc/fstab
    sudo swapoff -a
    if [ $? -eq 0 ]; then   
        printf "%s: %s\n" "$(date +"%T.%N")" "Turned off swap"
    else
        echo "***Error: Failed to turn off swap, which is necessary for Kubernetes"
        exit -1
    fi
    sudo sed -i 's/UUID=.*swap/# &/' /etc/fstab
}


set_ip_to_master_py(){
    sudo python /local/repository/client.py $1 $HOST_ETH0_IP
}

wait_join_k8s() {
    sudo kubeadm join 172.17.65.1:6443 --token mnervw.4wbmglaz0r9e1ege \
	--discovery-token-ca-cert-hash sha256:4f02471b0103277c50033c090e5c8a2cc9996b3b498716e165caa29afbf6e6c7 
}

setup_invoker() {
    # $1 == master ip
    #1. send host ip to master.
    # set_ip_to_master_py $1
    #2. wait to join in k8s cluster.
    wait_join_k8s

    #3. nfs-common
    sudo apt-get update
    sudo apt install nfs-common -y
}

# Start by recording the arguments
printf "%s: args=(" "$(date +"%T.%N")"
for var in "$@"
do
    printf "'%s' " "$var"
done
printf ")\n"

# Kubernetes does not support swap, so we must disable it
disable_swap

# Use mountpoint (if it exists) to set up additional docker image storage
if test -d "/mydata"; then
    configure_docker_storage
fi

# Use second argument (node IP) to replace filler in kubeadm configuration
sudo sed -i "s/REPLACE_ME_WITH_IP/$HOST_ETH0_IP/g" /etc/systemd/system/kubelet.service.d/10-kubeadm.conf


# listen INVOKER_PORT

# coproc nc { nc -l $HOST_ETH0_IP $INVOKER_PORT; }

setup_invoker $1

# sudo wondershaper -a eth0 -d $2 -u $2

# sudo agent 30000 &

# sudo sed -i "s/4294967296/$4/" $INSTALL_DIR/install/dadip2p.yaml

sudo p2p -c $INSTALL_DIR/install/dadip2p.yaml &

sleep 3

sudo systemctl restart overlaybd-tcmu

sudo sed -i "s/MASTERIP/$1/" /etc/overlaybd-snapshotter/config.json

sudo systemctl restart overlaybd-snapshotter

sudo nerdctl run -d -p 35000:5000 -v /proj/containernetwork-PG0/registry:/var/lib/registry --restart=always --name registry registry

exit 0
