package HVL.Scheduler;
import java.util.List;
import java.util.Optional;

public interface  Scheduler {

  void schedule();
  void addTask(Task task);

  Optional<Integer> scheduled();
  List<Integer> ready();

  default String view(){
    StringBuilder out = new StringBuilder();
    out.append("Scheduled: ");
    if(scheduled().isPresent()) {
      out.append("T%d ".formatted(scheduled().get()));
    }
    var ids = ready().iterator();
    out.append("Ready: ");
    while(ids.hasNext()) {
      var id = ids.next();
      out.append("T%d".formatted(id));
      if(ids.hasNext()) out.append(", ");
    }
    return out.toString();
  }


}
