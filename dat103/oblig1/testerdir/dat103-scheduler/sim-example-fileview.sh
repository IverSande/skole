#!/bin/bash

# Create the example-process-view directory if it doesn't exist
mkdir -p example-process-view

# Clean up old files in the example-process-view directory
rm -f example-process-view/T*-proc.log

# Regular expression for parsing lines
info_regex='T=([0-9]+) Scheduled: T([0-9]+) Ready: (.*)'

# Execute the SimulationExample.java program and process its output
./gradlew run -q | while read -r line; do
    # Check if the line indicates a scheduled task
    if [[ "$line" =~ $info_regex ]]; then
        step_number="${BASH_REMATCH[1]}"
        process_number="${BASH_REMATCH[2]}"
        ready_tasks="${BASH_REMATCH[3]}"

        # Create corresponding log file for the scheduled task
        filename="example-process-view/T${process_number}-proc.log"
        
        # Append "work" line to the file
        echo "work" >> "$filename"
    fi
done