#! /bin/bash -ex
publicKeyPath=~/.ssh/azure_nakearl.pub
./create.sh -i Pay-As-You-Go -g my-vnet -l centralus -s vnet
./create.sh -i Pay-As-You-Go -g my-jumpbox -l centralus -s jumpbox -k $publicKeyPath
./create.sh -i Pay-As-You-Go -g my-kubecluster -l centralus -s kubecluster -k $publicKeyPath