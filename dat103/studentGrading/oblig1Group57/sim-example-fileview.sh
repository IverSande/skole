#!/bin/bash

# Create the `example-process-view` directory if it doesn't exist.
mkdir -p example-process-view

# Clean up old files in the `example-process-view` directory.
rm -f example-process-view/*

# Start the SimulationExample.java program.
./gradlew run -q | while IFS= read -r line; do
  if [[ $line =~ "Scheduled" ]]; then
    info_regex='T=[0-9]+ Scheduled: T([0-9]+) Ready:((,* *T[0-9]+)*)'
echo "Processing line: $line"  # Add this line for debugging
    if [[ $line =~ $info_regex ]]; then
      current_task="${BASH_REMATCH[1]}"
      ready_tasks="${BASH_REMATCH[2]}"
      echo "Found matching line. Current task: $current_task, Ready tasks: $ready_tasks"
      # Create a log file for the current task

       echo "work" >> "example-process-view/T${current_task}-proc.log" 

      # Process ready tasks and write 'work' for running tasks
      for task in $ready_tasks
      do
        taskid=$(sed -E 's/ *T([0-9]),*/\1/' <<< "$task")
        echo "Processing ready task: $task, Task ID: $taskid"
        touch -f "example-process-view/T${taskid}-proc.log"
      done
    fi
  fi
done
