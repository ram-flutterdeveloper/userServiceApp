import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/constants/app_routes.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title:  Text('Support', style: AppTextStyles.titleLarge),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        children: [
          _buildContactCard(
            context,
            icon: Icons.chat_bubble_outline,
            title: 'Live Chat',
            subtitle: 'Chat with our support team',
            color: AppColors.primary,
            onTap: () => context.push(AppRoutes.chatList),
          ),
          const SizedBox(height: AppDimensions.spacing12),
          _buildContactCard(
            context,
            icon: Icons.call_outlined,
            title: 'Call Support',
            subtitle: 'Speak to a representative',
            color: AppColors.success,
            onTap: () => _showCallDialog(context),
          ),
          const SizedBox(height: AppDimensions.spacing12),
          _buildContactCard(
            context,
            icon: Icons.email_outlined,
            title: 'Email Support',
            subtitle: 'Write to us anytime',
            color: AppColors.accent,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Composing email to support@servicehub.com'),
                ),
              );
            },
          ),
          const SizedBox(height: AppDimensions.spacing12),
          _buildContactCard(
            context,
            icon: Icons.help_outline,
            title: 'FAQs',
            subtitle: 'Find answers to common questions',
            color: AppColors.info,
            onTap: () => context.push(AppRoutes.faq),
          ),
          const SizedBox(height: AppDimensions.spacing24),
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacing20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need immediate help?',
                  style: AppTextStyles.titleMedium.copyWith(color: AppColors.white),
                ),
                const SizedBox(height: AppDimensions.spacing8),
                Text(
                  'Our support team is available 24/7 to assist you with urgent issues.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.white.withValues(alpha: 0.9),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: () => _showCallDialog(context),
                    icon: const Icon(Icons.call, size: 18),
                    label: const Text('Call Us 24/7'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.white,
                      foregroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppDimensions.spacing32),
        ],
      ),
    );
  }

  void _showCallDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        ),
        title:  Text('Call Support', style: AppTextStyles.titleMedium),
        content:  Text(
          'Call us at +1 (800) 123-4567\n\nOur support team is available 24/7.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Calling +1 (800) 123-4567...')),
              );
            },
            icon: const Icon(Icons.call, size: 18),
            label: const Text('Call Now'),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
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
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: AppDimensions.spacing16),
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
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textTertiary, size: 20),
          ],
        ),
      ),
    );
  }
}
