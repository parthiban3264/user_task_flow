// task_event.dart
abstract class TaskEvent {}

class LoadTasks extends TaskEvent {}

class AcceptTaskEvent extends TaskEvent {
  final int taskId;

  AcceptTaskEvent(this.taskId);
}

class StartTaskEvent extends TaskEvent {
  final int taskId;
  final double latitude;
  final double longitude;

  StartTaskEvent({
    required this.taskId,
    required this.latitude,
    required this.longitude,
  });
}

class CompleteTaskEvent extends TaskEvent {
  final int taskId;

  final String notes;

  final double latitude;
  final double longitude;

  final bool customerConfirmed;

  CompleteTaskEvent({
    required this.taskId,
    required this.notes,
    required this.latitude,
    required this.longitude,
    required this.customerConfirmed,
  });
}

class SyncTasksEvent extends TaskEvent {}

/// Load dashboard counts
class LoadDashboardData extends TaskEvent {}
