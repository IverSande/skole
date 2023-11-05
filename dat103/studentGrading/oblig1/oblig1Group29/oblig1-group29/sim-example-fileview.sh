#!/bin/bash

info_regex='T=[0-9]\+ Scheduled: T\([0-9]\+\) Ready:\(\(,* *T[0-9]\+\)*\)'
mappe="/example-process-view"

if [ ! -d "$mappe" ]; then
	mkdir "$mappe"
	echo "den er lagd"

else 
	echo "ikke lagd"

        for log_file in "$mappe"/*; do
        > "$log_file"
done
fi


./gradlew run -q | while read -r grade
do
	scheduledProcess=$(echo $grade | sed "s/$info_regex/\1/")
	readyProcess=$(echo $grade | sed "s/$info_regex/\2/" | sed 's/T//g' | sed 's/,//g')
      
	printf "Scheduled: %s \n" $scheduledProcess
	printf "Ready: %s \n" $readyProcess

	for process in $readyProcess
	do
		touch "$mappe/T$process.log"
	done

	for process in $scheduledProcess
	do
		echo "work" >> $mappe/T$process.log  
	done
done



