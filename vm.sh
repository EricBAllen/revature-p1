#!/bin/bash
resourceGroup=$1
scaleName=$2
numberOfVms=$3

az vmss create \
  --resource-group $resourceGroup \
  --name $scaleName \
  --image UbuntuLTS \
  --upgrade-policy-mode automatic \
  --admin-username ericazure \
  --generate-ssh-keys \
  --data-disk-sizes-gb 30 30 30 \
  --custom-data ./init-vm.txt 
  

# this will confirm the disks have been prepared correctly
# az vmss list-instance-connection-info \
#   --resource-group myResourceGroup \
#   --name myScaleSet

# create resource group
# az group create -n eric-rg -l southcentralus

# create container

# below, -n = name of container group, --image = the container image name

# az container create -g eric-rg -n allencont --image 

# create storage account

# name of storage account
ericstorage2

# create storage container
az storage container create -n ericscontainer --account-name ericstorage2 --public-access blob


az vmss scale -g $resourceGroup -n $scaleName --new-capacity $numberOfVms 

