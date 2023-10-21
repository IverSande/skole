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
        // Sjekker om det ikke er noen aktiv prosess for øyeblikket
        if (selected == null) {
            // Dersom ingen prosesser er valgt, forsøker den å hente den første prosessen i køen
            selected = ready.poll();
            // Dersom det ikke er flere prosesser i køen -> avslutt metode
            if (selected == null) {
                return;
            }
            // Starter den valgte prosessen
            selected.start();
        } else {
            // Complete: 
            // Sjekker om den valgte prosessen er ferdig
            if (selected.isDone()) {
                // Stopper den valgte prosessen
                selected.stop();
                // Setter den valgte prosessen til null for å indikere at den er ferdig
                selected = null;
                // Kaller schedule()-metoden på nytt for å velge en ny prosess til å kjøre
                schedule();
            }
        }
    }


}
