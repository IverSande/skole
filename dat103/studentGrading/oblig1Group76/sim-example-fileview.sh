#!/bin/bash

# Checks is there already exists a directory, if so clean it up
if [ -d "example-process-view" ]; then
    # Recursively removes files from directory
    rm -r "example-process-view"

fi

# Creates a new directory
mkdir -p "example-process-view"

# Regex to match the java programs output.
info_regex='T=[0-9]+ Scheduled: T([0-9]+) Ready:((,* *T[0-9]+)*)'

# Compile and run the program using Gradle, then read each line of the output using "$line"
gradle -q run | while read -r line; do
    echo "$line"
    # Check if the line being read matches the regex:
    if [[ $line =~ $info_regex ]]; then
        # Store the 'scheduled_task' in a variable for further use by matching first part of regex.
        scheduled_task=$(echo "$line" | sed -E "s/$info_regex/\1/")
        # Create a log_file for every scheduled task.
        log_file="example-process-view/T${scheduled_task}-proc.log"
        # Append a line saying work for the scheduled tasks.
        echo "work" >>"$log_file"
    fi
done
echo "The program has finished running, the log files can be located in the directory 'example-process-view'"
