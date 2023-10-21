#!/bin/bash

process_view_dir="example-process-view"


mkdir -p "$process_view_dir"


rm -f "$process_view_dir"/*.log

info_regex='T=[0-9]+ Scheduled: T([0-9]+) Ready:((,* *T[0-9]+)*)'
task_regex=' *T([0-9]),*'

./gradlew run -q | while read -r line; do

  if [[ "$line" =~ T=([0-9]+) ]]; then
    current_task=$(echo "$line" | sed -E "s/$info_regex/\1/")
   
    touch "$process_view_dir/T${current_task}-proc.log"

    while read -r subline; do
      if [[ "$subline" =~ T([0-9]+) ]]; then
        task_num="${BASH_REMATCH[1]}"
        echo "$subline" | sed -E "s/$task_regex/\1/"
         echo "Work" >> "$process_view_dir/T${task_num}-proc.log"
      fi
    done
  fi
done


# gradle build -q | while read -r line; do

  #if [[ "$line" =~ T=([0-9]+) ]]; then
   # current_task="${BASH_REMATCH[1]}"

   # touch "$process_view_dir/T${current_task}-proc.log"

   # while read -r subline; do
   #   if [[ "$subline" =~ T([0-9]+) ]]; then
   #     task_num="${BASH_REMATCH[1]}"
    #    echo "work" >> "$process_view_dir/T${task_num}-proc.log"
    #  fi
    #done
  #fi
#done