#!/bin/bash
resourceGroup=$1
scaleName=$2
numberOfVms=$3
storageAccount=$4
containerName=$5
databaseAccount=$6 # name of database account
dataBase=$7 # name of actual database
collectionName=$8 # name of actual collection

az vmss create \
  --resource-group $resourceGroup \
  --name $scaleName \
  --image UbuntuLTS \
  --upgrade-policy-mode automatic \
  --admin-username ericazure \
  --generate-ssh-keys \
  --data-disk-sizes-gb 30 30 30 \
  --custom-data ./init-vm.txt \
  --public-ip-address 
  
# scale out by 3 vms
az vmss scale -g $resourceGroup -n $scaleName --new-capacity $numberOfVms

# create storage account
# name of storage account
az storage account create -g $resourceGroup -n $storageAccount

# create storage container
az storage container create -n $containerName --account-name $storageAccount --public-access blob

az cosmosdb create -g $resourceGroup -n $databaseAccount

az cosmosdb database create -g $resourceGroup -n $databaseAccount --db-name $dataBase

az cosmosdb collection create -g $resourceGroup -n $collectionName --name $databaseAccount --db-name $dataBase
