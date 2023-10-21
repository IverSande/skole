#!/bin/bash

# Regex mønster
#info_regex='T =[0-9]\+ Scheduled : T \([0 -9]\+\) Ready :\(\( ,* * T [0-9]\+\)*\)'
info_regex='T=[0-9]+ Scheduled: T([0-9]+) Ready:((,* *T[0-9]+)*)'

# Lag mappe om den ikke finns
mkdir -p example-process-view


# Fjern gamle log filer
rm -f example-process-view/T*-proc.log



#Utfører simulasjonen og håndterer output
./gradlew build
java -cp build/classes/java/main HVL.Scheduler.SimulationExample | while IFS= read -r line; do
  # Check if the line matches the info_regex pattern
  if [[ $line =~ $info_regex ]]; then
    current_task="${BASH_REMATCH[1]}"
    ready_tasks="${BASH_REMATCH[2]}"

    # Opprett eller legg til log filen for gjeldende oppgave
    log_file="./example-process-view/T${current_task}-proc.log"
    echo "work" >> "$log_file"

    # Behandle de klare oppgavene for å lage loggfiler for dem
    for task in $ready_tasks; do
      if [[ $task =~ T([0-9]+) ]]; then
        ready_task="${BASH_REMATCH[1]}"
        log_file="./example-process-view/T${ready_task}-proc.log"
        echo "work" >> "$log_file"
      fi
    done
  fi
done

# Rydd opp i eksempel-prosess-visning mappa fra tomme loggfiler
find example-process-view -type f -size 0 -delete

echo "Simulation completed."
