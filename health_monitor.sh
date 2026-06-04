#!/bin/bash

mkdir -p logs

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOGFILE="logs/health_$TIMESTAMP.log"
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2+$4}')
MEMORY_USAGE=$(free | awk '/Mem:/ {printf("%.2f"),$3/$2 *100}')
DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}')
UPTIME=$(uptime -p)

{
echo "===================="
echo "SYSTEM HEALTH REPORT"
echo "===================="
echo "Generated At : $(date)"
echo "CPU Usage : ${CPU_USAGE} %"
echo "Memory Usage :${MEMORY_USAGE} %"
echo "Disk Usage :${DISK_USAGE}"
echo "Uptime :${UPTIME}"`
} > "$LOGFILE"

echo "Report saved to $LOGFILE"

DISK_INT=${DISK_USAGE%\%} 
if [[ $DISK_INT -gt 80 ]]
then
    echo "WARNING: Disk usage exceeded 80%" >> "$LOGFILE"
fi

MEMORY_INT=${MEMORY_USAGE%.*}
if [[ $MEMORY_INT -gt 75 ]]
then
    echo "WARNING: High memory usage" >> "$LOGFILE"
fi

CPU_INT=${CPU_USAGE%.*}
if [[ $CPU_INT -gt 80 ]]
then 
    echo "WARNING: High CPU usage" >> "$LOGFILE"
fi