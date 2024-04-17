#!/bin/sh

echo "#Architecture: $(uname -a)"

echo "#CPU physical : $(lscpu | grep 'Socket(s):' | awk '{print $2}')"
echo "#vCPU : $(lscpu | grep 'CPU(s):' | awk '{print $2}')"

total_mem=$(free -m | awk '/^Mem:/{print $2}')
used_mem=$(free -m | awk '/^Mem:/{print $3}')
mem_percentage=$(awk "BEGIN {printf \"%.2f\", $used_mem/$total_mem*100}")
echo "#Memory Usage: ${used_mem}MB/${total_mem}MB (${mem_percentage}%)"

disk_total=$(df -h / | awk 'NR==2 {print $2}')
disk_used=$(df -h / | awk 'NR==2 {print $3}')
disk_percentage=$(df -h / | awk 'NR==2 {print $5}')
echo "#Disk Usage: ${disk_used}/${disk_total} (${disk_percentage})"

cpu_load=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
echo "#CPU load: ${cpu_load}%"

last_boot=$(who -b | awk '{print $3, $4}')
echo "#Last boot: ${last_boot}"

lvm_active=$(lsblk | grep "lvm" | wc -l)
if [ $lvm_active -gt 0 ]; then
    echo "#LVM use: yes"
else
    echo "#LVM use: no"
fi

connections=$(netstat -an | grep -c 'ESTABLISHED')
echo "#Connections TCP : ${connections} ESTABLISHED"

num_users=$(who | wc -l)
echo "#User log: ${num_users}"

ipv4_address=$(ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -f1 -d'/')
mac_address=$(ip addr show | grep 'link/ether' | awk '{print $2}')
echo "#Network: IP ${ipv4_address} (${mac_address})"

sudo_commands=$(sudo grep -c 'sudo' /var/log/sudo/logs)
echo "#Sudo : ${sudo_commands} cmd"
