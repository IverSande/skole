package HVL.Scheduler;

import java.util.*;
import java.util.function.IntSupplier;

public class RRScheduler implements Scheduler {

    private Queue<Task> ready;
    private final int limit;
    private Task selected;
    private IntSupplier time;
    private int timestamp;

    RRScheduler(IntSupplier time, int limit) {
        this.ready = new ArrayDeque<>();
        this.time = time;
        this.limit = limit;
        this.selected = null;
        this.timestamp = 0;
    }

    @Override
    public Optional<Integer> scheduled() {
        if(selected == null) return Optional.empty();
        return Optional.of(selected.getId());
    }

    public @Override List<Integer> ready() {
        return ready.stream().map((Task t)-> t.getId()).toList();
    }


    @Override
    public void addTask(Task task) {
        ready.add(task);
    }

    @Override
    public void schedule() {
        if(selected == null) {
            selected = ready.poll();
            if(selected == null) {
                return;
            }
            selected.start();
            timestamp = time.getAsInt();
        } else {
            // Complete:
            if (selected.isDone()) {
                selected.stop();
                selected = null;
                schedule();
            // More left
            } else {
                int now = time.getAsInt();
                if(now - timestamp >= limit){
                    ready.add(selected);
                    selected = null;
                    schedule();
                }
            }
        }
    }
}
