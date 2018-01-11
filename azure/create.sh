#! /bin/bash
set -euo pipefail
IFS=$'\n\t'

# -e: immediately exit if any command has a non-zero exit status
# -o: prevents errors in a pipeline from being masked
# IFS new value is less likely to cause confusing bugs when looping arrays or arguments (e.g. $@)

usage() { echo "Usage: $0 -i <subscriptionId> -g <resourceGroupName> -l <resourceGroupLocation> -s <stackName>" 1>&2; exit 1; }

declare subscriptionId=""
declare resourceGroupName=""
declare resourceGroupLocation=""
declare stackName=""
declare resource_group_exists=""

# Initialize parameters specified from command line
while getopts ":i:g:n:l:s:" arg; do
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
		s)
			stackName=${OPTARG}
			;;
		esac
done
shift $((OPTIND-1))

#Verify all parameters have been entered
if [ -z "$subscriptionId" ] || [ -z "$resourceGroupName" ] || [ -z "$stackName" ]; then
	echo "Either one of subscriptionId, resourceGroupName, or stackName is empty"
	usage
fi

if [ ! -f "./stacks/$stackName/template.json" ]; then
	echo "$stackName not found"
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

#Exit if any of the following commands return non-zero
set -e

#set the default subscription id
az account set --subscription $subscriptionId


#Check for existing RG
resource_group_exists=$(az group exists --resource-group $resourceGroupName)

if [ "$resource_group_exists" = "false" ]; then
	echo "Resource group with name" $resourceGroupName "could not be found. Creating new resource group.."
	(
		az group create --name $resourceGroupName --location $resourceGroupLocation 1> /dev/null
	)
	else
	echo "Using existing resource group..."
fi

#Start deployment
echo "Starting deployment..."
(
	az group deployment create --resource-group $resourceGroupName --template-file ./stacks/$stackName/template.json 1> /dev/null
)

if [ $?  == 0 ]; then
	echo "Stack has been successfully deployed"
fi

#Generate the Outputs
if [ -f "./stacks/$stackName/include.sh" ]; then
	. ./stacks/$stackName/include.sh
	outputs
fi
