import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class RecentTaskCard extends StatelessWidget {
  final String customerName;
  final String serviceType;
  final String time;
  final String status;
  final String priority;

  const RecentTaskCard({
    super.key,
    required this.customerName,
    required this.serviceType,
    required this.time,
    required this.status,
    required this.priority,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(status);
    final priorityColor = _priorityColor(priority);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFEAECEF)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// SERVICE ICON
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              _serviceIcon(serviceType),
              color: AppColors.primary,
              size: 23,
            ),
          ),

          const SizedBox(width: 12),

          /// TASK DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// CUSTOMER + STATUS
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        customerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1D2A32),
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    _StatusBadge(status: status, color: statusColor),
                  ],
                ),

                const SizedBox(height: 5),

                /// SERVICE TYPE
                Text(
                  serviceType,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    color: Color(0xFF6B7280),
                  ),
                ),

                const SizedBox(height: 10),

                /// TIME + PRIORITY
                Row(
                  children: [
                    Icon(
                      Icons.schedule_outlined,
                      size: 15,
                      color: const Color(0xFF9CA3AF),
                    ),

                    const SizedBox(width: 4),

                    Expanded(
                      child: Text(
                        time,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: priorityColor.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.flag_outlined,
                            size: 12,
                            color: priorityColor,
                          ),

                          const SizedBox(width: 4),

                          Text(
                            priority,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: priorityColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _serviceIcon(String serviceType) {
    final service = serviceType.toLowerCase();

    if (service.contains('repair')) {
      return Icons.handyman_outlined;
    }

    if (service.contains('electric')) {
      return Icons.electrical_services_outlined;
    }

    if (service.contains('plumb')) {
      return Icons.plumbing_outlined;
    }

    if (service.contains('clean')) {
      return Icons.cleaning_services_outlined;
    }

    if (service.contains('install')) {
      return Icons.settings_outlined;
    }

    return Icons.build_outlined;
  }

  Color _statusColor(String status) {
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
        return const Color(0xFF9CA3AF);
    }
  }

  Color _priorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return const Color(0xFFEF4444);

      case 'medium':
        return const Color(0xFFF59E0B);

      case 'low':
        return const Color(0xFF22A06B);

      default:
        return const Color(0xFF6B7280);
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  final Color color;

  const _StatusBadge({required this.status, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
