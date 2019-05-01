#!/bin/bash
# Create VM


groupName=$1
vmName=$2
diskName=$3
diskDirectory=$4
snapShot=$5
imageName=$6
vmImageName=$7

$command 

./createVM.sh 

createVM() {
        az vm create -g $groupName -n $vmName --image UbuntuLTS --custom-data ./init.txt --generate-ssh-keys \
        -l southcentralus
        az vm open-port -g $groupName -n $vmName --port 8080
}
createVM

# by defining separate varibles for the funtion below, we can use different group names while creating a disk.

createDisk() {
       az vm disk attach -g $groupName -n $diskName --vm-name $vmName --size 30 --new
}

createDisk


# check IP of vm
az vm show -g $groupName -n $vmName -d -o table

# make directory for the mounted disk

az vm disk detach -n $diskName -g groupName --vm-name $vmName
sudo mkfs -t ext4 /dev/sdc
sudo mkdir /media/$diskDirectory
sudo mount /dev/sdc /media/$diskDirectory
sudo mv server.js /media/$diskDirectory


createSnapShot() {
        az snapshot create -g $groupName -n $snapShot --size 30
} 
createSnapShot # call function

## ..............................................................THE ABOVE CODE WORKS!!!..................................................

 #below all need to be inside cloudconfig below the runcm 
sudo unmount /media/$diskDirectory # unmount disk
sudo waagent deprovision+user -force # deprovision vm
az vm deallocate -g $groupName -n $vmName
az vm generalize -g $groupName -n $vmName

# creat image of the VM
createImage() {
        az image create -g $groupName -n $imageName --source $vmName        
}
createImage

# Use image to create a new VM

newVm() {               # -n is for new actual vm name  --image is for the name of the image used to make new VM
        az vm create -g $groupName -n $vmImageName --image $imageName 
}
newVm