#! /bin/bash -xe

# Install Docker
sudo apt-get update
sudo apt-get install -y docker.io

#Install kubeadm, kubelet and kubectl
sudo apt-get update
sudo apt-get install -y apt-transport-https
sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get install -y kubelet kubeadm kubectl
