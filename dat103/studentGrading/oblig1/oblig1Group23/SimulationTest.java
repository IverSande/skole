package HVL.Scheduler;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.BeforeEach;

import static org.hamcrest.MatcherAssert.assertThat;
import static org.hamcrest.Matchers.contains;

import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

class SimulationTest {

	Map<Integer, List<Task>> arrivals;
	Simulation simulation;

	@BeforeEach
	public void setUp() {
		simulation = new Simulation();
		arrivals   = Map.ofEntries(
				Map.entry(0,
				          List.of(simulation.makeTask(1),
				                  simulation.makeTask(2),
				                  simulation.makeTask(4),
				                  simulation.makeTask(6),
				                  simulation.makeTask(8))),
				Map.entry(11, List.of(simulation.makeTask(8),
				                      simulation.makeTask(6),
				                      simulation.makeTask(4),
				                      simulation.makeTask(2),
				                      simulation.makeTask(1))));

		simulation.setArrivals(arrivals);
	}

	@Test
	void testRR() {
		var rrScheduler = new RRScheduler(simulation.getClock(), 3);
		simulation.setScheduler(rrScheduler);

		var steps = Stream.generate(() -> {
			                  simulation.step();
			                  var state = "T=%d %s".formatted(simulation.time(), rrScheduler.view());
			                  simulation.clocktick();
			                  return state;
		                  })
		                  .limit(43)
		                  .collect(Collectors.toList());

		// Task 2: Write out expected view for 43 steps of Round Robin scheduling
		assertThat(steps, contains("T=0 Scheduled: T1 Ready: T2, T3, T4, T5",
		                           "T=1 Scheduled: T2 Ready: T3, T4, T5",       // T1 done
		                           "T=2 Scheduled: T2 Ready: T3, T4, T5",
		                           "T=3 Scheduled: T3 Ready: T4, T5",       // T2 done
		                           "T=4 Scheduled: T3 Ready: T4, T5",
		                           "T=5 Scheduled: T3 Ready: T4, T5",
		                           "T=6 Scheduled: T4 Ready: T5, T3",       // T3 1 left
		                           "T=7 Scheduled: T4 Ready: T5, T3",
		                           "T=8 Scheduled: T4 Ready: T5, T3",
		                           "T=9 Scheduled: T5 Ready: T3, T4",       // T4 3 left
		                           "T=10 Scheduled: T5 Ready: T3, T4",
		                           "T=11 Scheduled: T5 Ready: T3, T4, T6, T7, T8, T9, T10", // add time11 arrivals
		                           "T=12 Scheduled: T3 Ready: T4, T6, T7, T8, T9, T10, T5", // T5 5 left
		                           "T=13 Scheduled: T4 Ready: T6, T7, T8, T9, T10, T5",     // T3 done
		                           "T=14 Scheduled: T4 Ready: T6, T7, T8, T9, T10, T5",
		                           "T=15 Scheduled: T4 Ready: T6, T7, T8, T9, T10, T5",
		                           "T=16 Scheduled: T6 Ready: T7, T8, T9, T10, T5",     // T4 done
		                           "T=17 Scheduled: T6 Ready: T7, T8, T9, T10, T5",
		                           "T=18 Scheduled: T6 Ready: T7, T8, T9, T10, T5",
		                           "T=19 Scheduled: T7 Ready: T8, T9, T10, T5, T6",     // T6 5 left
		                           "T=20 Scheduled: T7 Ready: T8, T9, T10, T5, T6",
		                           "T=21 Scheduled: T7 Ready: T8, T9, T10, T5, T6",
		                           "T=22 Scheduled: T8 Ready: T9, T10, T5, T6, T7",     // T7 3 left
		                           "T=23 Scheduled: T8 Ready: T9, T10, T5, T6, T7",
		                           "T=24 Scheduled: T8 Ready: T9, T10, T5, T6, T7",
		                           "T=25 Scheduled: T9 Ready: T10, T5, T6, T7, T8",     // T8 1 left
		                           "T=26 Scheduled: T9 Ready: T10, T5, T6, T7, T8",
		                           "T=27 Scheduled: T10 Ready: T5, T6, T7, T8",     // T9 done
		                           "T=28 Scheduled: T5 Ready: T6, T7, T8",      // T10 done
		                           "T=29 Scheduled: T5 Ready: T6, T7, T8",
		                           "T=30 Scheduled: T5 Ready: T6, T7, T8",
		                           "T=31 Scheduled: T6 Ready: T7, T8, T5",      // T5 2 left
		                           "T=32 Scheduled: T6 Ready: T7, T8, T5",
		                           "T=33 Scheduled: T6 Ready: T7, T8, T5",
		                           "T=34 Scheduled: T7 Ready: T8, T5, T6",      // T6 2 left
		                           "T=35 Scheduled: T7 Ready: T8, T5, T6",
		                           "T=36 Scheduled: T7 Ready: T8, T5, T6",
		                           "T=37 Scheduled: T8 Ready: T5, T6",      // T7 done
		                           "T=38 Scheduled: T5 Ready: T6",      // T8 done
		                           "T=39 Scheduled: T5 Ready: T6",
		                           "T=40 Scheduled: T6 Ready: ",     // T5 done
		                           "T=41 Scheduled: T6 Ready: ",
		                           "T=42 Scheduled: Ready: "));      // T6 done
	}

	@Test
	void testFCFS() {
		var fcfsScheduler = new FCFSScheduler();
		simulation.setScheduler(fcfsScheduler);

		var steps = Stream.generate(() -> {
			                  simulation.step();
			                  var state = "T=%d %s".formatted(simulation.time(), fcfsScheduler.view());
			                  simulation.clocktick();
			                  return state;
		                  })
		                  .limit(43)
		                  .collect(Collectors.toList());

		// Provided for Task 0
		assertThat(steps, contains("T=0 Scheduled: T1 Ready: T2, T3, T4, T5",
		                           "T=1 Scheduled: T2 Ready: T3, T4, T5",
		                           "T=2 Scheduled: T2 Ready: T3, T4, T5",
		                           "T=3 Scheduled: T3 Ready: T4, T5",
		                           "T=4 Scheduled: T3 Ready: T4, T5",
		                           "T=5 Scheduled: T3 Ready: T4, T5",
		                           "T=6 Scheduled: T3 Ready: T4, T5",
		                           "T=7 Scheduled: T4 Ready: T5",
		                           "T=8 Scheduled: T4 Ready: T5",
		                           "T=9 Scheduled: T4 Ready: T5",
		                           "T=10 Scheduled: T4 Ready: T5",
		                           "T=11 Scheduled: T4 Ready: T5, T6, T7, T8, T9, T10",
		                           "T=12 Scheduled: T4 Ready: T5, T6, T7, T8, T9, T10",
		                           "T=13 Scheduled: T5 Ready: T6, T7, T8, T9, T10",
		                           "T=14 Scheduled: T5 Ready: T6, T7, T8, T9, T10",
		                           "T=15 Scheduled: T5 Ready: T6, T7, T8, T9, T10",
		                           "T=16 Scheduled: T5 Ready: T6, T7, T8, T9, T10",
		                           "T=17 Scheduled: T5 Ready: T6, T7, T8, T9, T10",
		                           "T=18 Scheduled: T5 Ready: T6, T7, T8, T9, T10",
		                           "T=19 Scheduled: T5 Ready: T6, T7, T8, T9, T10",
		                           "T=20 Scheduled: T5 Ready: T6, T7, T8, T9, T10",
		                           "T=21 Scheduled: T6 Ready: T7, T8, T9, T10",
		                           "T=22 Scheduled: T6 Ready: T7, T8, T9, T10",
		                           "T=23 Scheduled: T6 Ready: T7, T8, T9, T10",
		                           "T=24 Scheduled: T6 Ready: T7, T8, T9, T10",
		                           "T=25 Scheduled: T6 Ready: T7, T8, T9, T10",
		                           "T=26 Scheduled: T6 Ready: T7, T8, T9, T10",
		                           "T=27 Scheduled: T6 Ready: T7, T8, T9, T10",
		                           "T=28 Scheduled: T6 Ready: T7, T8, T9, T10",
		                           "T=29 Scheduled: T7 Ready: T8, T9, T10",
		                           "T=30 Scheduled: T7 Ready: T8, T9, T10",
		                           "T=31 Scheduled: T7 Ready: T8, T9, T10",
		                           "T=32 Scheduled: T7 Ready: T8, T9, T10",
		                           "T=33 Scheduled: T7 Ready: T8, T9, T10",
		                           "T=34 Scheduled: T7 Ready: T8, T9, T10",
		                           "T=35 Scheduled: T8 Ready: T9, T10",
		                           "T=36 Scheduled: T8 Ready: T9, T10",
		                           "T=37 Scheduled: T8 Ready: T9, T10",
		                           "T=38 Scheduled: T8 Ready: T9, T10",
		                           "T=39 Scheduled: T9 Ready: T10",
		                           "T=40 Scheduled: T9 Ready: T10",
		                           "T=41 Scheduled: T10 Ready: ",
		                           "T=42 Scheduled: Ready: "));
	}
}
