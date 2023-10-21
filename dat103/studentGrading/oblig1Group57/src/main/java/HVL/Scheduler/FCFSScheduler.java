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
        // If there is no task selected, select the first task from the ready queue.
        if (selected == null) {
            selected = ready.poll();
        }

        // If there is a selected task, start it.
        if (selected != null) {
            selected.start();
        }

        // If the selected task is done, remove it from the selected task and schedule the next task.
        if (selected != null && selected.isDone()) {
            selected = null;
            schedule();
        }
	
    }

}
