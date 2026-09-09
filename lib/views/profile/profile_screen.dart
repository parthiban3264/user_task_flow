import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_task_flow/core/widgets/custom_loading.dart';
import 'package:user_task_flow/models/user_model.dart';

import '../../core/constants/app_colors.dart';
import '../../core/storage/flutter_secure_storage.dart';
import '../../view_models/auth/auth_bloc.dart';
import '../../view_models/auth/auth_event.dart';
import '../../view_models/user/user_bloc.dart';
import '../../view_models/user/user_event.dart';
import '../../view_models/user/user_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();

    _loadProfile();
  }

  /// =========================================
  /// LOAD PROFILE
  /// =========================================

  Future<void> _loadProfile() async {
    final user = await TokenStorage.getUser();

    if (!mounted) return;

    if (user == null || user['id'] == null) {
      return;
    }

    final userId = int.tryParse(user['id'].toString());

    if (userId == null) {
      return;
    }

    context.read<UserBloc>().add(
      GetSingleUser(UserModel(id: userId.toString())),
    );
  }

  /// =========================================
  /// LOGOUT
  /// =========================================

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Color(0xFF6B7280)),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Color(0xFF6B7280)),
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                context.read<AuthBloc>().add(LogoutRequested());
                Navigator.pop(dialogContext);

                if (!context.mounted) return;

                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDC2626),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  /// =========================================
  /// BUILD
  /// =========================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: const Color(0xFFF7F8FA),
        surfaceTintColor: Colors.transparent,

        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF1D2A32),
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SafeArea(
        top: false,
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            /// =========================================
            /// LOADING
            /// =========================================

            if (state is UserLoading) {
              return CustomLoading();
            }

            /// =========================================
            /// ERROR
            /// =========================================

            if (state is UserError) {
              return _buildError(state.msg);
            }

            /// =========================================
            /// SUCCESS
            /// =========================================

            if (state is GetSingleUserSuccess) {
              final user = state.user;

              return RefreshIndicator(
                onRefresh: _loadProfile,
                child: _buildProfile(user),
              );
            }

            /// =========================================
            /// INITIAL / OTHER STATE
            /// =========================================

            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  /// =========================================
  /// PROFILE UI
  /// =========================================

  Widget _buildProfile(dynamic user) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
      child: Column(
        children: [
          /// =========================================
          /// PROFILE HEADER
          /// =========================================
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              children: [
                /// PROFILE IMAGE
                Container(
                  height: 86,
                  width: 86,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primary, width: 2),
                  ),
                  child: const Icon(
                    Icons.person_rounded,
                    size: 46,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: 14),

                /// NAME
                Text(
                  _getName(user),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1D2A32),
                  ),
                ),

                const SizedBox(height: 5),

                // /// ROLE
                // Text(
                //   _getRole(user),
                //   textAlign: TextAlign.center,
                //   style: const TextStyle(
                //     fontSize: 13,
                //     color: Color(0xFF6B7280),
                //   ),
                // ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// =========================================
          /// PERSONAL INFORMATION
          /// =========================================
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D2A32),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              children: [
                _ProfileInfoTile(
                  icon: Icons.person_outline_rounded,
                  title: 'Full Name',
                  value: _getName(user),
                ),

                const Divider(height: 1, indent: 16, endIndent: 16),

                _ProfileInfoTile(
                  icon: Icons.email_outlined,
                  title: 'Email Address',
                  value: _getEmail(user),
                ),

                const Divider(height: 1, indent: 16, endIndent: 16),

                _ProfileInfoTile(
                  icon: Icons.phone_outlined,
                  title: 'Mobile Number',
                  value: _getMobile(user),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// =========================================
          /// ACCOUNT
          /// =========================================
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Account',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D2A32),
              ),
            ),
          ),

          const SizedBox(height: 12),

          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Column(
              children: [
                _MenuTile(
                  icon: Icons.lock_outline_rounded,
                  title: 'Change Password',
                  onTap: () {},
                ),

                const Divider(height: 1, indent: 16, endIndent: 16),

                _MenuTile(
                  icon: Icons.sync_rounded,
                  title: 'Sync Status',
                  subtitle: 'All data synchronized',
                  onTap: () {},
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// =========================================
          /// LOGOUT
          /// =========================================
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.logout_rounded, size: 20),
              label: const Text(
                'Logout',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFDC2626),
                side: const BorderSide(color: Color(0xFFFCA5A5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'User Task Flow',
            style: TextStyle(fontSize: 12, color: Color(0xFF9CA3AF)),
          ),

          const SizedBox(height: 4),

          const Text(
            'Version 1.0.0',
            style: TextStyle(fontSize: 11, color: Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }

  /// =========================================
  /// ERROR UI
  /// =========================================

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              size: 48,
              color: Color(0xFFDC2626),
            ),

            const SizedBox(height: 12),

            const Text(
              'Unable to load profile',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D2A32),
              ),
            ),

            // const SizedBox(height: 6),
            //
            // Text(
            //   message,
            //   textAlign: TextAlign.center,
            //   style: const TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
            // ),
            const SizedBox(height: 18),

            ElevatedButton(onPressed: _loadProfile, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }

  /// =========================================
  /// USER FIELD HELPERS
  /// =========================================

  String _getName(dynamic user) {
    return user.name?.toString() ?? '-';
  }

  String _getEmail(dynamic user) {
    return user.email?.toString() ?? '-';
  }

  String _getMobile(dynamic user) {
    return user.phone?.toString() ?? user.phone?.toString() ?? '-';
  }

  // String _getRole(dynamic user) {
  //   return user.role?.toString() ?? '-';
  // }
}

/// =========================================
/// PROFILE INFORMATION TILE
/// =========================================

class _ProfileInfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ProfileInfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 21),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF9CA3AF),
                  ),
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
      ),
    );
  }
}

/// =========================================
/// MENU TILE
/// =========================================

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              height: 42,
              width: 42,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 21),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1D2A32),
                    ),
                  ),

                  if (subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Color(0xFF9CA3AF),
            ),
          ],
        ),
      ),
    );
  }
}
