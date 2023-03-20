#!/bin/bash
for PROC in /proc/*[0-9]*;
do
        cat /$PROC/status | grep PPid | tr '\n' ';' | tr -d $'PPid:\t ' 
	cat /$PROC/status | grep -m 1 Pid | tr '\n' ';' | tr -d $'Pid:\t ' 
	cat /$PROC/status | grep Name | tr '\n' ';' | tr -d $'\t ' | sed 's/Name://'
	cat /$PROC/status | grep State | tr '\n' ';' | tr -d $'\t\n ' | sed 's/State://' 
	tty=$(cat /$PROC/stat | cut -d " " -f 7)
	echo -n $tty
	echo -n ";"
	cat /$PROC/status | grep VmRSS | tr '\n' ';' | tr -d $'VmRSS:\t kB'
	cat /$PROC/stat | awk '{print $5";"}' | tr -d '\n'
       	cat /$PROC/status | grep NSsid | tr '\n' ';' | tr -d $'NSsid:\t '
	echo -n | ls /$PROC/fd | wc -l
	 
done | column -s ";" -o "|" -t -N "PPID","PID","COMM","STAT","TTY_NR","RSS","GID","SID","PROCFILES"

