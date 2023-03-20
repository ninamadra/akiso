#!bin/bash

counter=0
donwloadSum=0
uploadSum=0
received=""
previouslyReceived=""
transfered=""
previoulsyTransfered=""
previousCpus=()
downloadSpeeds=(0 0 0 0 0 0 0 0 0 0 )
uploadSpeeds=(0 0 0 0 0 0 0 0 0 0 )

#Download/Upload Speed
	
function getReceived () { echo $(cat /proc/net/dev | grep wl | cut -d ':' -f 2 | awk '{print $1}'); }
	
function getTransfered () { echo $(cat /proc/net/dev | grep wl | cut -d ':' -f 2 | awk '{print $9}'); }
	
function calculateCurrentSpeed () { echo $(( $1 - $2 )); }

function changeUnit () {
	if (( $1 > 1024 )); then
		if (( $1 > 1048576 )); then
			echo $(($1/1048576)) "MB/s"
		else echo $(($1/1024)) "KB/s"
		fi
	else echo $1 "B/s"
	fi
}
	
function calculateAverageSpeed () { 
	if (( $counter > 0 )); then
		speed=$(( $1/$counter ))
		echo $speed
	else echo 0
	fi
}

function showChart () {
	values=()
	if [[ $1 = "download" ]]; then
		for i in {0..9}; do
			downloadSpeeds[$i]=${downloadSpeeds[$((${i}+1))]}
			values[$i]=${downloadSpeeds[$i]}
		done
		downloadSpeeds[9]=$2
		
	elif [[ $1 = "upload" ]]; then
		for i in {0..9}; do
			uploadSpeeds[$i]=${uploadSpeeds[$((${i}+1))]}
			values[$i]=${uploadSpeeds[$i]}
		done
		uploadSpeeds[9]=$2
	else echo	
	fi
	values[9]=$2

	maxValue=0
	for v in ${values[@]}; do
   		if (( $v > $maxValue )); then 
   			maxValue=$v; 
   		fi; 
	done
	echo -en "  |"
	for v in ${values[@]}; do
		if [[ $maxValue = 0 ]]; then
			height=0
		else height=$(echo $v*10/$maxValue | bc)
		fi
		if [[ $height = 0 ]]; then
			echo -en "\033[1C"
		else for ((i=1;i <= $height; i++)); do
			echo -en "\u2588\033[1A\033[1D"
		done
		echo -en "\033[$(echo $height)B\033[1C"
		fi
	done
	echo -n '|                '
}
	
function printSpeed () {
	received=$(getReceived)
	transfered=$(getTransfered)
	if [[ $counter > 0 ]]; then
	
		downloadSpeed=$(calculateCurrentSpeed $received $previouslyReceived)
		downloadSum=$(($downloadSum+$downloadSpeed))
		downloadSpeed=$(changeUnit $downloadSpeed)
		averageDownloadSpeed=$(calculateAverageSpeed $downloadSum)
		echo -en "\033[10B"
		showChart "download" $averageDownloadSpeed
		averageDownloadSpeed=$(changeUnit $averageDownloadSpeed)
		
		uploadSpeed=$(calculateCurrentSpeed $transfered $previouslyTransfered)
		uploadSum=$(($uploadSum+$uploadSpeed))
		uploadSpeed=$(changeUnit $uploadSpeed)
		averageUploadSpeed=$(calculateAverageSpeed $uploadSum)
		showChart "upload" $averageUploadSpeed
		averageUploadSpeed=$(changeUnit $averageUploadSpeed)
		
		echo
		echo
		echo "CURR: "$downloadSpeed "  AVG: " $averageDownloadSpeed ";" "CURR: "$uploadSpeed "   AVG: " $averageUploadSpeed | column -t -s ";" -N "DOWNLOAD"," UPLOAD"
		echo
	
	fi
	previouslyReceived=$received
	previouslyTransfered=$transfered
	counter=$(($counter + 1))

}

#Cores utilization and frequency

function calculateCpuUsage () {
	delta=$(($1-$2))
	idleDelta=$(($3-$4))
	usage=$((100*($delta-$idleDelta)/$delta))
	echo $usage "%"

}

function printCpuInfo () {
	cpus=($(cat /proc/stat | grep cpu[0-9] | awk '{sum=0; for (i=1; i<=NF; i++) { sum+= $i } print $1";"sum";"$5}')) #cpuNr;sum;idle
	mhz=($(cat /proc/cpuinfo | grep "cpu MHz" | cut -d ' ' -f 3))
	if (( $counter > 1 )); then
		for i in ${!cpus[@]}; do
			cpu=$( echo ${cpus[$i]} | cut -d ";" -f 1)
			sum=$( echo ${cpus[$i]} | cut -d ";" -f 2)
			previousSum=$( echo ${previousCpus[$i]} | cut -d ";" -f 2)
			idle=$( echo ${cpus[$i]} | cut -d ";" -f 3)
			previousIdle=$( echo ${previousCpus[$i]} | cut -d ";" -f 3)
			usage=$(calculateCpuUsage $sum $previousSum $idle $previousIdle)
			cpuMhz=${mhz[$i]}
			echo $cpu ": "  " $usage   " $cpuMhz " Mhz"
		done
	fi
	for i in ${!cpus[@]}; do
		previousCpus[$i]=${cpus[$i]}
	done
	echo	
}

#Uptime

function getUpTime () { 
	time=$(cat /proc/uptime | awk '{print $1}')
	time=${time%.*}
	echo $time
}

function printUpTime () { 
	time=$(getUpTime)
	printf 'UPTIME: %dd %dh:%dm:%ds\n' $(($time/86400)) $(($time%86400/3600)) $(($time%3600/60)) $(($time%60))
	echo
}

#Battery level

function getBatteryLevel () { 
	cat /sys/class/power_supply/BAT1/uevent | grep "POWER_SUPPLY_CAPACITY=" | tr -d $'POWER_SUPPLY_CAPACITY='
}

function printBatteryLevel () { 
	batteryLevel=$(getBatteryLevel)
	echo "BATTERY LEVEL: " $batteryLevel "%"
	echo
}

#Load

function getLoad () { cat /proc/loadavg | awk '{print $1" "$2" "$3 }';}

function printLoad () { 
	load=$(getLoad)
	echo "LOAD: " $load
	echo
}

#Memory

function getMemoryTotal () { echo $(cat /proc/meminfo | head -n 1 | cut -d " " -f 9 | tr -d " kB"); }

function getMemoryAvailable () { echo $(cat /proc/meminfo | head -n 3 | tail -n 1 | cut -d " " -f 5 | tr -d " kB"); }

function calculateMemoryUsage () {
	total=$(getMemoryTotal)
	available=$(getMemoryAvailable)
	usage=$(( (total-available) *100 / total))
	echo $usage
	
}

function printMemoryInfo () {
	usage=$(calculateMemoryUsage)
	echo "MEMORY USAGE: " $usage "%"
	echo
	cat /proc/meminfo | head -n 3
	echo 

}

#Main loop

while :
do
	printSpeed
	printCpuInfo
	printUpTime
	printBatteryLevel
	printLoad
	printMemoryInfo
	sleep 1
	echo -e '\0033\0143'
done
