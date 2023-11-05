#!/usr/bin/env bash

# Directory path
dir="./example-process-view"

if [[ -d "$dir" ]]; then
  echo "The '$dir' directory already exists. Removing old log files..."
  rm "$dir"/* > /dev/null
else
  mkdir "$dir"
  echo "Created '$dir' directory."
fi

info_regex='T=([0-9]+) Scheduled: T([0-9]+) Ready: (T[0-9]+(, T[0-9]+)*)?'

./gradlew run | while IFS= read -r line; do
  echo "$line"
  if [[ $line =~ $info_regex ]]; then
    filename="T${BASH_REMATCH[2]}-proc.log"
    log_file="$dir/$filename"
    touch "$log_file"
    echo "work" >> "$log_file"
  fi
done
