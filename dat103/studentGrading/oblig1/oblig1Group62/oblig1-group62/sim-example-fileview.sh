#!/bin/bash

# Kjør SimulationExample.java programmet og behandle output
info_regex="T=\([0-9]\+\) Scheduled: T\([0-9]\+\) Ready:\(\(, T[0-9]\+\)*\)"

# Opprett en mappe for prosess-logger hvis den ikke finnes
mkdir -p example-process-view

# Fjern gamle filer fra forrige kjøring
rm -f example-process-view/T*-proc.log

# Kjør SimulationExample.java og behandle hver linje av output
java -cp /root/dat103-scheduler/build/classes/java/main HVL.Scheduler.SimulationExample 2>&1 | while read -r line
do
	    echo "Leser linje: $line"
	        
	        # Bruk regex til å trekke ut relevant informasjon fra linjen
		    scheduled_task=$(echo "$line" | sed -n "s/$info_regex/\1/p")
		        ready_tasks=$(echo "$line" | sed -n "s/$info_regex/\2/p" | sed -e 's/ *T\([0-9]\+\),*/\1 /g')
			    
			    echo "Planlagt oppgave: $scheduled_task"
			        echo "Klare oppgaver: $ready_tasks"

				    # Oppdater .log filer
				        if [[ ! -z $scheduled_task ]]; then
						        echo "Skriver til logg for T$scheduled_task..."
							        echo "work" >> "example-process-view/T$scheduled_task-proc.log"
								    fi
								        
								        for task in $ready_tasks; do
										        echo "Oppretter/Toucher logg for T$task..."
											        touch "example-process-view/T$task-proc.log"
												    done
											    done
