package HVL.Scheduler;

import java.util.ArrayDeque;
import java.util.List;
import java.util.Optional;
import java.util.Queue;
import java.util.stream.Collectors;

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

    private void print() {
        if (selected != null) {
            System.out.print("Scheduled: T" + selected.getId());
        } else {
            System.out.print("Scheduled: null");
        }

        System.out.print(" Ready: ");
        if (!ready.isEmpty()) {
            System.out.print(
                    ready.stream().map(task -> "T" + task.getId()).collect(Collectors.joining(", "))
            );
        } else {
            System.out.print("Empty");
        }

        System.out.println();
    }



    @Override
    public void schedule() {
        if (selected == null && !ready.isEmpty()) {
            selected = ready.poll();
            selected.start();
            print();
        }

        if (selected != null && selected.isDone()) {
            selected.stop();
            selected = null;

            if (!ready.isEmpty()) {
                selected = ready.poll();
                selected.start();
                print();
            }
        }
    }





}
