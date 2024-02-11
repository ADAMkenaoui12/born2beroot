#!/bin/bash
Arch_info=$(uname -a)
physical_processors=$(lscpu | grep 'Socket(s)' | awk '{print $2}')
virtual_processors=$(lscpu | grep 'Thread(s) per core' | awk '{print $4}')
memory_info=$(free -m | grep 'Mem' | awk '{printf("%d/%dMB (%.2f%%)\n", $3, $2, $3/$2 * 100)}')
disk_info=$(df -m --total | grep 'total'| awk '{printf("%d/%dGb (%s)"), $3, $2/1024, $5}')
cpu_info=$(mpstat | grep all | awk '{printf("%.2f%%", 100-$13)}')
last_reboot=$(who -b | awk '{print $3, $4}')
lvm_status=$(if lsblk | grep -q 'lvm'; then echo "yes"; else echo "no"; fi)
num_tcp_connections=$(echo "$(netstat -t | grep 'ESTABLISHED' | wc -l) ESTABLISHED")
num_of_user=$(who | awk '{print $1}' | sort | uniq | wc -l)
ip_mac_address=$(echo "IP $(hostname -I) ($(ip a | grep 'ether' | awk '{print $2}'))")
count_sudo_commands=$(echo "$(grep -c 'COMMAND=/usr/bin/' /var/log/sudo/sudo.log) cmd")
wall "
	#Architecture: $Arch_info
	#CPU physical : $physical_processors
	#vCPU : $virtual_processors
	#Memory Usage: $memory_info
	#Disk Usage: $disk_info
	#CPU load: $cpu_info
	#Last boot: $last_reboot
	#LVM use: $lvm_status
	#Connections TCP : $num_tcp_connections
	#User log: $num_of_user
	#Network: $ip_mac_address
	#Sudo : $count_sudo_commands
"
