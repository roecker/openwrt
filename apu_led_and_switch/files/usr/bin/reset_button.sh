#!/bin/ash

wait=1

[ "$(getbaseboard.sh)" == "APU" ] || exit 1

# wait half a minute until we do something. Give all
# drivers time to be completely loaded
sleep 30

while true; do
    if [ "$(cat /dev/apu_button_s1)" -eq "1" ]; then
        logger -t RIAB "reset button pressed... resetting factory defaults!"
        echo -en "\a" > /dev/tty5
        mtd -r erase rootfs_data
    fi
    sleep $wait
done
