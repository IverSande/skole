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
        if (selected == null) {
            // If no task is currently executing, select the next task from the ready queue
            selected = ready.poll(); // FCFS: Get the first task that arrived
            if (selected != null) {
                selected.start(); // Start the selected task
            }
        } else {
            // Task is already executing, check for completion
            if (selected.isDone()) {
                selected.stop(); // Stop the completed task
                selected = null;  // Set selected to null to indicate no task is executing
                
                // After a task completes, if there are more tasks in the ready queue, select the next one
                if (!ready.isEmpty()) {
                    selected = ready.poll();
                    selected.start();
                }
            }
        }
	// Task 1: Complete the implementation of First Come First Serve scheduling
	
    }

}
