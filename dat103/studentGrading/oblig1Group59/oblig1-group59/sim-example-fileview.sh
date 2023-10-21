#!/bin/bash

# Regex mønster
#info_regex='T =[0-9]\+ Scheduled : T \([0 -9]\+\) Ready :\(\( ,* * T [0-9]\+\)*\)'
info_regex='T=[0-9]+ Scheduled: T([0-9]+) Ready:((,* *T[0-9]+)*)'

# Lag mappe om den ikke finns
mkdir -p example-process-view
mkdir -p compiled

# Fjern gamle log filer
rm -f example-process-view/T*-proc.log

# Kompilerer java prosjekt med avhengigheter til out mappen.
javac -cp ./src/main/java/HVL/Scheduler/*.java -d ./compiled/ ./src/main/java/HVL/Scheduler/SimulationExample.java

# Flytter oss til roten av java prosjektet
cd ./compiled

#Utfører simulasjonen og håndterer output
java HVL.Scheduler.SimulationExample | while IFS= read -r line; do
  # Check if the line matches the info_regex pattern
  if [[ $line =~ $info_regex ]]; then
    current_task="${BASH_REMATCH[1]}"
    ready_tasks="${BASH_REMATCH[2]}"

    # Create or append to the log file for the current task
    log_file="../example-process-view/T${current_task}-proc.log"
    echo "work" >> "$log_file"

    # Process the ready tasks to create log files for them
    for task in $ready_tasks; do
      if [[ $task =~ T([0-9]+) ]]; then
        ready_task="${BASH_REMATCH[1]}"
        log_file="../example-process-view/T${ready_task}-proc.log"
        echo "work" >> "$log_file"
      fi
    done
  fi
done

# Clean up the example-process-view directory from empty log files
find example-process-view -type f -size 0 -delete

echo "Simulation completed."
