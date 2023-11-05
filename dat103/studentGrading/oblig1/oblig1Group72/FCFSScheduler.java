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
	
	// Metoden kaller seg selv helt til ready queuen er tom
	// Den utføres med hensyn til FCFS prinsippet 

	if (selected == null && !ready.isEmpty()) {
	    selected = ready.poll();
	    selected.start();
	} else if (selected != null && selected.isDone()) {
	    selected.stop();
            selected = null;
	    schedule();
	}
    }

}
