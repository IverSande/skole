#!/bin/bash

#Sletter gammel directory og oppretter på nytt 
rm -r example-process-view
mkdir example-process-view

info_regex='T=[0-9]+ Scheduled: T([0-9]+) Ready:((,* *T[0-9]+)*)'

append_work() {
	echo "work" >> "example-process-view/T${prosess}-proc.log"
}

#Executes SimulationExample.java
./gradlew -q run | while read -r linesOutput

do
  prosess=$(echo $linesOutput | sed -E "s/$info_regex/\1/")
  readyQueue=$(echo $linesOutput | sed -E "s/$info_regex/\2/")
  fileName=$(echo "example-process-view/T$prosess-proc.log")
  if [[ ! -e $fileName ]]; then
    touch $fileName
  fi
  append_work
done

