#!/bin/bash

echo 'INSTALL UTILS'
sudo apt-get -yq update
sudo apt-get -yq install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    jq \
    awscli \
    aufs-tools

echo 'INSTALL DOCKER'
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get -yq update
#sudo apt-get -yq install docker-ce
sudo apt-get -yq install docker.io
sudo usermod -aG docker ubuntu
sudo docker info
sudo systemctl stop docker.service
sudo systemctl disable docker.service

#
# GPU support
#
echo 'INSTALL NVIDIA DRIVERS'
wget -q http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64/cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
sudo dpkg -i cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
rm -f cuda-repo-ubuntu1604_8.0.61-1_amd64.deb
sudo apt-get -yq update
sudo apt-get -yq install --no-install-recommends nvidia-375 nvidia-modprobe libcuda1-375
#sudo apt-get -yq install --no-install-recommends cuda-drivers
echo 'MOVE cuda LIBS NEXT TO nvidia LIBS'
sudo mv -f /usr/lib/x86_64-linux-gnu/libcuda* /usr/lib/nvidia-375/
echo 'MOUNT nvidia-375 TO /usr/lib/nvidia'
sudo mkdir -p /usr/lib/nvidia
echo '/usr/lib/nvidia-375 /usr/lib/nvidia none bind' | sudo tee -a /etc/fstab
sudo mount /usr/lib/nvidia

echo 'CHECK NVIDIA DRIVERS WORKING'
nvidia-smi

echo 'INSTALL KUBERNETES COMPONENTS'
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo 'deb http://apt.kubernetes.io/ kubernetes-xenial main' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get -yq update
sudo apt-get -yq install kubelet kubeadm kubectl kubernetes-cni
sudo systemctl stop kubelet.service
sudo systemctl disable kubelet.service

echo 'DONE'
