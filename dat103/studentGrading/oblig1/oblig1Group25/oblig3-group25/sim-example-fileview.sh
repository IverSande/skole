#!/bin/bash

#delete folder and create a new one
rm -rf example-process-view
mkdir example-process-view

#execute the file
info_regex='T=[0-9]\+ Scheduled: T\([0-9]\+\) Ready:\(\(,* *T[0-9]\+\)*\)'

./gradlew run -q | while read -r line; do
    T=$(echo "$line" | sed -n "s/$info_regex/\1/p")
    echo work >> "example-process-view/T$T-proc.log"
done
