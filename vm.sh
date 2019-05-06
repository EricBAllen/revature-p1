#!/bin/bash
resourceGroup=$1
scaleName=$2
numberOfVms=$3
storageAccount=$4
containerName=$5
databaseAccount=$6 # name of database account
dataBase=$7 # name of actual database
collectionName=$8 # name of actual collection

# servers 
#mysql             : Manage Azure Database for MySQL servers.

# possibly use for connecting the app.js to our azure account
#webapp            : Manage web apps.

az vmss create \
  --resource-group $resourceGroup \
  --name $scaleName \
  --image UbuntuLTS \
  --upgrade-policy-mode automatic \
  --admin-username ericazure \
  --generate-ssh-keys \
  --data-disk-sizes-gb 30 30 30 \
  --custom-data ./init-vm.txt \
  # use the public IP address to give each vm the same IP. Then we can make them on separate servers later.
  --public-ip-address 
  
# scale out by 3 vms
az vmss scale -g $resourceGroup -n $scaleName --new-capacity $numberOfVms

# create storage account
# name of storage account
az storage account create -g $resourceGroup -n $storageAccount

# create storage container
az storage container create -n $containerName --account-name $storageAccount --public-access blob

# create a SQL API Cosmos DB account with session consistency and multi-master enabled
az cosmosdb create -g $resourceGroup -n $databaseAccount

az cosmosdb database create -g $resourceGroup -n $databaseAccount --db-name $dataBase

az cosmosdb collection create -g $resourceGroup -n $collectionName --name $databaseAccount --db-name $dataBase

# this will confirm the disks have been prepared correctly
# az vmss list-instance-connection-info \
#   --resource-group myResourceGroup \
#   --name myScaleSet

# create resource group
# az group create -n eric-rg -l southcentralus




postgreSQL = relational # This will relate images to each specific user. Since I'm not doing users, I will do non-relational
# database  # structure, more strict requirements for what we store in our data base tables
noSQL = non relation # not structured and are a lot more flexible in terms of the data they can work with.

# blob is for binary large object