#!/bin/bash

dir="example-process-view"

mkdir -p $dir
echo "Directory $dir created."

rm $dir/* 2>/dev/null
echo "Old files removed."

java -cp build/classes/java/main HVL.Scheduler.SimulationExample | while read line; do

    echo "Reading line: $line"

    current_task=$(echo "$line" | sed -n "s/.*Scheduled: T\([0-9]\).*$/\1/p")

    if [[ $current_task ]]; then
        echo "work" >> "$dir/T$current_task-proc.log"
        echo "Writing work to $dir/T$current_task-proc.log"
    fi

    ready_tasks=$(echo "$line" | sed -n "s/.*Ready: \(.*\)/\1/p" | sed 's/T\([0-9]\)/\1/g' | sed 's/,//g')

    for task in $ready_tasks; do
        touch "$dir/T$task-proc.log"
        echo "Touching $dir/T$task-proc.log"
    done
done
