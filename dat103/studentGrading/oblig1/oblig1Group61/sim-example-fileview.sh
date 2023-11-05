#!/bin/bash

#Variables
info_regex='T=[0-9]+ Scheduled: T([0-9]+) Ready:((,* T[0-9]+))';
task_regex='T[0-9]+';

#Build with Gradle
./gradlew build

#Resets log
rm -rf './example-process-view'
mkdir -p './example-process-view'

#Code for logging runtime of scheduler to files
java -cp build/classes/java/main HVL.Scheduler.SimulationExample | while read -r line
do
  if [[ $line =~ $info_regex ]]; then
    currentTask="${BASH_REMATCH[1]}"
    readyTasks="${BASH_REMATCH[2]}"
    currentFile="./example-process-view/T${currentTask}-proc.log";

    # checks if file exist if not make
    if [ ! -f "$currentFile" ]; then
      touch "$currentFile";
    fi;

    echo "work" >> "$currentFile";

    while read -ra task; do
      if [[ $task =~ $task_regex ]]; then
        readyTask="${BASH_REMATCH[1]}";
        readyFile="./example-process-view/T${readyTask}-proc.log";

        # checks if file exist if not make
        if [ ! -f "$readyFile" ]; then
            touch "$readyFile";
        fi;
        echo "work" >> "$readyFile";
        echo "$readyFile";
      fi
    done < "$readyTasks";
  fi
done
