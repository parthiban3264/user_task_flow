// task_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_task_flow/views/task/task_detail_screen.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_loading.dart';
import '../../core/widgets/custom_snack_bar.dart';
import '../../data/local/app_database.dart';
import '../../view_models/task/task_bloc.dart';
import '../../view_models/task/task_event.dart';
import '../../view_models/task/task_state.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  String selectedFilter = 'All';

  final List<String> filters = [
    'All',
    'Assigned',
    'Accepted',
    'In Progress',
    'Completed',
  ];

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTasks());
  }

  List<Task> _applyFilter(List<Task> tasks) {
    if (selectedFilter == 'All') {
      return tasks;
    }

    return tasks.where((task) => task.status == selectedFilter).toList();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'Assigned':
        return const Color(0xFF6D5DFB);

      case 'Accepted':
        return const Color(0xFFF59E0B);

      case 'In Progress':
        return const Color(0xFF2196F3);

      case 'Completed':
        return const Color(0xFF22A06B);

      default:
        return Colors.grey;
    }
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return const Color(0xFFDC2626);

      case 'Medium':
        return const Color(0xFFF59E0B);

      case 'Low':
        return const Color(0xFF22A06B);

      default:
        return Colors.grey;
    }
  }

  String _formatDate(DateTime dateTime) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${dateTime.day} ${months[dateTime.month - 1]} ${dateTime.year}';
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;
    return '$displayHour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF7F8FA),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,

        title: const Text(
          'My Tasks',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1D2A32),
          ),
        ),

        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: IconButton(
              onPressed: () {
                context.read<TaskBloc>().add(LoadTasks());

                CustomSnackBar.show(
                  context,
                  message: 'Refreshing ...',
                  type: SnackBarType.success,
                  duration: Duration(milliseconds: 1000),
                );
              },
              icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
            ),
          ),
        ],
      ),

      body: BlocBuilder<TaskBloc, TaskState>(
        builder: (context, state) {
          /// INITIAL / LOADING
          if (state is TaskInitial || state is TaskLoading) {
            return const CustomLoading();
          }

          /// ERROR
          if (state is TaskError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 50, color: Colors.red),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(state.message, textAlign: TextAlign.center),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<TaskBloc>().add(LoadTasks());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          /// LOADED
          if (state is TaskLoaded) {
            final allTasks = state.tasks;
            final filteredTasks = _applyFilter(allTasks);

            final hasUnsynced = allTasks.any(
              (t) => t.syncStatus == 'Pending' || t.syncStatus == 'Failed',
            );

            return RefreshIndicator(
              onRefresh: () async {
                context.read<TaskBloc>().add(LoadTasks());
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: Column(
                children: [
                  /// TASK SUMMARY
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Row(
                      children: [
                        Text(
                          '${filteredTasks.length} Tasks',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),

                        const Spacer(),

                        Icon(
                          hasUnsynced
                              ? Icons.sync_problem_rounded
                              : Icons.sync_rounded,
                          size: 16,
                          color: hasUnsynced
                              ? const Color(0xFFF59E0B)
                              : const Color(0xFF22A06B),
                        ),

                        const SizedBox(width: 4),

                        Text(
                          hasUnsynced ? 'Pending Sync' : 'Synced',
                          style: TextStyle(
                            fontSize: 12,
                            color: hasUnsynced
                                ? const Color(0xFFF59E0B)
                                : const Color(0xFF22A06B),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// FILTER
                  SizedBox(
                    height: 40,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: filters.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        final filter = filters[index];
                        final isSelected = selectedFilter == filter;

                        return InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            setState(() {
                              selectedFilter = filter;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : const Color(0xFFE5E7EB),
                              ),
                            ),
                            child: Text(
                              filter,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : const Color(0xFF6B7280),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// TASK LIST
                  Expanded(
                    child: filteredTasks.isEmpty
                        ? ListView(
                            // ListView (not just Center) so pull-to-refresh
                            // still works when the filtered list is empty.
                            children: const [
                              SizedBox(height: 120),
                              Center(child: Text('No tasks found')),
                            ],
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 110),
                            itemCount: filteredTasks.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final task = filteredTasks[index];

                              return _TaskCard(
                                customerName: task.customerName,
                                phone: task.customerPhone,
                                service: task.serviceType,
                                priority: task.priority,
                                date: _formatDate(task.taskDateTime),
                                time: _formatTime(task.taskDateTime),
                                address: task.address,
                                status: task.status,
                                statusColor: getStatusColor(task.status),
                                priorityColor: getPriorityColor(task.priority),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          TaskDetailScreen(taskId: task.id),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          }

          return const CustomLoading();
        },
      ),
    );
  }
}

class _TaskCard extends StatelessWidget {
  final String customerName;
  final String phone;
  final String service;
  final String priority;
  final String date;
  final String time;
  final String address;
  final String status;

  final Color statusColor;
  final Color priorityColor;

  final VoidCallback onTap;

  const _TaskCard({
    required this.customerName,
    required this.phone,
    required this.service,
    required this.priority,
    required this.date,
    required this.time,
    required this.address,
    required this.status,
    required this.statusColor,
    required this.priorityColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),

      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),

        child: Container(
          padding: const EdgeInsets.all(16),

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// NAME + STATUS
              Row(
                children: [
                  Container(
                    height: 44,
                    width: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.person_outline_rounded,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customerName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1D2A32),
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          phone,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: statusColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              const Divider(height: 1, color: Color(0xFFF0F1F3)),

              const SizedBox(height: 14),

              /// SERVICE
              _InfoRow(icon: Icons.build_outlined, text: service),

              const SizedBox(height: 10),

              /// DATE & TIME
              _InfoRow(
                icon: Icons.calendar_today_outlined,
                text: '$date • $time',
              ),

              const SizedBox(height: 10),

              /// ADDRESS
              _InfoRow(icon: Icons.location_on_outlined, text: address),

              const SizedBox(height: 16),

              /// PRIORITY + VIEW
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: priorityColor.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$priority Priority',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: priorityColor,
                      ),
                    ),
                  ),

                  const Spacer(),

                  Row(
                    children: const [
                      Text(
                        'View Details',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(width: 4),

                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 13,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: const Color(0xFF6B7280)),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 13, color: Color(0xFF4B5563)),
          ),
        ),
      ],
    );
  }
}
