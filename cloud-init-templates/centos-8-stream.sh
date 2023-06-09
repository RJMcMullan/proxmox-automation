#!/bin/bash
# Creats a Centos stream 8 Cloud-Init Ready VM Template in Proxmox
#
#
#
export IMAGENAME="CentOS-Stream-GenericCloud-8-20230523.0.x86_64.qcow2"
export IMAGEURL="https://cloud.centos.org/centos/8-stream/x86_64/images/CentOS-Stream-GenericCloud-8-20230523.0.x86_64.qcow2"
export STORAGE="local-lvm"
export VMNAME="centos-8-temp"
export VMID=9000
export VMMEM=2048
export VMSETTINGS="--net0 virtio,bridge=vmbr0"
export CPUTYPE="host"
export SOCKETS=1
export CORES=1

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
