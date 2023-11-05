#!/bin/bash

project_root="/home/ty/Desktop/dat103-scheduler"
cd "$project_root"

mkdir -p example-process-view

rm -f example-process-view/*

javac -cp ".:src/main/java" src/main/java/HVL/Scheduler/*.java

if [ $? -eq 0 ]; then

  java -cp ".:src/main/java" HVL.Scheduler.SimulationExample | while read -r line; do

    info_regex='T=[0-9]+ Scheduled: T([0-9]+) Ready:((,* *T[0-9]+)*)'

    if [[ $line =~ $info_regex ]]; then
      current_process="${BASH_REMATCH[1]}"
      ready_tasks="${BASH_REMATCH[2]//, / }"

      # Create a process log file for the current process
      process_log_file="example-process-view/T${current_process}-proc.log"

      for task in $ready_tasks; do
        task_regex='T[0-9]+'
        if [[ $task =~ $task_regex ]]; then
          echo "work" >> "$process_log_file"
        fi
      done
    fi
  done
else
  echo "Compilation failed. Check for errors in your Java code."
fi


