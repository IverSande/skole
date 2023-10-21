#!/bin/bash

chmod +x ./gradlew

# Cleanup_old_logs
mkdir -p example-process-view

# Create directory example-process-view
rm -f example-process-view/*-proc.log

# Parse output and create log
info_regex='T=[0-9]\+ Scheduled: T\([0-9]\+\) Ready:\(\(,* *T[0-9]\+\)*\)'

echo "What is the music of life?..."

./gradlew run | awk -v info_regex="$info_regex" '
{
    if ($0 ~ info_regex) {
        scheduledTask = gensub(info_regex, "\\1", "g")
        readyTasks = gensub(info_regex, "\\2", "g")

        if (scheduledTask != "") {
            print "work" >> "example-process-view/T" scheduledTask "-proc.log"
        }
        split(readyTasks, readyArr, / *, *T/)
        for (i = 1; i <= length(readyArr); i++) {
            if (readyArr[i] != "") {
                task = substr(readyArr[i], 1, index(readyArr[i], ",") - 1)
                touchCmd = "touch example-process-view/T" task "-proc.log"
                system(touchCmd)
            }
        }
    }
}
'
echo "silence, my brother. welcome home"