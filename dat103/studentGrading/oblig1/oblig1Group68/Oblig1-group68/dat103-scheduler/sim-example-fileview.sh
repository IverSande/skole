#!/bin/bash/env bash
# Path: dat103-scheduler/sim-example-fileview.sh



if [[ -d "./example-process-view" ]]; then
  echo "Directory example-process-view exists. Continuing..."
  echo "Cleaning up old files"
  rm -r example-process-view/* 2>/dev/null
else
  mkdir ./example-process-view
  echo "Directory example-process-view created"
fi

#Clean up and run
info_regex='T=[0-9]+ Scheduled: T([0-9]+) Ready:((,* T[0-9]+))'
./gradlew run | while IFS= read -r line; do
  echo $line
  if [[ $line =~ $info_regex ]]; then
    filename="T${BASH_REMATCH[1]}-proc.log"
    if [ ! -e "./example-process-view/$filename" ]; then
      touch "./example-process-view/$filename"
    fi
    echo "Work" >> "./example-process-view/$filename"
  fi
done

#Hvis man skal ha det samlet i en log fil:

#if [[ -d "./example-process-view" ]]; then
#  echo "Directory example-process-view exists. Continuing..."
#  echo "Cleaning up old files"
#  rm -r example-process-view/* 2>/dev/null
#else
#  mkdir ./example-process-view
#  echo "Directory example-process-view created"
#fi

#Create single log file
#log_file="./example-process-view/combined.log"
#touch "$log_file"

#clean up and run
#info_regex='T=[0-9]+ Scheduled: T([0-9]+) Ready:((,* T[0-9]+))'
#./gradlew run | while IFS= read -r line; do
#  echo $line
#  if [[ $line =~ $info_regex ]]; then
#    echo "Work for T${BASH_REMATCH[1]}" >> "$log_file"
#  fi
#done