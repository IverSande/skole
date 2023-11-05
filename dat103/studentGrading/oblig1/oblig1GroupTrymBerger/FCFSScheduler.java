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
    	selected = ready.poll();  // Poll the first process in the ready queue
    	  if (selected == null) {
    	      return;  // If there's no process to execute, simply return
    	  }
    	   selected.start();  // Start the selected process
    	  } else {
    	 // Check if the process is complete
    	    if (selected.isDone()) {
    	        selected.stop();  // Stop the process
    	        selected = null;  // Set selected to null for the next iteration
    	        schedule();   // Recursive call to check the next process in the queue
    	        }
    	       
    	    }	
    	
    }

}
