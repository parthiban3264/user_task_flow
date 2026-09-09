// home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_task_flow/core/widgets/custom_loading.dart';

import '../../core/constants/app_colors.dart';
import '../../core/storage/flutter_secure_storage.dart';
import '../../core/widgets/custom_snack_bar.dart';
import '../../core/widgets/stats_card.dart';
import '../../data/local/app_database.dart';
import '../../view_models/auth/auth_bloc.dart';
import '../../view_models/auth/auth_event.dart';
import '../../view_models/auth/auth_state.dart';
import '../../view_models/task/task_bloc.dart';
import '../../view_models/task/task_event.dart';
import '../../view_models/task/task_state.dart';
import 'widgets/recent_task_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadUser();
    context.read<TaskBloc>().add(LoadTasks());
  }

  String _userName = "";

  Future<void> _loadUser() async {
    final user = await TokenStorage.getUser();

    if (!mounted) return;

    setState(() {
      _userName = user?['name']?.toString() ?? '';
    });
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    }

    return 'Good Evening';
  }

  /// =====================================
  /// REFRESH (app bar action)
  /// =====================================
  void _handleRefresh() {
    context.read<TaskBloc>().add(LoadTasks());

    CustomSnackBar.show(
      context,
      message: 'Refreshing ...',
      type: SnackBarType.success,
      duration: Duration(milliseconds: 1000),
    );
  }

  /// =====================================
  /// LOGOUT CONFIRMATION DIALOG
  /// =====================================
  Future<void> _handleLogoutTap() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: const Text('Are you sure you want to logout?'),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF6B7280)),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      _performLogout();
    }
  }

  void _performLogout() {
    context.read<AuthBloc>().add(LogoutRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is LogoutSuccess) {
          // Login screen-க்கு navigate
          Navigator.of(
            context,
          ).pushNamedAndRemoveUntil('/login', (route) => false);
        }

        if (state is AuthError) {
          CustomSnackBar.show(
            context,
            message: state.msg,
            type: SnackBarType.error,
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FA),

        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(76),

          child: SafeArea(
            bottom: false,

            child: Container(
              color: const Color(0xFFF7F8FA),

              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),

              child: Row(
                children: [
                  Container(
                    height: 46,
                    width: 46,

                    decoration: BoxDecoration(
                      color: AppColors.primary,

                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: const Icon(
                      Icons.assignment_rounded,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,

                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        Text(
                          '${_getGreeting()} 👋',

                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF4C4E51),
                          ),
                        ),

                        const SizedBox(height: 3),

                        Text(
                          _userName, // real name

                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1D2A32),
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: _handleRefresh,
                    tooltip: 'Refresh',
                    icon: const Icon(
                      Icons.refresh_rounded,
                      color: Color(0xFF4C4E51),
                    ),
                  ),

                  IconButton(
                    onPressed: _handleLogoutTap,
                    tooltip: 'Logout',
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: Color(0xFFDC2626),
                    ),
                  ),
                ],
              ),
            ),
          ),
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
                    const Icon(
                      Icons.error_outline,
                      size: 50,
                      color: Colors.red,
                    ),

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
              final counts = state.dashboardCounts;

              final todayTasks = _getTodayTasks(state.tasks);

              return RefreshIndicator(
                onRefresh: () async {
                  context.read<TaskBloc>().add(LoadTasks());

                  await Future.delayed(const Duration(milliseconds: 500));
                },

                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),

                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),

                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          /// TITLE
                          const Text(
                            'Task Overview',

                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1D2A32),
                            ),
                          ),

                          const SizedBox(height: 4),

                          const Text(
                            'Here is your task summary',

                            style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFF6B7280),
                            ),
                          ),

                          const SizedBox(height: 16),

                          /// STATS
                          SizedBox(
                            height: 170,

                            child: ListView(
                              scrollDirection: Axis.horizontal,

                              children: [
                                StatsCard(
                                  title: 'Assigned',

                                  value: counts.assigned.toString(),

                                  icon: Icons.assignment_outlined,

                                  iconColor: const Color(0xFF6D5DFB),

                                  percentage: '',

                                  isIncrease: true,

                                  chartData: [
                                    1,
                                    2,
                                    3,
                                    counts.assigned.toDouble(),
                                  ],
                                ),

                                const SizedBox(width: 12),

                                StatsCard(
                                  title: 'Accepted',

                                  value: counts.accepted.toString(),

                                  icon: Icons.task_alt_rounded,

                                  iconColor: const Color(0xFFF59E0B),

                                  percentage: '',

                                  isIncrease: true,

                                  chartData: [1, 2, counts.accepted.toDouble()],
                                ),

                                const SizedBox(width: 12),

                                StatsCard(
                                  title: 'In Progress',

                                  value: counts.inProgress.toString(),

                                  icon: Icons.sync_rounded,

                                  iconColor: const Color(0xFF2196F3),

                                  percentage: '',

                                  isIncrease: true,

                                  chartData: [1, counts.inProgress.toDouble()],
                                ),

                                const SizedBox(width: 12),

                                StatsCard(
                                  title: 'Completed',

                                  value: counts.completed.toString(),

                                  icon: Icons.check_circle_outline_rounded,

                                  iconColor: const Color(0xFF22A06B),

                                  percentage: '',

                                  isIncrease: true,

                                  chartData: [
                                    1,
                                    3,
                                    counts.completed.toDouble(),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 28),

                          /// TODAY TITLE
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,

                            children: [
                              const Text(
                                "Today's Tasks",

                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1D2A32),
                                ),
                              ),

                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${todayTasks.length} Tasks',

                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          /// TODAY'S TASKS CARD BLOCK
                          if (todayTasks.isEmpty)
                            _buildEmptyTodayState()
                          else
                            Column(
                              children: List.generate(todayTasks.length, (
                                index,
                              ) {
                                final task = todayTasks[index];
                                final isLast = index == todayTasks.length - 1;

                                return Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 2,
                                        vertical: 4,
                                      ),
                                      child: RecentTaskCard(
                                        customerName: task.customerName,
                                        serviceType: task.serviceType,
                                        time: _formatTime(task.taskDateTime),
                                        status: task.status,
                                        priority: task.priority,
                                      ),
                                    ),
                                    if (!isLast)
                                      const Divider(
                                        height: 1,
                                        thickness: 1,
                                        indent: 12,
                                        endIndent: 12,
                                        color: Color(0xFFF0F1F3),
                                      ),
                                  ],
                                );
                              }),
                            ),
                        ]),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const CustomLoading();
          },
        ),
      ),
    );
  }

  /// =====================================
  /// EMPTY STATE for Today's Tasks
  /// =====================================
  Widget _buildEmptyTodayState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.event_available_rounded,
              size: 32,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'No tasks scheduled for today',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Color(0xFF1D2A32),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Enjoy the break, or check back later.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
          ),
        ],
      ),
    );
  }

  /// GET TODAY TASKS
  List<Task> _getTodayTasks(List<Task> tasks) {
    final now = DateTime.now();

    return tasks.where((task) {
      final taskDate = task.taskDateTime;

      return taskDate.year == now.year &&
          taskDate.month == now.month &&
          taskDate.day == now.day;
    }).toList();
  }

  /// FORMAT TIME
  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute.toString().padLeft(2, '0');

    final period = hour >= 12 ? 'PM' : 'AM';

    final displayHour = hour % 12 == 0 ? 12 : hour % 12;

    return '$displayHour:$minute $period';
  }
}
