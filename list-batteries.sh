#!/usr/bin/env bash

for bat in /sys/class/power_supply/*; do
    if [ -r "$bat/uevent" ]; then
        . "$bat/uevent"
        name=$POWER_SUPPLY_NAME
        perc=$POWER_SUPPLY_CAPACITY
        levl=$POWER_SUPPLY_CAPACITY_LEVEL
        stat=$POWER_SUPPLY_STATUS
    else
        name=${bat##*/}

        if [ -r "$bat/capacity" ]; then
            perc=$(cat "$bat/capacity")
        fi

        if [ -r "$bat/capacity_level" ]; then
            levl=$(cat "$bat/capacity_level")
        fi

        if [ -r "$bat/status" ]; then
            stat=$(cat "$bat/status")
        fi
    fi

    echo "${bat##*/};$name;$stat;$levl;$perc"
done
