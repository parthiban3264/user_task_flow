import '../../data/local/app_database.dart';
import '../../models/dashboard_counts.dart';

abstract class TaskState {}

class TaskInitial extends TaskState {}

class TaskLoading extends TaskState {}

class TaskLoaded extends TaskState {
  final List<Task> tasks;
  final DashboardCounts dashboardCounts;

  TaskLoaded({required this.tasks, required this.dashboardCounts});
}

class TaskActionLoading extends TaskState {}

class TaskError extends TaskState {
  final String message;

  TaskError(this.message);
}

class DashboardLoaded extends TaskState {
  final int total;
  final int assigned;
  final int accepted;
  final int inProgress;
  final int completed;

  DashboardLoaded({
    required this.total,
    required this.assigned,
    required this.accepted,
    required this.inProgress,
    required this.completed,
  });
}
