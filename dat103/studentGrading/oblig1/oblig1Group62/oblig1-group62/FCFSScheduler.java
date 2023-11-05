package HVL.Scheduler;

import java.util.ArrayDeque;
import java.util.List;
import java.util.Optional;
import java.util.Queue;

public class FCFSScheduler implements Scheduler {

    private final Queue<Task> ready;
    private Task selected;

    FCFSScheduler() {
        this.ready = new ArrayDeque<>();
    }

    @Override
    public Optional<Integer> scheduled() {
        if(selected == null) return Optional.empty();
        return Optional.of(selected.getId());
    }

    @Override
    public List<Integer> ready() {
        return ready.stream().map(Task::getId).toList();
    }

    @Override
    public void addTask(Task task) {
        ready.add(task);
    }

    
    @Override
    public void schedule() {
        // Hvis den nåværende oppgaven er ferdig, eller det ikke kjører noen oppgave, hent den neste oppgaven
	if (selected == null || selected.isDone()) {
		selected = ready.poll(); // Hent ut og fjern den neste oppgaven fra køen
	}

	// Hvis det er en oppgve å kjøre, utfør den i en tidsenhet
	if (selected != null) {
		selected.start(); //Starte oppgaven
	}
    }

}
