#!/bin/bash

# Ask user for base file name
while [[ -z "$FILENAME" ]]; do
    read -p "Enter the output file file name (example: precheck_server): " FILENAME
done

# Add timestamp
TIMESTAMP=$(date +%F_%H%M)
REPORT=/var/log/"${FILENAME}_${TIMESTAMP}.log"

echo "Report will be saved as: $REPORT"
sleep 1

echo "================ OS PRE PATCHING CHECK REPORT ================" > $REPORT
echo "Hostname: $(hostname)" >> $REPORT
echo "Date: $(date)" >> $REPORT
echo "Report File: $REPORT" >> $REPORT
echo "===============================================================" >> $REPORT


# OS Release Info
echo -e "\n---- OS Release Information ----" >> $REPORT
cat /etc/os-release >> $REPORT 2>/dev/null


# Uptime
echo -e "\n---- System Uptime ----" >> $REPORT
uptime >> $REPORT

# Kernel Version
echo -e "\n---- Kernel Version ----" >> $REPORT
uname -r >> $REPORT

echo -e "\n---- list of Kernel Version ----" >> $REPORT

rpm -qa | grep -i kernel >> $REPORT

echo -e "\n---- /boot information ----" >> $REPORT

ls -l /boot >> $REPORT




# Disk and Storage Information
echo -e "\n================ Storage Information ================" >> $REPORT

echo -e "\n---- lsblk Output ----" >> $REPORT
lsblk >> $REPORT

echo -e "\n---- fdisk -l Output ----" >> $REPORT
fdisk -l >> $REPORT 2>/dev/null

echo -e "\n---- LVM: PVs ----" >> $REPORT
pvs >> $REPORT 2>/dev/null

echo -e "\n---- LVM: VGs ----" >> $REPORT
vgs >> $REPORT 2>/dev/null

echo -e "\n---- LVM: LVs ----" >> $REPORT
lvs >> $REPORT 2>/dev/null


# Filesystem Usage
echo -e "\n---- Filesystem Usage ----" >> $REPORT
df -h >> $REPORT

echo -e "\n---- Filesystems Above 80% Utilization ----" >> $REPORT
df -h | awk '$5+0 > 80' >> $REPORT


# Memory Usage
echo -e "\n---- Memory Usage ----" >> $REPORT
free -h >> $REPORT


# CPU Usage Summary
echo -e "\n---- CPU Usage ----" >> $REPORT
top -bn1 | head -n 5 >> $REPORT


# Top 10 CPU Consuming Processes
echo -e "\n---- Top 10 CPU Consuming Processes ----" >> $REPORT
ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 10 >> $REPORT


# Top 10 Memory Consuming Processes
echo -e "\n---- Top 10 Memory Consuming Processes ----" >> $REPORT
ps -eo pid,ppid,cmd,%mem --sort=-%mem | head -n 10 >> $REPORT


# Running Services
echo -e "\n---- Running Services ----" >> $REPORT
systemctl list-units --type=service --state=running >> $REPORT


# Important Configuration Files
echo -e "\n================ Important Configuration Files ================" >> $REPORT

echo -e "\n---- /etc/fstab ----" >> $REPORT
cat /etc/fstab >> $REPORT 2>/dev/null

echo -e "\n---- /etc/resolv.conf ----" >> $REPORT
cat /etc/resolv.conf >> $REPORT 2>/dev/null

echo -e "\n---- /etc/hosts ----" >> $REPORT
cat /etc/hosts >> $REPORT 2>/dev/null

echo -e "\n---- /etc/hostname ----" >> $REPORT
cat /etc/hostname >> $REPORT 2>/dev/null



# Network Information
echo -e "\n================ Network Information ================" >> $REPORT
ip addr show >> $REPORT

echo -e "\nDefault Gateway:" >> $REPORT
ip route show default >> $REPORT


# Ping Test
echo -e "\n---- Ping Test to Gateway ----" >> $REPORT
GW=$(ip route show default | awk '/default/ {print $3}')
ping -c 2 $GW >> $REPORT 2>/dev/null


# Repo Status
echo -e "\n---- Repository Status ----" >> $REPORT
if command -v yum &>/dev/null; then
    yum repolist >> $REPORT
elif command -v zypper &>/dev/null; then
    zypper lr >> $REPORT
else
    echo "No package manager found!" >> $REPORT
fi


# Error Logs
echo -e "\n---- Recent Errors from /var/log/messages ----" >> $REPORT
grep -Ei "error|fail|critical|warn" /var/log/messages | tail -n 50 >> $REPORT 2>/dev/null


echo -e "\n==================== End of Report ====================" >> $REPORT

echo "Report created successfully: /var/log/$REPORT"