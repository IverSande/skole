LOGDIR=example-process-view

# Remove contents of log-folder if it exists
if [ -d "$LOGDIR" ]; then
	rm -Rf $LOGDIR;
fi

# Make sure log-folder exists
mkdir -p $LOGDIR

# Used to parse output from java program
info_regex='T=[0-9]\+ Scheduled: T\([0-9]\+\) Ready:\(\(,* *T[0-9]\+\)*\)'

# Iterate over output from java program
gradle run -q | while read -r line; do
	
	# Parse the id of the current ready tasks 
	readynrs=($(echo $line | sed "s/$info_regex/\2/" | sed 's/[^0-9]/ /g'))
	
	# Loop over the array of current ready tasks
	for n in "${readynrs[@]}"; do
   	 	echo "" > $LOGDIR/T$n-proc.log
	done
	
	# Parse the current scheduled taks
	scheduled=$(echo $line | sed "s/$info_regex/\1/" | sed 's/[^0-9]//g')
	
	# Write "work" into the file corresponing to the current scheduled task
	echo "work" > $LOGDIR/T$scheduled-proc.log
done