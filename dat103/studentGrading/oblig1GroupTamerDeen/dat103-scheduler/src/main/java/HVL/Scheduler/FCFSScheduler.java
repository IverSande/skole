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

		// Task 1: Complete the implementation of First Come First Serve scheduling
		// if the queue is not empty, select the first task in the queue
		if (selected == null) {
            
            selected = ready.poll();
            if (selected == null) {
                //  if there are no more processes to run
                return;
            }
            selected.start();
        } else {
            
            if (selected.isDone()) {
                // if the process is done, we stop it and schedule a new one
                selected.stop();
                selected = null;
                schedule();
            }
        }
}

}

