#!/bin/bash
mkdir -p example-process-view
rm example-process-view/*
info_regex='T=[0-9]\+ Scheduled: T\([0-9]\+\) Ready:\(\(,* *T[0-9]\+\)*\)'
tall_regex='^[0-9]+$'
./gradlew run | while IFS= read -r line; do
    scheduled=$(echo "$line" | sed -n "s/$info_regex/\1/p")
    if [[ $scheduled =~ $tall_regex ]]; then
  	readystring=$(echo "$line" | sed "s/$info_regex/\2/p")
 	IFS=', ' read -r -a ready <<< "$readystring"
	for task in "${ready[@]}"; do
	    touch example-process-view/"$task"-proc.log
	done
        echo "work" >> example-process-view/T"$scheduled"-proc.log
    fi
done
