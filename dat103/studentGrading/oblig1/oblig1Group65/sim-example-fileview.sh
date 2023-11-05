info_regex='T=[0-9]\+ Scheduled: T\([0-9]\+\) Ready: \(\(,* *T[0-9]\+\)*\)'

mkdir -p example-process-view

rm -f example-process-view/*.log

./gradlew run -q | while read -r line; do
 
    current_task=$(sed "s/$info_regex/\1/" <<< $line)
    echo "Working on:" $current_task
    ready_tasks=$(sed "s/$info_regex/\2/" <<< $line)
    echo "In ready queue:" $ready_tasks

    echo "work" >> "example-process-view/T${current_task}-proc.log"
   
    for task in $ready_tasks; do
      task_number=$(echo "$task" | sed 's/ *T\([0-9]\),*\+/\1/')
      touch "example-process-view/${task_number}-proc.log"
    done
done

