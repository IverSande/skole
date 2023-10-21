#!/bin/bash
# Desc: Kjører simuleringen og lagrer output i filer

log_directory="./example-process-view"
info_regex='T=([0-9]+) Scheduled: T([0-9]+) Ready: (T[0-9]+(, T[0-9]+)*)?'

# lag log directory og sjekk om den eksisterer
if [ -d "$log_directory" ]; then
  rm -f "$log_directory"/*
else
  mkdir -p "$log_directory"
  echo "Created $log_directory directory."
fi

# Kjør simuleringen og lagre output i log_directory
./gradlew run | while IFS= read -r line; do
  echo "$line"
  if [[ $line =~ $info_regex ]]; then
    log_file="$log_directory/T${BASH_REMATCH[2]}-proc.log"
    touch "$log_file"
    echo "work" >> "$log_file"
  fi
done



