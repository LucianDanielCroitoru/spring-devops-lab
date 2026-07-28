package ro.lucian.springdevopslab.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ro.lucian.springdevopslab.model.Task;

public interface TaskRepository extends JpaRepository<Task, Long> {
}