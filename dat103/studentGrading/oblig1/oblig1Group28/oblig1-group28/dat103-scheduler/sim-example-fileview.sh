 #!/bin/bash

# Directory for process log files
DIR="example-process-view"

# Clean up and create directory
rm -rf "$DIR"
mkdir -p "$DIR"

# Debug: Echo to ensure the script is running
echo "Script is running..."

# Execute the Java program and process its output
./gradlew run | while read -r line ; do
    # Debug: Print line to verify if it’s reading the output
    echo "Read Line: $line"
    
    # Extract the scheduled task number
    scheduled=$(echo "$line" | sed -n 's/.*Scheduled: T\([0-9]\+\).*/\1/p')
    
    # Debug: Print Scheduled task
    echo "Scheduled Task: T$scheduled"

    # Extract the ready tasks and create their log files
    echo "$line" | sed -n 's/.*Ready: \(.*\)$/\1/p' | grep -o 'T[0-9]\+' | while read -r task; do
        # Debug: Print task that is ready
        echo "Task Ready: $task"
        touch "$DIR/$task-proc.log"
    done

    # If there is a scheduled task, append "work" to its file
    if [ -n "$scheduled" ]; then
        echo "work" >> "$DIR/T$scheduled-proc.log"
    fi
done