#!/bin/bash

echo "Create VG, LV and Mount points"

# Create disk from cli – gcloud beta compute disks create <disk_name> --project=<project name> --type=pd-ssd --size=<disk size>GB --zone=<required zone> --physical-block-size=4096
# Attach disk - gcloud compute instances attach-disk <instance-name> --disk <disk_name>  --device-name <disk_name>  --zone <required zone>
# Authorizations - see - https://codelabs.developers.google.com/codelabs/cloud-persistent-disk/index.html?index=..%2F..index#0

# Parameters
# $1 = google disk name in /dev/disk/by-id/google-<disk name from consle>
# $2 = vggroup
# $3 = lv name
# $4 = lv size
# $5 = mount point

CUR_DATE=`date +"%b %d:%Y-%H:%M:%S"`
ID="${CUR_DATE}:${0}:"

if [[ $# -ne 5 ]]
then
        echo "${ID}Incorrect parameters specified!"
        echo "${ID}Please try again!"
        echo "${ID}e.g. "
        echo "${ID}e.g. ./"
        exit 1
fi

CNT=0

# Check pv
if [ ! -L ${1} ]
then
   echo "Device file does not exist - ${1}"
   exit
fi

CNT=`pvs | grep -ic "${2}"`
if [[ $CNT -eq "1" ]]; then
 echo "pvcreate ${1} already exist - exiting!"
 exit
fi

CNT=0
# Create pvcreate
pvcreate ${1}

CNT=`vgs | grep -ic "${2}"`
if [ $CNT -eq "1" ]; then
 echo "VgGroup ${2} already exist - exiting!"
 exit
fi

vgcreate ${2} ${1}

CNT=0
CNT=`lvs | grep -ic "${3}"` 
if [ $CNT -eq "1" ]; then
 echo "Choose another lv name ${3} already exist - exiting!"
 exit
fi

lvcreate -L${4}GB -n ${3} ${2}

mkfs -t xfs "/dev/${2}/${3}"

mkdir ${5}

while true; do
    read -p "Are you sure to add - /dev/${2}/${3} ${5} xfs defaults,discard,nofail 0 0 >>/etc/fstab?" yn
    case $yn in
        [Yy]* ) echo "/dev/${2}/${3} ${5} xfs defaults,discard,nofail 0 0" >>/etc/fstab; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done