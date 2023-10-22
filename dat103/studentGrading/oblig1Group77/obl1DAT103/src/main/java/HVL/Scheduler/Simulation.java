package HVL.Scheduler;

import java.util.List;
import java.util.function.IntSupplier;
import java.util.Map;

public class Simulation {
	private int time;
	Map<Integer, List<Task>> arrivals;
	Scheduler                scheduler;
	private int idn = 1;
	Runnable updateRunningTask;

	Simulation() {
		this.time = 0;
	}

	public void setArrivals(Map<Integer, List<Task>> arrivals) {
		this.arrivals = arrivals;
	}

	Task makeTask(int size) {
		return new Task() {
			private final int id = idn++;
			private int remaining = size;

			@Override
			public int getId() {
				return id;
			}

			@Override
			public boolean isDone() {
				return remaining == 0;
			}

			@Override
			public void start() {
				Simulation.this.updateRunningTask = this::update;
			}

			@Override
			public void stop() {
				Simulation.this.updateRunningTask = null;
			}

			public void update() {
				remaining--;
			}
		};
	}

	public void setScheduler(Scheduler scheduler) {
		this.scheduler = scheduler;
	}

	public IntSupplier getClock() {
		return this::time;
	}

	public int time() {
		return time;
	}

	public void clocktick() {
		time++;
		if (updateRunningTask != null) {
			updateRunningTask.run();
		}
	}

	public void step() {
		var arrived = arrivals.get(time);
		if (arrived != null) {
			for (var arrival : arrived) {
				scheduler.addTask(arrival);
			}
		}
		scheduler.schedule();
	}

	public void run(int ticks) {
		while (time <= ticks) {
			step();
		}

	}
}
