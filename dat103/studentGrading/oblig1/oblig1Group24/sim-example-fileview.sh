#!/bin/bash

#Vi begynner med å slette 'gammel moro'
rm -rfd "example-process-view"
#Så lager vi en ny example-process-view' mappe
mkdir "example-process-view"

#regex som gitt i oppgaven. Identifiserer reelle 'utskriftslinjer'
info_regex='T=([0-9]+) Scheduled: T([0-9]+) Ready:((,* *T[0-9]+)*)'

#Her kjøres SimulationExample.java via ./gradlew run. Outputen til programmet pipes til en while loop som tar for seg linjene. 
#Linjene mellomlagres i variabel 'line'. 
./gradlew run | while read -r line; do

	#Vi er bare interessert i slike linjer som matcher regexen
	#Hver iterasjon av while løkken hvis følgende betingelse tilfredstilles svarer til 1 tidsintervall av CPU'en  
	if [[ $line =~ $info_regex ]]; then
	
		#prosessen som innehar cpu i gjeldende tidsintervall
		current_tsk="${BASH_REMATCH[2]}"
		#en tekststreng som inneholder en kommaseparert liste over prosesser i readyqueue
		ready_queue="${BASH_REMATCH[3]}"
		
		#Her itererer vi over en array hvis elementer er prosessnavn til prosessene i readyqueue
		IFS=', '
		read -ra prosesser <<< "$ready_queue"
		for item in "${prosesser[@]}"; do
		
			#Hvert element gir opphav til et filnavn for en ny fil som representerer prosessen
			#Hvis filen finnes fra før, så legges ingenting til takket være -n
			echo -n >> "example-process-view/${item}-proc.log"
		done
		
		#Til slutt legges linjen 'work' til i filen til prosessen som er scheduled i denne iterasjonen av loopen / for denne tidsenheten av CPU burst tid.
		#Hvis filen ikke finnes fra før, så lages den. 
		echo "work" >> "example-process-view/T${current_tsk}-proc.log"
	fi
done
