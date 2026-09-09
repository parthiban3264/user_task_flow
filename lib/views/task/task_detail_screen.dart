// task_detail_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_snack_bar.dart';
import '../../data/local/app_database.dart';
import '../../view_models/task/task_bloc.dart';
import '../../view_models/task/task_event.dart';
import '../../view_models/task/task_state.dart';

class TaskDetailScreen extends StatefulWidget {
  final int taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final TextEditingController notesController = TextEditingController();

  bool customerConfirmed = false;
  bool isSubmitting = false;

  final ImagePicker _imagePicker = ImagePicker();

  final List<XFile> images = [];

  @override
  void dispose() {
    notesController.dispose();
    super.dispose();
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

  /// phone call function
  Future<void> _callCustomer(String phoneNumber) async {
    final uri = Uri(scheme: 'tel', path: phoneNumber);

    try {
      final launched = await launchUrl(uri);

      if (!launched) {
        _showMessage('Could not open phone dialer');
      }
    } catch (_) {
      _showMessage('Could not open phone dialer');
    }
  }

  /// real navigate function
  Future<void> _navigateToCustomer(Task task) async {
    if (task.customerLatitude == null || task.customerLongitude == null) {
      _showMessage('Customer location is not available');
      return;
    }

    final latitude = task.customerLatitude!;
    final longitude = task.customerLongitude!;

    final googleMapsUrl =
        'https://www.google.com/maps/dir/?api=1'
        '&destination=$latitude,$longitude'
        '&travelmode=driving';

    final uri = Uri.parse(googleMapsUrl);

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        _showMessage('Could not open navigation');
      }
    } catch (_) {
      _showMessage('Could not open navigation');
    }
  }

  /// real camera function
  Future<void> _pickFromCamera() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (image == null) return;

      setState(() {
        images.add(image);
      });
    } catch (_) {
      _showMessage('Could not capture image');
    }
  }

  /// real Gallery function
  Future<void> _pickFromGallery() async {
    try {
      final selectedImages = await _imagePicker.pickMultiImage(
        imageQuality: 80,
      );

      if (selectedImages.isEmpty) return;

      setState(() {
        images.addAll(selectedImages);
      });
    } catch (_) {
      _showMessage('Could not select images');
    }
  }

  /// =====================================
  /// LOCATION CAPTURE
  /// =====================================
  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showMessage('Please enable location services');
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showMessage('Location permission is required');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showMessage(
        'Location permission permanently denied. Enable it from settings.',
      );
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (_) {
      _showMessage('Could not get current location');
      return null;
    }
  }

  /// =====================================
  /// ACTIONS
  /// =====================================
  Future<void> _acceptTask() async {
    setState(() => isSubmitting = true);
    context.read<TaskBloc>().add(AcceptTaskEvent(widget.taskId));
  }

  Future<void> _startTask() async {
    setState(() => isSubmitting = true);

    final position = await _getCurrentLocation();
    if (position == null) {
      setState(() => isSubmitting = false);
      return;
    }

    if (!mounted) return;

    context.read<TaskBloc>().add(
      StartTaskEvent(
        taskId: widget.taskId,
        latitude: position.latitude,
        longitude: position.longitude,
      ),
    );
  }

  Future<void> _completeTask() async {
    if (notesController.text.trim().isEmpty) {
      _showMessage('Please add task notes');
      return;
    }

    if (images.isEmpty) {
      _showMessage('Please add at least one image');
      return;
    }

    if (!customerConfirmed) {
      _showMessage('Please confirm customer confirmation');
      return;
    }

    setState(() => isSubmitting = true);

    final position = await _getCurrentLocation();
    if (position == null) {
      setState(() => isSubmitting = false);
      return;
    }

    if (!mounted) return;

    context.read<TaskBloc>().add(
      CompleteTaskEvent(
        taskId: widget.taskId,
        notes: notesController.text.trim(),
        latitude: position.latitude,
        longitude: position.longitude,
        customerConfirmed: customerConfirmed,
      ),
    );
  }

  void _showMessage(String message) {
    CustomSnackBar.show(context, message: message, type: SnackBarType.error);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state is TaskLoaded) {
          setState(() => isSubmitting = false);
        }

        if (state is TaskError) {
          setState(() => isSubmitting = false);
          CustomSnackBar.show(
            context,
            message: state.message,
            type: SnackBarType.error,
          );
        }
      },
      builder: (context, state) {
        Task? task;
        if (state is TaskLoaded) {
          try {
            task = state.tasks.firstWhere((t) => t.id == widget.taskId);
          } catch (_) {
            task = null;
          }
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF7F8FA),

          appBar: AppBar(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            elevation: 0,
            scrolledUnderElevation: 0,

            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 20,
                color: Color(0xFF1D2A32),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),

            title: const Text(
              'Task Details',
              style: TextStyle(
                color: Color(0xFF1D2A32),
                fontSize: 19,
                fontWeight: FontWeight.w700,
              ),
            ),

            centerTitle: true,
          ),

          body: task == null
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Task not found. It may have been removed or not '
                      'synced yet.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildStatusCard(task),
                            const SizedBox(height: 16),
                            _buildCustomerCard(task),
                            const SizedBox(height: 16),
                            _buildTaskInformation(task),
                            const SizedBox(height: 16),
                            _buildLocationCard(task),
                            const SizedBox(height: 16),
                            _buildNotesSection(task),
                            const SizedBox(height: 16),
                            _buildImagesSection(),
                            const SizedBox(height: 16),
                            _buildCustomerConfirmation(task),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),

                    _buildBottomAction(task),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildStatusCard(Task task) {
    final statusColor = getStatusColor(task.status);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.assignment_rounded, color: statusColor),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Current Task Status',
                  style: TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                ),

                const SizedBox(height: 4),

                Text(
                  task.status,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: getPriorityColor(task.priority).withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${task.priority} Priority',
              style: TextStyle(
                color: getPriorityColor(task.priority),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerCard(Task task) {
    return _SectionCard(
      title: 'Customer Details',
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.customerName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1D2A32),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      task.customerPhone,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _callCustomer(task.customerPhone);
                  },
                  icon: const Icon(
                    Icons.call_outlined,
                    color: AppColors.primary,
                  ),
                  label: const Text(
                    'Call',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    _navigateToCustomer(task);
                  },
                  icon: const Icon(Icons.navigation_outlined),
                  label: const Text('Navigate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskInformation(Task task) {
    return _SectionCard(
      title: 'Task Information',
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.build_outlined,
            title: 'Service Type',
            value: task.serviceType,
          ),

          const SizedBox(height: 16),

          _InfoRow(
            icon: Icons.calendar_today_outlined,
            title: 'Date',
            value: _formatDate(task.taskDateTime),
          ),

          const SizedBox(height: 16),

          _InfoRow(
            icon: Icons.access_time_rounded,
            title: 'Time',
            value: _formatTime(task.taskDateTime),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(Task task) {
    return _SectionCard(
      title: 'Location',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _InfoRow(
            icon: Icons.location_on_outlined,
            title: 'Customer Address',
            value: task.address,
          ),

          const SizedBox(height: 16),

          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.map_outlined, size: 38, color: AppColors.primary),

                SizedBox(height: 8),

                Text(
                  'Customer Location',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),

                SizedBox(height: 4),

                Text(
                  'Map will be displayed here',
                  style: TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotesSection(Task task) {
    if (notesController.text.isEmpty && (task.notes?.isNotEmpty ?? false)) {
      notesController.text = task.notes!;
    }

    return _SectionCard(
      title: 'Task Notes',
      child: TextField(
        controller: notesController,
        maxLines: 4,
        enabled: task.status != 'Completed',
        decoration: InputDecoration(
          hintText: 'Add notes about the service...',
          hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF9CA3AF)),
          filled: true,
          fillColor: const Color(0xFFF7F8FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildImagesSection() {
    return _SectionCard(
      title: 'Service Images',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickFromCamera,
                  icon: const Icon(
                    Icons.camera_alt_outlined,
                    color: AppColors.primary,
                  ),
                  label: const Text(
                    'Camera',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _pickFromGallery,
                  icon: const Icon(
                    Icons.photo_library_outlined,
                    color: AppColors.primary,
                  ),
                  label: const Text(
                    'Gallery',
                    style: TextStyle(color: AppColors.primary),
                  ),
                ),
              ),
            ],
          ),

          if (images.isNotEmpty) ...[
            const SizedBox(height: 14),

            Text(
              '${images.length} image${images.length > 1 ? 's' : ''} selected',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF6B7280),
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 10),

            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: images.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final image = images[index];

                return Stack(
                  children: [
                    Positioned.fill(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(File(image.path), fit: BoxFit.cover),
                      ),
                    ),

                    Positioned(
                      top: 5,
                      right: 5,
                      child: Material(
                        color: Colors.red,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            setState(() {
                              images.removeAt(index);
                            });
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCustomerConfirmation(Task task) {
    final isCompleted = task.status == 'Completed';

    return _SectionCard(
      title: 'Customer Confirmation',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: isCompleted
              ? null
              : () {
                  setState(() {
                    customerConfirmed = !customerConfirmed;
                  });
                },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Checkbox(
                  value: isCompleted ? true : customerConfirmed,
                  activeColor: AppColors.primary,
                  onChanged: isCompleted
                      ? null
                      : (value) {
                          setState(() {
                            customerConfirmed = value ?? false;
                          });
                        },
                ),

                const SizedBox(width: 8),

                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customer confirmed completion',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      SizedBox(height: 4),

                      Text(
                        'Required before completing the task',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomAction(Task task) {
    if (task.status == 'Completed') {
      return SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: const Color(0xFF22A06B).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text(
                'Task Completed ✓',
                style: TextStyle(
                  color: Color(0xFF22A06B),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      );
    }

    String buttonText;
    VoidCallback buttonAction;
    IconData buttonIcon;

    if (task.status == 'Assigned') {
      buttonText = 'Accept Task';
      buttonAction = _acceptTask;
      buttonIcon = Icons.check_circle_outline;
    } else if (task.status == 'Accepted') {
      buttonText = 'Start Task';
      buttonAction = _startTask;
      buttonIcon = Icons.play_arrow_rounded;
    } else {
      buttonText = 'Complete Task';
      buttonAction = _completeTask;
      buttonIcon = Icons.check_circle_rounded;
    }

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(16),
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: isSubmitting ? null : buttonAction,
            icon: isSubmitting
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Icon(buttonIcon),
            label: Text(isSubmitting ? 'Please wait...' : buttonText),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
              elevation: 0,
              textStyle: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1D2A32),
            ),
          ),

          const SizedBox(height: 16),

          child,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 38,
          width: 38,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 19, color: AppColors.primary),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
              ),

              const SizedBox(height: 4),

              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1D2A32),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
