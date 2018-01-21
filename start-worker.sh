#! /bin/bash -x

netcat -l 5100 & netcat -l 5101 > cluster-token.txt
. cluster-token.txt
sudo kubeadm join --token $clusterToken --discovery-token-unsafe-skip-ca-verification $masterIp:6443