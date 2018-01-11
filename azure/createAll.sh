#! /bin/bash -ex
./create.sh -i Pay-As-You-Go -g my-vnet -l centralus -s vnet
./create.sh -i Pay-As-You-Go -g my-jumpbox -l centralus -s jumpbox
./create.sh -i Pay-As-You-Go -g my-kubecluster -l centralus -s kubecluster