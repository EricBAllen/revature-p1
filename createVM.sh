#!/bin/bash



groupName=$1
vmName=$2
diskName=$3
diskDirectory=$4
snapShot=$5
imageName=$6 # The image used to make the new VM
vmImageName=$7 # The new VM



createVM() {
        az vm create -g $groupName -n $vmName --image UbuntuLTS --custom-data ./init.txt --generate-ssh-keys \
        -l southcentralus 
        az vm open-port -g $groupName -n $vmName --port 8080
}
createVM

createDisk() {
       az vm disk attach -g $groupName -n $diskName --vm-name $vmName --size 30 --new
}

createDisk

# check IP of vm
az vm show -g $groupName -n $vmName -d -o table

az vm disk detach -n $diskName -g $groupName --vm-name $vmName


createSnapShot() {
        az snapshot create -g $groupName -n $snapShot --size 30
} 
createSnapShot


az vm deallocate -g $groupName -n $vmName
az vm generalize -g $groupName -n $vmName

# creat image of the VM
createImage() {
        az image create -g $groupName -n $imageName --source $vmName        
}
createImage

# Use image to create a new VM

newVm() {               
        az vm create -g $groupName -n $vmImageName --image $imageName 
}
newVm