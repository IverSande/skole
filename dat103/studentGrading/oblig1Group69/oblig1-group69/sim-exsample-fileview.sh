#!/bin/bash

DIR="example-process-view"
info_regex='T=[0-9]+ Scheduled: T([0-9]+) Ready:((,* *T[0-9]+)*)'

mkdir -p $DIR
rm -f $DIR/*

./gradlew run -q | while read -r  line; do
   
    if [[ $line =~ $info_regex ]]; then
	
	# adding a "statusbar" to show something is happening.. 	
	echo -ne '#####                     (33%)\r'
	sleep 0.5
	echo -ne '#############             (66%)\r'
	sleep 0.5
	echo -ne '#######################   (100%)\r'
	echo -ne '\n'
	# statusbar end
	
	scheduled=$(echo $line | sed -E  "s/$info_regex/\1/")
	ready_list=$(echo $line | sed -E "s/$info_regex/\2/")
	
	# also can use BASH_REMATCH[n] see: https://www.bashsupport.com/bash/variables/bash/bash_rematch/	
	
	# scheduled="${BASH_REMATCH[1]}"
	# ready_list="${BASH_REMATCH[2]}"
	
        echo "work" >> "$DIR/T${scheduled}-proc.log"

        IFS=","

        for task in $ready_list; do

            task_num=$(echo "$task" | sed -n 's/ *T\([0-9]\+\)/\1/p')
            touch "$DIR/T${task_num}-proc.log"

        done
    fi
done
exit 0
