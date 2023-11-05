#!/bin/bash


rm -r example-process-view
mkdir example-process-view

info_regex='T=[0-9]\+ Scheduled: T\([0-9]\+\) Ready:\(\(,* *T[0-9]\+\)*\)'





./gradlew run -q --console plain | \
sed -r 's/T=[0-9]+ Scheduled: T([0-9]+) Ready:((,* *T[0-9]+)*)/\1/' | \
while read LES; do 
echo work  >> example-process-view/T${LES}-proc.log ; 
done;






#./gradlew run -q --console plain  | while read TID JUNK1 TASK JUNK2; do 
#echo work  >> example-process-view/${TASK}-proc.log ; 
#done;




