#!/usr/bin/env bash

# Directory to store the log files
DIR="./example-process-view"

# Check if the directory exists and clean up old files
if [[ -d "$DIR" ]]; then
    echo "$DIR directory exists, continuing..."
    echo "Removing old existing log files..."
    rm "$DIR"/* > /dev/null
else
    mkdir "$DIR"
    echo "Created $DIR directory."
fi

# Original regex pattern to match the output lines
info_regex='T=([0-9]+) Scheduled: T\([0-9]+\).+Ready:\(,? *T[0-9]+)*'

# Execute the SimulationExample.java program
./gradlew run | while IFS= read -r line; do
    echo "$line"
    if [[ $line =~ $info_regex ]]; then
        # Extract the scheduled task number
        scheduled_task=${BASH_REMATCH[1]}
        filename="T$scheduled_task-proc.log"
        
        # Create or append to the log file for the scheduled task
        touch "$DIR/$filename"
        echo "work" >> "$DIR/$filename"
        
        # Extract the ready tasks
        IFS=',' read -ra ready_tasks <<< "${BASH_REMATCH[2]}"
        for task in "${ready_tasks[@]}"; do
            task_num=$(echo "$task" | tr -dc '0-9')  # Extract task number
            touch "$DIR/T$task_num-proc.log"
        done
    fi
done
