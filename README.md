# Linux System Health Check & Pre-Maintenance Report Script

A comprehensive Bash script that generates a **complete system health report** in one command.  
This tool helps Linux administrators perform consistent and automated checks before:

- OS patching
- System reboots
- Performance troubleshooting
- Migration activities
- Storage changes
- Production incident analysis
- Regular preventive maintenance

---

## Features

✔ Collects OS & kernel information  
✔ Lists all installed kernels  
✔ Disk details (lsblk, fdisk, LVM PV/VG/LV)  
✔ Filesystem usage + highlights partitions above 80%  
✔ Memory & CPU summary  
✔ Top CPU/memory consuming processes  
✔ Running services  
✔ Network details + default gateway + ping check  
✔ Repository configuration (YUM/Zypper)  
✔ Important configuration files (fstab, hosts, resolv.conf, hostname)  
✔ Recent errors/warnings from logs  
✔ Creates a timestamped `.log` report file  

---

## Use Cases

This script is useful for:

- Pre/Post patch checks  
- Pre/Post reboot checks  
- Daily/weekly health monitoring  
- Onboarding new servers  
- RCA and performance analysis  
- Before raising vendor tickets  
- Quick overview of any Linux system  



