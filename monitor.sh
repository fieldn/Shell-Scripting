#!/bin/bash

#DO NOT REMOVE THE FOLLOWING TWO LINES
git add $0 >> .local.git.out
git commit -a -m "Lab 2 commit" >> .local.git.out

# cycles per second
hertz=$(getconf CLK_TCK)

function check_arguments {

	#If number of arguments is less than 5, exit. For part 2, the number of arguments should be greater than 7
	if [ "$1" -lt 5 ]; then
		echo "USAGE: "
		echo "$0 {process id} -cpu {utilization percentage} {maximum reports} {time interval}"
		exit
	fi

	CPU_THRESHOLD=$4

	#Extract the memory threshold (part 2 of the script)
    if [ "$1" -gt 6 ]; then
        MEMORY_THRESHHOLD=$6
    else 
        MEMORY_THRESHHOLD=-1
    fi

}

function init {
	#Remove reports directory
	rm -fr ./reports_dir
	mkdir ./reports_dir

	REPORTS_DIR=./reports_dir

	PID=$1 #This is the pid we are going to monitor

	TIME_INTERVAL=${@:$#} #Time interval is the last argument

	MAXIMUM_REPORTS=${@:$#-1:1} #Maximum reports is the argument before the last

}

#This function calculates the CPU usage percentage given the clock ticks in the last $TIME_INTERVAL seconds
function jiffies_to_percentage {
	
	#Get the function arguments (oldstime, oldutime, newstime, newutime)
    oldutime=$1
    oldstime=$2
    newutime=$3
    newstime=$4

	#Calculate the elpased ticks between newstime and oldstime (diff_stime), and newutime and oldutime (diff_utime)
    diff_utime=$((newutime - oldutime ))
    diff_stime=$((newstime - oldstime ))

	#Calculate the CPU usage percentage. $TIME_INTERVAL is the user-provided time_interval
	echo "100 * ( ($diff_stime + $diff_utime) / $hertz) / $TIME_INTERVAL" | bc -l
}

#This function takes as arguments the cpu usage and the memory usage that were last computed
function generate_report {
	
	#if ./reports_dir has more than $MAXIMUM_REPORTS reports, delete the oldest report
    num_reports=$(ls -1 $REPORTS_DIR | wc -l)

    if [ "$num_reports" -ge "$MAXIMUM_REPORTS" ]; then
        file_to_delete=$(ls $REPORTS_DIR | egrep '([0-9]{2}\.){2}([0-9]{4}\.)([0-9]{2}\.){2}[0-9]{2}' | head -1)
        rm $REPORTS_DIR/$file_to_delete
    fi

	file_name="$(date +'%d.%m.%Y.%H.%M.%S')"                #Name of the report file

	process_name=$(cat /proc/$PID/stat | awk '{print $2}')  #Extracting process name from /proc

    #Generate the report
	echo "PROCESS ID: $PID" > ./reports_dir/$file_name
	echo "PROCESS NAME: $process_name" >> ./reports_dir/$file_name
	echo "CPU USAGE: $1 %" >> ./reports_dir/$file_name
    if [ $MEMORY_THRESHHOLD -ne -1 ]; then
	    echo "MEMORY USAGE: $2 kB" >> ./reports_dir/$file_name
    fi
}

#Returns a percentage representing the CPU usage
function calculate_cpu_usage {

	#First, get the current utime and stime (oldutime and oldstime) from /proc/{pid}/stat
    oldutime=$(cat /proc/$PID/stat | awk '{print $14}')
    oldstime=$(cat /proc/$PID/stat | awk '{print $15}')

    sleep $TIME_INTERVAL    #Sleep for time_interval

	#Now, get the current utime and stime (newutime and newstime) /proc/{pid}/stat
    newutime=$(cat /proc/$PID/stat | awk '{print $14}')
    newstime=$(cat /proc/$PID/stat | awk '{print $15}')

	#use the function jiffies_to_percentage
    percentage=$(jiffies_to_percentage $oldutime $oldstime $newutime $newstime)

	echo "$percentage" #return the CPU usage percentage
}

function calculate_mem_usage
{
    #Extract the VmRSS value from /proc/{pid}/status
    mem_usage=$(grep -E 'VmRSS' /proc/$PID/status | awk '{print $2}')   

	echo "$mem_usage"   #Return the memory usage
}

function notify
{
	#compare $usage_int to $CPU_THRESHOLD
	cpu_usage_int=$(printf "%.f" $1)

	#Check if the process has exceeded the thresholds
    if [[ $cpu_usage_int -gt $CPU_THRESHOLD || $mem_usage -gt $MEMORY_THRESHHOLD ]]; then
        file_to_send=$(ls $REPORTS_DIR | egrep '([0-9]{2}\.){2}([0-9]{4}\.)([0-9]{2}\.){2}[0-9]{2}' | tail -1)
        echo "Maximum memory usage exceeded:" > tmp_message
        cat $REPORTS_DIR/$file_to_send >> tmp_message
        cat tmp_message
        #/usr/bin/mailx -s "mail-usage" $USER < tmp-message
        exit
    fi

}


check_arguments $# $@

init $1 $@

echo "CPU THRESHOLD: $CPU_THRESHOLD"
echo "MAXIMUM REPORTS: $MAXIMUM_REPORTS"
echo "Time interval: $TIME_INTERVAL" 

#The monitor runs forever
while [ -n "$(ls /proc/$PID)" ] #While this process is alive
do
	#part 1
	cpu_usage=$(calculate_cpu_usage)

	#part 2
    mem_usage=$(calculate_mem_usage)
    
	generate_report $cpu_usage $mem_usage

	#Call the notify function to send an email to $USER if the thresholds were exceeded
	notify $cpu_usage $mem_usage

done
