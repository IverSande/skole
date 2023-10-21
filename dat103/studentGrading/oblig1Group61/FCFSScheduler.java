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
        if (this.selected == null) {
            // gets next task and assignes to currently scheduled.
            this.selected = this.ready.poll();

            // if we don't have a next scheduled task end scheduling.
            if (this.selected == null) {
                return;
            }

            // start currently scheduled task.
            this.selected.start();
        } else if (this.selected.isDone()) {
            this.selected.stop();
            this.selected = null;

            this.schedule();
        }
    }

}
