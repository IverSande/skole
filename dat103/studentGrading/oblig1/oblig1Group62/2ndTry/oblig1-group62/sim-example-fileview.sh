#!/bin/bash

# Define the regex to parse SimulationExample.java output
info_regex="T=\([0-9]\+\) Scheduled: T\([0-9]\+\) Ready:\(\(, T[0-9]\+\)*\)"

# Create a directory for process logs if it doesn't exist
mkdir -p example-process-view

# Remove old log files from previous run
rm -f example-process-view/T*-proc.log

# Run SimulationExample.java and process each line of output
java -cp /root/dat103-scheduler/build/classes/java/main HVL.Scheduler.SimulationExample 2>&1 | while read -r line; do
    echo "Processing line: $line"

        # Use regex to extract relevant information from the line
	    scheduled_task=$(echo "$line" | sed -n "s/.*Scheduled: T\([0-9]\+\).*/\1/p")

	        # Update log files only for the scheduled task
		    if [[ ! -z $scheduled_task ]]; then
			            echo "Logging for T$scheduled_task..."
				            echo "work" >> "example-process-view/T$scheduled_task-proc.log"
					        fi
					done

