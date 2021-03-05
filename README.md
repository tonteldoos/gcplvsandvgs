# gcplvsandvgs

What is nice u can also create your disk from the GCP console with these commands.

How to logon to be able to execute the gcloud command - see - https://codelabs.developers.google.com/codelabs/cloud-persistent-disk/index.html?index=..%2F..index#0 

Cloud shell:
Create disk from cli – gcloud beta compute disks create <disk_name> --project=<project name> --type=pd-ssd --size=<disk size>GB --zone=<required zone> --physical-block-size=4096
Attach disk - gcloud compute instances attach-disk <instance-name> --disk <disk_name>  --device-name <disk_name>  --zone <required zone>

From instance ssh shell:
Create a Volume group –  ./cr_vg.bash /dev/disk/by-id/google-sapeccfra-sybbackup vg_sybbackup lv_sybbackup 100
Create a logical file system - ./cr_lv.bash vg_sybbackup lv_sybbackup 98 /sybasebackup
