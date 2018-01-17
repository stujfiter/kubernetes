#! /bin/bash -xe

#Establish connection to Azure Storage
accessToken="$(curl --silent http://localhost:50342/oauth2/token --data 'resource=https://management.azure.com/' -H Metadata:true | jq -r '.access_token')"
accountKeyUri="https://management.azure.com/subscriptions/$subscriptionId/resourceGroups/$resourceGroup/providers/Microsoft.Storage/storageAccounts/$storageAccountName/listKeys?api-version=2016-12-01"
accountKey="$(curl --silent $accountKeyUri –-request POST -d '' -H \"Authorization: Bearer $accessToken\" | jq -r '.keys[0].value')"
az storage container create --name bootstrap --account-name $storageAccountName --account-key $accountKey

#Upload the Kubernetes cluster token
echo "masterNode=$(ip route get 8.8.8.8 | awk '{print $NF; exit}')" >> /cluster-token.txt
echo "clusterToken=$(sudo kubeadm token list | awk 'NR>1 { print $1 }')" >> /cluster-token.txt
az storage blob upload -c bootstrap -n /cluster-token.txt -f cluster-token.txt --account-name $storageAccounts --account-key $accountKey 