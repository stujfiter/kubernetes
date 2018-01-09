#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)

usage() { echo "Usage: $0 -i <subscriptionId> -g <resourceGroupName> -l <resourceGroupLocation> -t <templateFilePath>" 1>&2; exit 1; }

declare subscriptionId=""
declare resourceGroupName=""
declare resourceGroupLocation=""
declare templateFilePath=""

# Initialize parameters specified from command line
while getopts ":i:g:n:l:t:" arg; do
	case "${arg}" in
		i)
			subscriptionId=${OPTARG}
			;;
		g)
			resourceGroupName=${OPTARG}
			;;
		l)
			resourceGroupLocation=${OPTARG}
			;;
		t)
			templateFilePath=${OPTARG}
			;;
		esac
done
shift $((OPTIND-1))

#Verify all parameters have been entered
if [ -z "$subscriptionId" ] || [ -z "$resourceGroupName" ] || [ -z "$templateFilePath" ]; then
	echo "Either one of subscriptionId, resourceGroupName, or templateFilePath is empty"
	usage
fi

if [ ! -f "$templateFilePath" ]; then
	echo "$templateFilePath not found"
	exit 1
fi

#Do not exit if the following commands return non-zero
set +e

#login to azure using your credentials
az account show 1> /dev/null

if [ $? != 0 ];
then
	az login
fi

#set the default subscription id
az account set --subscription $subscriptionId


#Check for existing RG
az group show $resourceGroupName 1> /dev/null

if [ $? != 0 ]; then
	echo "Resource group with name" $resourceGroupName "could not be found. Creating new resource group.."
	set -e
	(
		set -x
		az group create --name $resourceGroupName --location $resourceGroupLocation 1> /dev/null
	)
	else
	echo "Using existing resource group..."
fi

#Start deployment
echo "Starting deployment..."
(
	set -x
	az group deployment create --resource-group $resourceGroupName --template-file $templateFilePath
)

if [ $?  == 0 ];
 then
	echo "Template has been successfully deployed"
fi
