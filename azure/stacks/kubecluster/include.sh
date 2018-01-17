cloudInitData() {
    echo etcdDiscoveryTokenUri="$(curl --silent https://discovery.etcd.io/new\?size\=3)"
}

outputs() {
    echo "Kubernetes Master IP"
    az network nic show -g $resourceGroupName -n kube-master-nic | jq -r '.ipConfigurations[0].privateIpAddress'
    echo "Kubernetes Cluster Instance IPs"
    az vmss list-instances -g $resourceGroupName -n KubeScaleSet | jq '.[].id' | xargs az vmss nic list-vm-nics -g $resourceGroupName --vmss-name KubeScaleSet --ids | jq -r '.[] | .[] | .ipConfigurations[] | .privateIpAddress'
}