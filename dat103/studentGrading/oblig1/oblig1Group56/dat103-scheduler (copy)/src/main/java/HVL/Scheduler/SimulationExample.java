package HVL.Scheduler;

import java.util.List;
import java.util.Map;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;
import java.util.stream.Stream;

public class SimulationExample {

    Map<Integer, List<Task>> arrivals;
    Simulation simulation;

    public void setUp() {
        simulation = new Simulation();
        arrivals = Map.ofEntries(
                Map.entry(0, List.of(
                        simulation.makeTask(1),
                        simulation.makeTask(2),
                        simulation.makeTask(4),
                        simulation.makeTask(5))),
                Map.entry(4,List.of(
                        simulation.makeTask(6),
                        simulation.makeTask(2),
                        simulation.makeTask(2))),
                Map.entry(16,List.of(
                        simulation.makeTask(4),
                        simulation.makeTask(1))));

        simulation.setArrivals(arrivals);
    }

    public static void main(String[] args) throws InterruptedException {
        var example = new SimulationExample();
        example.setUp();
        example.simulation.setScheduler(
            new RRScheduler(example.simulation.getClock(),3));

        do {
            example.simulation.step();
            var state = "T=%d %s".formatted(
                           example.simulation.time()
                            , example.simulation.scheduler.view() );
            example.simulation.clocktick();
            System.out.println(state);
            TimeUnit.SECONDS.sleep(1);
        } while (example.simulation.scheduler.ready().size()>0);
    }
}
