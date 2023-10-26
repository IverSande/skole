#!/bin/bash


info_regex='T =[0 -9]\+ Scheduled : T \([0 -9]\+\) Ready :\(\( ,* * T [0 -9]\+\)*\)'
javac $(find . -name "*.java")
mkdir -p example-process-view
if [ -d "example-process-view" ]; then
    rm example-process-view/*.log
fi

java -cp . SimulationExample | while read -r line
do
   
    scheduled_task=$(echo "$line" | sed "s/$info_regex/\1/")
    ready_tasks=$(echo "$line" | sed "s/$info_regex/\2/" | sed 's/ *T\([0-9]\),*\+/\1/')
    echo 'work' >> "example-process-view/T${scheduled_task}-proc.log"
    for task in $ready_tasks
    do
      
        touch "example-process-view/T${task}-proc.log"
    done
done