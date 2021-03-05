#!/bin/bash

echo "Create VG, LV and Mount points"

# Create disk from cli – gcloud beta compute disks create <disk_name> --project=<project name> --type=pd-ssd --size=<disk size>GB --zone=<required zone> --physical-block-size=4096
# Attach disk - gcloud compute instances attach-disk <instance-name> --disk <disk_name>  --device-name <disk_name>  --zone <required zone>
# Authorizations - see - https://codelabs.developers.google.com/codelabs/cloud-persistent-disk/index.html?index=..%2F..index#0

# Parameters
# $1 = vggroup
# $2 = lv name
# $3 = lv size
# $4 = mount point

CUR_DATE=`date +"%b %d:%Y-%H:%M:%S"`
ID="${CUR_DATE}:${0}:"

if [[ $# -ne 4 ]]
then
        echo "${ID}Incorrect parameters specified!"
        echo "${ID}Please try again!"
        echo "${ID}e.g. "
        echo "${ID}e.g. ./"
        exit 1
fi

CNT=0

# Check if vg already exist
CNT=`vgs | grep -ic "${1}"`
if [ $CNT -ne "1" ]; then
 echo "VgGroup ${1} does not exist - exiting!"
 exit
fi

CNT=0
CNT=`lvs | grep -ic "${2}"`
if [ $CNT -eq "1" ]; then
 echo "Choose another lv name ${2} already exist - exiting!"
 exit
fi

lvcreate -L${3}GB -n ${2} ${1}

mkfs -t xfs "/dev/${1}/${2}"

mkdir ${4}

while true; do
    read -p "Are you sure to add - /dev/${1}/${2} ${4} xfs defaults,discard,nofail 0 0 >>/etc/fstab?" yn
    case $yn in
        [Yy]* ) echo "/dev/${1}/${2} ${4} xfs defaults,discard,nofail 0 0" >>/etc/fstab; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done