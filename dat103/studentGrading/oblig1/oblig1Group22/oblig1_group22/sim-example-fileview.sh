#!/bin/bash


#sørge for at vi er på riktig plass, må byttes til der filen ligger i innlevering
cd /Users/kaspar/Desktop/2023H/dat103/dat103-scheduler || exit

./gradlew build


info_regex='T=[0-9]+ Scheduled: T([0-9]+) Ready:((,* *T[0-9]+)*)'

# Directory for .log filene
process_view_dir="example-process-view"

# Sørger for at directory finnes
if [ -d "$process_view_dir" ]; then
    rm -rf "$process_view_dir"
fi
mkdir -p "$process_view_dir"
# sjekker at prosjektet ble bygget skikkelig
if [ $? -eq 0 ]; then

  echo "Build successful. Continuing "

 # mkdir example-process-view

  ./gradlew run | while IFS= read -r line; do
                     # Finner den riktige informasjonen
                     value=$(echo "$line" | sed -E -n "s/$info_regex/\1/p")
                  #   process=$(echo "$line" | sed -E -n "s/$process_regex/\1/p")

                     if [ -n "$value" ]; then
                         # Lager fil og legger den på riktig plass
                         filename="$process_view_dir/T$value-proc.log"
                         touch "$filename"

                         # Legger til "work"
                         echo "work" >> "$filename"
                         echo "Created and appended to $filename"
                     fi
done

else
  echo "Build failed. Check your Gradle project setup."
fi


