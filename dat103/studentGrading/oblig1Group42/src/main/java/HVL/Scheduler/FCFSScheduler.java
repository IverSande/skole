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
        // If there is a selected task and it is not finished, we leave it as is.
        if(selected != null && !selected.isDone()) {
            return;
        }
        
        // If the selected task is finished or if there is no selected task, 
        // we select the next task in the queue if available.
        selected = ready.poll(); // This will return and remove the head of the queue (or return null if the queue is empty).
        
        // If there is a newly selected task, we start it.
        if(selected != null) {
            selected.start();
        }
    }


}
