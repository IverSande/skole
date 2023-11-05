new_dir="example-process-view"
info_regex=' T =[0 -9]\+ Scheduled : T \([0 -9]\+\) Ready :\(\( ,* * T [0 -9]\+\)*\) '
# Fjerner filer i "example-process-view" om den eksisterer
if [ -d "$new_dir" ]; then
	rm -rf "$new_dir"
fi

mkdir "$new_dir"

java SimulationExample | while read -r line; do
	if [[ "$line" =~ info_regex ]]; then
		scheduled="${BASH_REMATCH[1]}"
		ready="${BASH_REMATCH[2]}"
		ready_numbers=$(echo "$ready" | sed -n -e "s/ *T\([0-9]\),*\+/\1/gp")
		log_fil="example-process-view/T${scheduled}-proc.log"
		for task in $ready_numbers; do
			echo "work" >> "$log_fil"
		done
	fi
done
