function lsdisks
    lsblk -o NAME,SIZE,HOTPLUG,RO,TYPE,FSTYPE,MOUNTPOINT | grep -v loop
end

