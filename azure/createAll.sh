#! /bin/bash -ex
./create.sh -i Pay-As-You-Go -g my-vnet -l centralus -t templates/vnet.json
./create.sh -i Pay-As-You-Go -g my-jumpbox -l centralus -t templates/jumpbox.json
./create.sh -i Pay-As-You-Go -g my-kubecluster -l centralus -t templates/kubecluster.json
