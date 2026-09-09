// dashboard_counts.dart
class DashboardCounts {
  final int total;
  final int assigned;
  final int accepted;
  final int inProgress;
  final int completed;

  DashboardCounts({
    required this.total,
    required this.assigned,
    required this.accepted,
    required this.inProgress,
    required this.completed,
  });

  factory DashboardCounts.fromJson(Map<String, dynamic> json) {
    return DashboardCounts(
      total: int.tryParse(json['total'].toString()) ?? 0,
      assigned: int.tryParse(json['assigned'].toString()) ?? 0,
      accepted: int.tryParse(json['accepted'].toString()) ?? 0,
      inProgress:
          int.tryParse(
            json['in_progress']?.toString() ??
                json['inProgress']?.toString() ??
                '0',
          ) ??
          0,
      completed: int.tryParse(json['completed'].toString()) ?? 0,
    );
  }

  /// Empty/default counts, useful as an initial value before the
  /// dashboard endpoint has loaded.
  factory DashboardCounts.empty() {
    return DashboardCounts(
      total: 0,
      assigned: 0,
      accepted: 0,
      inProgress: 0,
      completed: 0,
    );
  }
}
