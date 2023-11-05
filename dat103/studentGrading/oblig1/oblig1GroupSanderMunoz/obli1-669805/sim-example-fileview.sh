#!/bin/bash

# Create the example-process-view directory if it doesn't exist
mkdir -p example-process-view

# Clean up old log files in the example-process-view directory
rm -f example-process-view/*.log

# Run the SimulationExample.java program and process its output
# Compile and run SimulationExample.java, capturing its output
output_from_simulation_example_java=$(java SimulationExample 2>&1) | \
while IFS= read -r line; do
    # Extract task number and state information from the line
    task_number=$(echo "$line" | grep -o 'T[0-9]\+' | sed 's/T//')
    state=$(echo "$line" | grep -o 'Scheduled\|Ready\|Finished')

    # Create a log file for the current task
    touch "example-process-view/T${task_number}-proc.log"

    # Append "work" line to the log file for running processes
    if [ "$state" != "Finished" ]; then
        echo "work" >> "example-process-view/T${task_number}-proc.log"
    fi
done <<< "$output_from_simulation_example_java"

echo "Simulation completed. Process logs can be found in the example-process-view directory."
