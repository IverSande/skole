package HVL.Scheduler;

public interface Task {
    int getId();
    boolean isDone();
    void start();
    void stop();

}
