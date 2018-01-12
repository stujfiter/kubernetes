#! /bin/bash -xe

#Initialize Master
kubeadm init
mkdir -p /home/kearl/.kube
cp -i /etc/kubernetes/admin.conf /home/kearl/.kube/config
chown kearl:kearl /home/kearl/.kube/config
su - kubectl apply -f kube-flannel.yml
