#!/bin/bash

mkdir -p example-process-view
rm -f example-process-view/*-proc.log

info_regex='T=[0-9]\+ Scheduled: T\([0-9]\+\) Ready:\(\(,* *T[0-9]\+\)*\)'

chmod +x ./gradlew

echo "vent..."

./gradlew run | while read -r inputRow; do
    scheduledTask=$(echo "$inputRow" | sed -n "s/$info_regex/\1/p")
    ready_tasks=$(echo "$inputRow" | sed -n "s/$info_regex/\2/p")

   if [[ ! -z "$scheduledTask" ]]; then
        echo "work" >> example-process-view/T${scheduledTask}-proc.log
   fi

   for currentTask in $(echo "$ready_tasks" | sed 's/ *T\([0-9]\+\),*/\1 /g'); do
        touch example-process-view/T${currentTask}-proc.log
   done
done

echo "ferdig"
