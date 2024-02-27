# Creating logical volumes via a basj script

How to access Googles Cloud Shell so that you can execute the gcloud commands below - https://cloud.google.com/shell/docs/launching-cloud-shell 

# In Cloud shell:
Create disk from cli:
  ```gcloud beta compute disks create <disk_name> --project=<project name> --type=pd-ssd --size=<disk size>GB --zone=<required zone> --physical-block-size=4096```
Attach disk:
  ```gcloud compute instances attach-disk <instance-name> --disk <disk_name>  --device-name <disk_name>  --zone <required zone>```

# Now you can use th script to do the same ting - from instance ssh shell:
Create a Volume group –  ./cr_vg.bash /dev/disk/by-id/google-test-sybbackup vg_sybbackup lv_sybbackup 100
Create a logical file system - ./cr_lv.bash vg_sybbackup lv_sybbackup 98 /sybasebackup
