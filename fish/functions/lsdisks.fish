function lsdisks
    if which grc > /dev/null
        grc lsblk -o NAME,SIZE,HOTPLUG,RO,TYPE,FSTYPE,MOUNTPOINT | grep -v loop
    else
        lsblk -o NAME,SIZE,HOTPLUG,RO,TYPE,FSTYPE,MOUNTPOINT | grep -v loop
    end
end

