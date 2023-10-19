package HVL.Scheduler;

import java.util.ArrayDeque;
import java.util.List;
import java.util.Optional;
import java.util.Queue;

public class FCFSScheduler implements Scheduler {

	private final Queue<Task> ready;
	private       Task        selected;

	FCFSScheduler() {
		this.ready = new ArrayDeque<>();
	}

	@Override
	public Optional<Integer> scheduled() {
        if (selected == null) {
            return Optional.empty();
        }
		return Optional.of(selected.getId());
	}

	@Override
	public List<Integer> ready() {
		return ready.stream()
		            .map(Task::getId)
		            .toList();
	}

	@Override
	public void addTask(Task task) {
		ready.add(task);
	}


	@Override
	public void schedule() {
		if (selected == null) {
			// hvis vi ikke jobber med en prosess atm
			selected = ready.poll();
			if (selected == null) {
				// hvis det ikke er flere prosesser igjen å kjøre i køen
				return;
			}
			selected.start();
		} else {
			// hvis vi jobber med en prosess
			if (selected.isDone()) {
				// hvis prosessen er ferdig så stopper vi den og scheduler en ny
				selected.stop();
				selected = null;
				schedule();
			}
		}
	}

}
