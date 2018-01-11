outputs() {
    echo "Kubernetes Cluster Instance IPs"
    az vmss list-instances -g $resourceGroupName -n KubeScaleSet | jq '.[].id' | xargs az vmss nic list-vm-nics -g $resourceGroupName --vmss-name KubeScaleSet --ids | jq -r '.[] | .[] | .ipConfigurations[] | .privateIpAddress'
    echo ""
}