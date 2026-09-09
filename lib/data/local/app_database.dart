import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/tasks_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Tasks])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'user_task_flow'));

  @override
  int get schemaVersion => 1;

  // =====================================
  // GET ALL TASKS
  // =====================================

  Future<List<Task>> getAllTasks() {
    return select(tasks).get();
  }

  // =====================================
  // GET TASK BY ID
  // =====================================

  Future<Task?> getTaskById(int id) {
    return (select(tasks)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // =====================================
  // INSERT / UPDATE TASK
  // =====================================

  Future<void> insertOrUpdateTask(TasksCompanion task) {
    return into(tasks).insertOnConflictUpdate(task);
  }

  // =====================================
  // GET PENDING TASKS
  // =====================================

  Future<List<Task>> getPendingTasks() {
    return (select(
      tasks,
    )..where((tbl) => tbl.syncStatus.equals('Pending'))).get();
  }

  // =====================================
  // UPDATE SYNC STATUS
  // =====================================

  Future<void> updateSyncStatus(int id, String syncStatus) {
    return (update(tasks)..where((tbl) => tbl.id.equals(id))).write(
      TasksCompanion(syncStatus: Value(syncStatus)),
    );
  }

  // =====================================
  // UPDATE TASK LOCALLY
  // =====================================

  Future<void> updateTaskLocally({
    required int taskId,
    required String status,
    required String syncStatus,
    double? startLatitude,
    double? startLongitude,
    double? completionLatitude,
    double? completionLongitude,
    String? notes,
    bool? customerConfirmed,
  }) async {
    final companion = TasksCompanion(
      status: Value(status),
      syncStatus: Value(syncStatus),

      /// Start location
      startLatitude: startLatitude != null
          ? Value(startLatitude)
          : const Value.absent(),

      startLongitude: startLongitude != null
          ? Value(startLongitude)
          : const Value.absent(),

      /// Completion location
      completionLatitude: completionLatitude != null
          ? Value(completionLatitude)
          : const Value.absent(),

      completionLongitude: completionLongitude != null
          ? Value(completionLongitude)
          : const Value.absent(),

      /// Notes
      notes: notes != null ? Value(notes) : const Value.absent(),

      /// Customer confirmation
      customerConfirmed: customerConfirmed != null
          ? Value(customerConfirmed)
          : const Value.absent(),
    );

    await (update(
      tasks,
    )..where((tbl) => tbl.id.equals(taskId))).write(companion);
  }

  Future<void> clearAllData() async {
    await delete(tasks).go();
  }
}
