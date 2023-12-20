class Task {
  final String creatorName;
  final String taskName;

  Task({
    required this.creatorName,
    required this.taskName,
  });
}

class Project {
  final String projectName;
  final List<Task> tasksList;

  Project({
    required this.projectName,
    required this.tasksList,
  });
}