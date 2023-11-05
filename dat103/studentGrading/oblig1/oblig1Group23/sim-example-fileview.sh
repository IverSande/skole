#!/usr/bin/env bash

if [[ -d "./example-process-view" ]]; then
  echo "example-process-view directory exists, continuing..." 
  echo "removing old existing log files..."
  # trenger ikke se output fra rm kommando, sender stdout til /dev/null
  rm ./example-process-view/* > /dev/null
else 
  mkdir ./example-process-view
  echo "Created example-process-view directory."
fi

info_regex='T=([0-9]+) Scheduled: T([0-9]+) Ready: (T[0-9]+(, T[0-9]+)*)?'
./gradlew run | while IFS= read -r line; do
  echo $line 
  if [[ $line =~ $info_regex ]]; then
    # BASH_REMATCH er en innebygget variabel som blir oppdatert med matchede
    # grupper fra REGEX matching med innebygget [[ string =~ regex_pattern ]]
    # metode for regex matching.
    # regex pattern måtte omskrives for å fungere med denne regex matcheren
    # fikk ikke de oppgitte sed kommandoene og regex patterns til å funke, 
    # så måtte bruke et annet alternativ
    filename="T${BASH_REMATCH[2]}-proc.log"
    echo "$filename"
    if [ ! -e ./example-process-view/$filename ]; then
      touch "./example-process-view/$filename"
    fi
    echo "work" >> ./example-process-view/$filename
  fi
done 

