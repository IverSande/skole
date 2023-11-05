#!/bin/bash
# Directory where log files will be stored
log_dir="example-process-view"
# Check if the log directory exists and create it if necessary
if [ ! -d "$log_dir" ]; then
 mkdir "$log_dir"
fi
# Clean up old log files in the directory
rm -f "$log_dir"/*.log
# Regular expression for extracting process information
info_regex=' T =[0-9]\+ Scheduled : T \([0-9]\+\) Ready :\(, * T [0-9]\+\)* '
# Start the Java program and process its output
java SimulationExample | while IFS= read -r line; do
 # Check if the line matches the info_regex
 if [[ "$line" =~ $info_regex ]]; then
 # Extract process numbers from the line
 scheduled_process="${BASH_REMATCH[1]}"
 ready_processes="${BASH_REMATCH[2]}"
 # Create a log file for the scheduled process
 log_file="$log_dir/T${scheduled_process}-proc.log"
 # Append "work" lines to the log file for running processes
 for process in $(sed 's/ *T\([0-9]\),*\+/\1/' <<< "$ready_processes"); do
 if [ "$scheduled_process" == "$process" ]; then
 echo "work" >> "$log_file"
 fi
 done
 fi
done