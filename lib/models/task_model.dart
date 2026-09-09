// task_model.dart
class TaskModel {
  final int id;

  final String customerName;
  final String customerPhone;

  final String serviceType;
  final String priority;

  final DateTime dateTime;
  final String address;

  final String status;
  final String? notes;

  final double? customerLatitude;
  final double? customerLongitude;

  final double? startLatitude;
  final double? startLongitude;

  final double? completionLatitude;
  final double? completionLongitude;

  final bool customerConfirmed;

  final String syncStatus;

  const TaskModel({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.serviceType,
    required this.priority,
    required this.dateTime,
    required this.address,
    required this.status,
    this.notes,
    this.customerLatitude,
    this.customerLongitude,
    this.startLatitude,
    this.startLongitude,
    this.completionLatitude,
    this.completionLongitude,
    required this.customerConfirmed,
    required this.syncStatus,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      customerName: json['customer_name'],
      customerPhone: json['customer_phone'],
      serviceType: json['service_type'],
      priority: json['priority'],
      dateTime: DateTime.parse(json['date_time']),
      address: json['address'],
      status: json['status'],
      notes: json['notes'],
      customerLatitude: json['customer_latitude'] != null
          ? double.tryParse(json['customer_latitude'].toString())
          : null,
      customerLongitude: json['customer_longitude'] != null
          ? double.tryParse(json['customer_longitude'].toString())
          : null,
      startLatitude: json['start_latitude'] != null
          ? double.tryParse(json['start_latitude'].toString())
          : null,
      startLongitude: json['start_longitude'] != null
          ? double.tryParse(json['start_longitude'].toString())
          : null,
      completionLatitude: json['completion_latitude'] != null
          ? double.tryParse(json['completion_latitude'].toString())
          : null,
      completionLongitude: json['completion_longitude'] != null
          ? double.tryParse(json['completion_longitude'].toString())
          : null,
      customerConfirmed:
          json['customer_confirmed'] == true || json['customer_confirmed'] == 1,
      syncStatus: json['sync_status'] ?? 'Synced',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'service_type': serviceType,
      'priority': priority,
      'date_time': dateTime.toIso8601String(),
      'address': address,
      'status': status,
      'notes': notes,
      'customer_latitude': customerLatitude,
      'customer_longitude': customerLongitude,
      'start_latitude': startLatitude,
      'start_longitude': startLongitude,
      'completion_latitude': completionLatitude,
      'completion_longitude': completionLongitude,
      'customer_confirmed': customerConfirmed,
      'sync_status': syncStatus,
    };
  }
}
