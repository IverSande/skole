#!/bin/bash

info_regex='T=[0-9]+ Scheduled: T([0-9]+) Ready:((,* * T[0-9]+)*)'

mkdir -p example-process-view

rm -f example-process-view/*.log

function logfilenavn() {
    echo "example-process-view/T$1-proc.log"
}

./gradlew run -q | while read -r line; do
    if [[ $line =~ $info_regex ]]; then
        current_process="${BASH_REMATCH[1]}"
        ready_tasks="${BASH_REMATCH[2]}"
        #  echo "$current_process"

        for task in $ready_tasks
        do
          taskid=$(sed -E 's/ *T([0-9]),*/\1/' <<< "$task")
          logfilenavn "$taskid"
          
        # | while read -r task; do
        done
        
        echo "work" >> "example-process-view/T${current_process}-proc.log"
        
    fi 

done 
