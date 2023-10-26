#!/bin/bash

dir="./example-process-view"

if [[ -d "$dir" ]]; then
	echo "This directory allready exists -- Removing old logs"
	rm -f "$dir"*.log
	
    else
	echo "Creating new directory"
	mkdir "$dir"
    fi

info_regex='T=[0-9]\+ Scheduled: T\([0-9]\+\) 
Ready:\(\(,* *T[0-9]\+\)*\)'


./gradlew run| while IFS= read -r line; do
  
  if [[ $line =~ $info_regex ]]; then
	echo $line 
    task="${BASH_REMATCH[2]}"
    file="$dir/T${task}-proc.log"
    
    touch "$file"	
    echo "work" >> "$file"
  fi
done 


