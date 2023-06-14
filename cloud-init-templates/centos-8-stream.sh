#!/bin/bash
export $(grep -v '^#' .env | xargs) v


wget -O ${IMAGENAME} --continue ${IMAGEURL}/${IMAGENAME} && 
qm create ${VMID} --name ${VMNAME} --memory ${VMMEM} --cores ${CORES} --sockets ${sockets} --cpu ${CPUTYPE} ${VMSETTINGS} && 
qm importdisk ${VMID} ${IMAGENAME} ${STORAGE} &&
qm set ${VMID} --scsihw virtio-scsi-pci --scsi0 ${STORAGE}:vm-${VMID}-disk-0 &&

qm set ${VMID} --ide2 ${STORAGE}:cloudinit &&
qm set ${VMID} --boot c --bootdisk scsi0 &&
qm set ${VMID} --serial0 socket --vga serial0 &&
qm template ${VMID} &&
echo "TEMPLATE ${VMNAME} successfully created!" && 
echo "Now create a clone of VM with ID ${VMID} in the Webinterface.."
