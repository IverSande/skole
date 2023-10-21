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
        if (selected == null) return Optional.empty();
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
        //TODO Task 1: Complete the implementation of First Come First Serve scheduling
        //Should be correct. Funny since this was the first thing i tried with this task
        if ( selected == null) { // do not use !ready.isEmpty() &&
            selected = ready.poll();
            if (selected == null) {
                return;
            }
            selected.start();
        } else {
            if (selected.isDone()) {
                selected.stop();
                selected = null;
                schedule();
            }
            //Faild attempts:
//        for (Task task : ready) { //wtf was i doing here
//            ready.add(ready.poll());
//        }
//        while (!ready.isEmpty()) { //Wtf was i doing here
//            if (ready.peek().isDone()) {
//                ready.poll();
//            } else {
//                selected = ready.peek();
//                selected.start();
//                break;
//            }
//            ready.add(ready.poll());
//        }
            /*
             * Should probably be correct, but not working with the test.
             * Updade when i tested it now it did not work properly cause it has some errors
             */

//        if (!ready.isEmpty() && selected == null) { //error here: The error is !ready.isEmpty()
//            selected = ready.poll();
//            if (selected == null) {
//                return;
//            }
//            selected.start();
//        } else {
//            if (ready.isEmpty()) { // error here
//                selected.stop();
//                selected = null;
//                schedule();
//            }
//        }
        }

    }

}
