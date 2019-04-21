#!/bin/bash

# Version 0.1
# By ptath (https://ptath.ru)
# rclone backup script

#Config section, edit these lines:
RCLONE_SNAME="SERVICE_NAME" # Your service name from rclone config command (e.g. myamazon)
RCLONE_SPATH="RCLONE_SERVICE_PATH" # Yout path in the service above (e.g. folder/subfolder)
#Config section end

# DO NOT EDIT BELOW

list=$(cat /home/pi/.rclone/backup.list)

for i in $list
do
        echo " Trying "$i"..."
        /usr/bin/rclone sync -P --filter-from /home/pi/.rclone/excludes.list "$i" "$RCLONE_SNAME":"$RCLONE_SPATH""$i"
done
