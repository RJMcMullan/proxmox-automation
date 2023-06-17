#!/bin/bash
export $(grep -v '^#' .env | xargs)

if [ ! -e $IMAGE_FILE ]
then
 # Download the Cloud Init Image
 wget $IMAGE_URL
fi

qm create $VMID --name $VMNAME --memory $MEM --net0 virtio,bridge=vmbr0 --cores $CORES --sockets $SOCKETS --cpu cputype=$CPUTYPE 
qm importdisk $VMID $IMAGE_FILE $STORAGE &&
qm set $VMID --scsihw virtio-scsi-pci --scsi0 $STORAGE:vm-$VMID-disk-0 
qm set $VMID --ide2 $STORAGE:cloudinit 
qm set $VMID --boot c --bootdisk scsi0 
qm set $VMID --serial0 socket --vga serial0 
qm template $VMID 
echo -e "\e\n[1;33m 🚀 TEMPLATE $VMNAME successfully created! \e[0m"
echo -e "\e\n[1;32m 🖥  Now create a clone of VM with ID $VMID.. \e[0m"

if [ -e $IMAGE_FILE  ]
then
    rm $IMAGE_FILE 
fi