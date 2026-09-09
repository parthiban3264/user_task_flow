import 'package:drift/drift.dart';

import '../core/utils/error_handler.dart';
import '../data/local/app_database.dart';
import '../models/dashboard_counts.dart';
import '../models/task_model.dart';
import '../services/connectivity_service.dart';
import '../services/task_service.dart';

class TaskRepository {
  final AppDatabase database;
  final TaskApiService apiService;
  final ConnectivityService connectivityService;

  TaskRepository({
    required this.database,
    required this.apiService,
    required this.connectivityService,
  });

  // =====================================
  // GET TASKS
  // =====================================

  Future<List<Task>> getTasks() async {
    try {
      final isOnline = await connectivityService.isOnline;

      /// OFFLINE → LOCAL DATABASE
      if (!isOnline) {
        return await database.getAllTasks();
      }

      try {
        /// ONLINE → FETCH API
        final apiTasks = await apiService.getAllTasks();

        for (final apiTask in apiTasks) {
          final localTask = await database.getTaskById(apiTask.id);

          /// Don't overwrite pending local changes
          if (localTask != null && localTask.syncStatus == 'Pending') {
            continue;
          }

          /// Save API response locally
          await _saveTaskLocally(apiTask, syncStatus: 'Synced');
        }

        /// UI always reads from local DB
        return await database.getAllTasks();
      } catch (_) {
        /// API FAILED → LOCAL DATABASE
        return await database.getAllTasks();
      }
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // =====================================
  // GET DASHBOARD COUNTS
  // =====================================

  Future<DashboardCounts> getDashboardCounts() async {
    try {
      final tasks = await database.getAllTasks();

      int assigned = 0;
      int accepted = 0;
      int inProgress = 0;
      int completed = 0;

      for (final task in tasks) {
        switch (task.status) {
          case 'Assigned':
            assigned++;
            break;

          case 'Accepted':
            accepted++;
            break;

          case 'In Progress':
            inProgress++;
            break;

          case 'Completed':
            completed++;
            break;
        }
      }

      return DashboardCounts(
        total: tasks.length,
        assigned: assigned,
        accepted: accepted,
        inProgress: inProgress,
        completed: completed,
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // =====================================
  // ACCEPT TASK
  // =====================================

  Future<void> acceptTask(int taskId) async {
    try {
      final task = await database.getTaskById(taskId);

      if (task == null) {
        throw Exception('Task not found');
      }

      final isOnline = await connectivityService.isOnline;

      /// ONLINE
      if (isOnline) {
        try {
          final updatedTask = await apiService.acceptTask(taskId);

          await _saveTaskLocally(updatedTask, syncStatus: 'Synced');

          return;
        } catch (_) {
          /// API FAILED
          /// Continue to local fallback
        }
      }

      /// OFFLINE / API FAILED
      await database.updateTaskLocally(
        taskId: taskId,
        status: 'Accepted',
        syncStatus: 'Pending',
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // =====================================
  // START TASK
  // =====================================

  Future<void> startTask({
    required int taskId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final task = await database.getTaskById(taskId);

      if (task == null) {
        throw Exception('Task not found');
      }

      final isOnline = await connectivityService.isOnline;

      /// ONLINE
      if (isOnline) {
        try {
          final updatedTask = await apiService.startTask(
            taskId: taskId,
            latitude: latitude,
            longitude: longitude,
          );

          await _saveTaskLocally(updatedTask, syncStatus: 'Synced');

          return;
        } catch (_) {
          /// API FAILED
          /// Continue to local fallback
        }
      }

      /// OFFLINE / API FAILED
      await database.updateTaskLocally(
        taskId: taskId,
        status: 'In Progress',
        startLatitude: latitude,
        startLongitude: longitude,
        syncStatus: 'Pending',
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // =====================================
  // COMPLETE TASK
  // =====================================

  Future<void> completeTask({
    required int taskId,
    required String notes,
    required double latitude,
    required double longitude,
    required bool customerConfirmed,
  }) async {
    try {
      final task = await database.getTaskById(taskId);

      if (task == null) {
        throw Exception('Task not found');
      }

      final isOnline = await connectivityService.isOnline;

      /// ONLINE
      if (isOnline) {
        try {
          final updatedTask = await apiService.completeTask(
            taskId: taskId,
            notes: notes,
            latitude: latitude,
            longitude: longitude,
            customerConfirmed: customerConfirmed,
          );

          await _saveTaskLocally(updatedTask, syncStatus: 'Synced');

          return;
        } catch (_) {
          /// API FAILED
          /// Continue to local fallback
        }
      }

      /// OFFLINE / API FAILED
      await database.updateTaskLocally(
        taskId: taskId,
        status: 'Completed',
        notes: notes,
        completionLatitude: latitude,
        completionLongitude: longitude,
        customerConfirmed: customerConfirmed,
        syncStatus: 'Pending',
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // =====================================
  // SYNC PENDING TASKS
  // =====================================

  Future<void> syncPendingTasks() async {
    try {
      final isOnline = await connectivityService.isOnline;

      /// No network
      if (!isOnline) {
        return;
      }

      final pendingTasks = await database.getPendingTasks();

      for (final task in pendingTasks) {
        try {
          await apiService.syncTask(task.id, {
            'status': task.status,
            'notes': task.notes,
            'start_latitude': task.startLatitude,
            'start_longitude': task.startLongitude,
            'completion_latitude': task.completionLatitude,
            'completion_longitude': task.completionLongitude,
            'customer_confirmed': task.customerConfirmed,
          });

          /// SUCCESS
          await database.updateSyncStatus(task.id, 'Synced');
        } catch (_) {
          /// IMPORTANT:
          /// Keep Pending for next retry
          await database.updateSyncStatus(task.id, 'Pending');
        }
      }
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  // =====================================
  // SAVE API TASK LOCALLY
  // =====================================

  Future<void> _saveTaskLocally(
    TaskModel task, {
    required String syncStatus,
  }) async {
    try {
      await database.insertOrUpdateTask(
        TasksCompanion(
          id: Value(task.id),

          customerName: Value(task.customerName),

          customerPhone: Value(task.customerPhone),

          serviceType: Value(task.serviceType),

          priority: Value(task.priority),

          taskDateTime: Value(task.dateTime),

          address: Value(task.address),

          status: Value(task.status),

          notes: Value(task.notes),

          customerLatitude: Value(task.customerLatitude),

          customerLongitude: Value(task.customerLongitude),

          startLatitude: Value(task.startLatitude),

          startLongitude: Value(task.startLongitude),

          completionLatitude: Value(task.completionLatitude),

          completionLongitude: Value(task.completionLongitude),

          customerConfirmed: Value(task.customerConfirmed),

          syncStatus: Value(syncStatus),
        ),
      );
    } catch (e) {
      throw ErrorHandler.handle(e);
    }
  }
}
