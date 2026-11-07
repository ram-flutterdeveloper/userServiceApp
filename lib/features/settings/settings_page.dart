import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/constants/app_routes.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';

import '../profile/update_profile_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _pushNotifications = true;
  bool _darkMode = false;
  bool _biometric = false;

  void _showChangePasswordDialog() {
    final oldPwdCtrl = TextEditingController();
    final newPwdCtrl = TextEditingController();
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            ),
            title: Text('Change Password', style: AppTextStyles.titleMedium),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: oldPwdCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Current Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: newPwdCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'New Password',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password changed successfully'),
                    ),
                  );
                },
                child: const Text('Change'),
              ),
            ],
          ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            ),
            title: Text('Delete Account', style: AppTextStyles.titleMedium),
            content: Text(
              'This action cannot be undone. All your data will be permanently deleted. Are you sure you want to continue?',
              style: AppTextStyles.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              FilledButton(
                style: FilledButton.styleFrom(backgroundColor: AppColors.error),
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Account deleted successfully'),
                    ),
                  );
                },
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            ),
            title: Text('ServiceHub', style: AppTextStyles.titleMedium),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Version: 1.0.0', style: AppTextStyles.bodyMedium),
                SizedBox(height: 8),
                Text(
                  '© 2026 ServiceHub. All rights reserved.',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
            actions: [
              FilledButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text('Settings', style: AppTextStyles.titleLarge)),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        children: [
          _buildSectionHeader('Preferences'),
          const SizedBox(height: AppDimensions.spacing12),
          _buildSwitchTile(
            Icons.notifications_outlined,
            'Push Notifications',
            'Receive booking updates and offers',
            _pushNotifications,
            (v) => setState(() => _pushNotifications = v),
          ),
          // const SizedBox(height: AppDimensions.spacing8),
          // _buildSwitchTile(
          //   Icons.dark_mode_outlined,
          //   'Dark Mode',
          //   'Switch to dark theme',
          //   _darkMode,
          //   (v) => setState(() => _darkMode = v),
          // ),
          // const SizedBox(height: AppDimensions.spacing8),
          // _buildNavTile(Icons.language_outlined, 'Language', 'English', () {}),
          const SizedBox(height: AppDimensions.spacing24),
          _buildSectionHeader('Account'),
          const SizedBox(height: AppDimensions.spacing12),
          _buildNavTile(
            Icons.person_outline,
            'Edit Profile',
            'Update your personal information',
            () => Get.to(() => UpdateProfilePage()),
          ),
          // const SizedBox(height: AppDimensions.spacing8),
          // _buildNavTileWithTap(
          //   Icons.lock_outline,
          //   'Change Password',
          //   'Update your account password',
          //   _showChangePasswordDialog,
          // ),
          const SizedBox(height: AppDimensions.spacing8),
          _buildNavTile(
            Icons.privacy_tip_outlined,
            'Privacy',
            'Manage your privacy settings',
            () => context.push(AppRoutes.privacy),
          ),
          // const SizedBox(height: AppDimensions.spacing8),
          // _buildSwitchTile(
          //   Icons.fingerprint,
          //   'Security',
          //   'Biometric/Fingerprint login',
          //   _biometric,
          //   (v) => setState(() => _biometric = v),
          // ),
          const SizedBox(height: AppDimensions.spacing24),
          _buildSectionHeader('Support'),
          const SizedBox(height: AppDimensions.spacing12),
          _buildNavTile(
            Icons.help_outline,
            'Help Center',
            'FAQs and guides',
            () => context.push(AppRoutes.faq),
          ),
          const SizedBox(height: AppDimensions.spacing8),
          _buildNavTile(
            Icons.support_agent_outlined,
            'Contact Us',
            'Get in touch with our team',
            () => context.push(AppRoutes.support),
          ),
          const SizedBox(height: AppDimensions.spacing8),
          _buildNavTile(
            Icons.description_outlined,
            'Terms & Conditions',
            'Read our terms',
            () => context.push(AppRoutes.terms),
          ),
          const SizedBox(height: AppDimensions.spacing8),
          _buildNavTile(
            Icons.privacy_tip_outlined,
            'Privacy Policy',
            'How we handle your data',
            () => context.push(AppRoutes.privacy),
          ),
          const SizedBox(height: AppDimensions.spacing8),
          _buildNavTileWithTap(
            Icons.info_outline,
            'About',
            'ServiceHub v1.0.0',
            _showAboutDialog,
          ),
          const SizedBox(height: AppDimensions.spacing24),
          _buildSectionHeader('Danger Zone'),
          const SizedBox(height: AppDimensions.spacing12),
          _buildDeleteAccountTile(),
          const SizedBox(height: AppDimensions.spacing24),
          Center(
            child: Text(
              'ServiceHub v1.0.0',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacing8),
          Center(
            child: Text(
              '© 2026 ServiceHub. All rights reserved.',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacing32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: AppDimensions.spacing4),
      child: Text(
        title,
        style: AppTextStyles.titleSmall.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    IconData icon,
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 22),
          const SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildNavTile(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 22),
            const SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textTertiary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavTileWithTap(
    IconData icon,
    String title,
    String subtitle,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.textSecondary, size: 22),
            const SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textTertiary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteAccountTile() {
    return GestureDetector(
      onTap: _showDeleteAccountDialog,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.delete_forever_outlined,
              color: AppColors.error,
              size: 22,
            ),
            const SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Delete Account',
                    style: AppTextStyles.titleSmall.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Permanently delete your account and all data',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: AppColors.textTertiary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
