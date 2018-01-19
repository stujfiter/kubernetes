outputs() {
    echo "Jumpbox IpAddress"
    az network public-ip list -g $resourceGroupName | jq -r '.[] | .ipAddress'
}

setParams() {
    params="key_data=\"$(cat $publicKeyPath)\""
}