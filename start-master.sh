#! /bin/bash -xe

#Initialize Master
kubeadm init
mkdir -p /home/kearl/.kube
cp -i /etc/kubernetes/admin.conf /home/kearl/.kube/config
chown kearl:kearl /home/kearl/.kube/config
runuser -l kearl -c 'kubectl apply -f /kubernetes/kube-flannel.yml'

#Send message to all worker nodes listening on port 5100
apt-get install -y nmap
nmap -Pn -p5100 --open 10.0.0.0/24 | grep "10.0.0" | awk '{ print $5 }' | xargs -I '$' sh -c 'echo "Hello Worker Node" | nc -w1 $ 5101'