#!/bin/bash

# Definering av det regulære uttrykket for å matche linjer med ønsket informasjon
info_regex='T=[0-9]+ Scheduled: T([0-9]+) Ready:((,* T[0-9]+)) '

# Oppretter example-process-view-mappen dersom den ikke eksisterer
if [ ! -d "example-process-view" ]; then
    mkdir example-process-view
fi

# Sletter tidligere loggfiler i mappen
rm -f example-process-view/*.log

# Henter ut data ved å kjøre 'gradlew run' og fanger opp linjene som skriver til standard utgang
./gradlew run -q | while IFS= read -r line; do
  echo "$line"
    # Sjekker om linjen samsvarer med vårt definerte regulære uttrykk
    if [[ $line =~ $info_regex ]]; then
        # Deklarerer variabler for gjeldende oppgave og liste over klare oppgaver fra linjen
        current_task="${BASH_REMATCH[1]}"
        ready_tasks="${BASH_REMATCH[2]}"
        
        # Skriver ut den gjeldene oppgaven og listen over klare oppgaver
        echo "${BASH_REMATCH[1]}"
        echo "${BASH_REMATCH[2]}"
        echo "$line"
        
        # Prosesserer listen over klare oppgaver ved å bruke sed for å trekke ut tallene (T[0-9]) 
        # og utføre en handling for hver oppgave
        echo "$ready_tasks" | sed -E 's/ *T([0-9]),*/\1/' | while read -r task; do
            # Legger til en linje som indikerer at oppgaven arbeider (work) i den tilsvarende loggfilen
            echo "work" >> "example-process-view/T${current_task}-proc.log"
        done
    fi
done




