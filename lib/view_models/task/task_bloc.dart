// task_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/dashboard_counts.dart';
import '../../repositories/task_repository.dart';

import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final TaskRepository repository;

  TaskBloc(this.repository) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);

    on<AcceptTaskEvent>(_onAcceptTask);

    on<StartTaskEvent>(_onStartTask);

    on<CompleteTaskEvent>(_onCompleteTask);

    on<SyncTasksEvent>(_onSyncTasks);

    on<LoadDashboardData>(_onLoadDashboardData);
  }

  /// =====================================
  /// LOAD TASKS
  /// =====================================

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    emit(TaskLoading());

    try {
      final tasks = await repository.getTasks();
      final dashboardCounts = await repository.getDashboardCounts();

      emit(TaskLoaded(tasks: tasks, dashboardCounts: dashboardCounts));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  /// =====================================
  /// ACCEPT TASK
  /// =====================================

  Future<void> _onAcceptTask(
    AcceptTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await repository.acceptTask(event.taskId);

      final tasks = await repository.getTasks();
      final dashboardCounts = await repository.getDashboardCounts();

      emit(TaskLoaded(tasks: tasks, dashboardCounts: dashboardCounts));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  /// =====================================
  /// START TASK
  /// =====================================

  Future<void> _onStartTask(
    StartTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await repository.startTask(
        taskId: event.taskId,
        latitude: event.latitude,
        longitude: event.longitude,
      );

      final tasks = await repository.getTasks();
      final dashboardCounts = await repository.getDashboardCounts();

      emit(TaskLoaded(tasks: tasks, dashboardCounts: dashboardCounts));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  /// =====================================
  /// COMPLETE TASK
  /// =====================================

  Future<void> _onCompleteTask(
    CompleteTaskEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await repository.completeTask(
        taskId: event.taskId,
        notes: event.notes,
        latitude: event.latitude,
        longitude: event.longitude,
        customerConfirmed: event.customerConfirmed,
      );

      final tasks = await repository.getTasks();
      final dashboardCounts = await repository.getDashboardCounts();

      emit(TaskLoaded(tasks: tasks, dashboardCounts: dashboardCounts));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  /// =====================================
  /// SYNC
  /// =====================================

  Future<void> _onSyncTasks(
    SyncTasksEvent event,
    Emitter<TaskState> emit,
  ) async {
    try {
      await repository.syncPendingTasks();

      final tasks = await repository.getTasks();
      final dashboardCounts = await repository.getDashboardCounts();

      emit(TaskLoaded(tasks: tasks, dashboardCounts: dashboardCounts));
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }

  /// =====================================
  /// LOAD DASHBOARD DATA
  /// =====================================

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<TaskState> emit,
  ) async {
    try {
      final DashboardCounts counts = await repository.getDashboardCounts();

      emit(
        DashboardLoaded(
          total: counts.total,
          assigned: counts.assigned,
          accepted: counts.accepted,
          inProgress: counts.inProgress,
          completed: counts.completed,
        ),
      );
    } catch (e) {
      emit(TaskError(e.toString()));
    }
  }
}
