import '../../models/task_model.dart';
import '../core/network/dio_client.dart';
import '../core/storage/flutter_secure_storage.dart';

class TaskApiService {
  TaskApiService();

  /// GET ALL TASKS
  Future<List<TaskModel>> getAllTasks() async {
    final user = await TokenStorage.getUser();

    if (user == null || user['id'] == null) {
      throw Exception('User ID not found');
    }
    final userId = user['id'];
    final response = await DioClient.dio.get('api/tasks/$userId');

    final List data = response.data['data'];

    return data.map((item) => TaskModel.fromJson(item)).toList();
  }

  /// ACCEPT TASK
  Future<TaskModel> acceptTask(int taskId) async {
    final response = await DioClient.dio.patch('api/tasks/$taskId/accept');

    return TaskModel.fromJson(response.data['data']);
  }

  /// START TASK
  Future<TaskModel> startTask({
    required int taskId,
    required double latitude,
    required double longitude,
  }) async {
    final response = await DioClient.dio.patch(
      'api/tasks/$taskId/start',
      data: {'latitude': latitude, 'longitude': longitude},
    );

    return TaskModel.fromJson(response.data['data']);
  }

  /// COMPLETE TASK
  Future<TaskModel> completeTask({
    required int taskId,
    required String notes,
    required double latitude,
    required double longitude,
    required bool customerConfirmed,
  }) async {
    final response = await DioClient.dio.patch(
      'api/tasks/$taskId/complete',
      data: {
        'notes': notes,
        'latitude': latitude,
        'longitude': longitude,
        'customer_confirmed': customerConfirmed,
      },
    );

    return TaskModel.fromJson(response.data['data']);
  }

  /// GENERIC SYNC UPDATE
  Future<void> syncTask(int taskId, Map<String, dynamic> data) async {
    await DioClient.dio.put('api/tasks/$taskId', data: data);
  }
}
