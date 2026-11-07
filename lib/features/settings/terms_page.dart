import 'package:flutter/material.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title:  Text('Terms & Conditions', style: AppTextStyles.titleLarge),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacing16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
              border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  'Terms & Conditions',
                  style: AppTextStyles.titleMedium,
                ),
                const SizedBox(height: AppDimensions.spacing4),
                Text(
                  'Last updated: January 1, 2026',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiary),
                ),
                const SizedBox(height: AppDimensions.spacing16),
                _buildSection('1. Acceptance of Terms',
                  'By accessing or using ServiceHub ("the Platform"), you agree to be bound by these Terms & Conditions. If you do not agree with any part of these terms, you must not use the Platform. These terms constitute a legally binding agreement between you ("User") and ServiceHub Technologies Pvt. Ltd. ("Company").'),
                _buildSection('2. Description of Service',
                  'ServiceHub is an online marketplace that connects users with verified service professionals for home services including but not limited to cleaning, plumbing, electrical work, painting, AC repair, salon services, and pest control. The Platform facilitates booking, payment, and communication between users and professionals.'),
                _buildSection('3. User Registration',
                  'To access certain features, you must register for an account. You agree to provide accurate, current, and complete information during the registration process. You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.'),
                _buildSection('4. Booking and Payments',
                  'All bookings made through the Platform are subject to availability and confirmation. Payments are processed securely through our payment gateway partners. Prices are displayed inclusive of applicable taxes unless stated otherwise. ServiceHub reserves the right to modify pricing with prior notice.'),
                _buildSection('5. Cancellation and Refund Policy',
                  'Users may cancel bookings free of charge up to 24 hours before the scheduled service. Cancellations made within 24 hours may incur a nominal fee. Refunds are processed within 5-7 business days. ServiceHub may cancel bookings in case of professional unavailability and will issue a full refund.'),
                _buildSection('6. Professional Verification',
                  'All professionals on the Platform undergo a thorough verification process including background checks, identity verification, and skill assessment. However, ServiceHub does not guarantee the quality, safety, or legality of services provided by professionals. Users are encouraged to review professional profiles and ratings before booking.'),
                _buildSection('7. User Conduct',
                  'Users agree to treat professionals with respect and dignity. Any abusive behavior, harassment, or discrimination will result in immediate account suspension. Users are responsible for providing accurate information about their service requirements and ensuring safe access to their premises.'),
                _buildSection('8. Intellectual Property',
                  'All content on the Platform including logos, trademarks, text, images, and software is the property of ServiceHub or its licensors. Users may not reproduce, distribute, or create derivative works without prior written consent.'),
                _buildSection('9. Limitation of Liability',
                  'ServiceHub acts as an intermediary and is not liable for any direct, indirect, incidental, or consequential damages arising from the use of services booked through the Platform. Our total liability is limited to the amount paid by the user for the specific service in question.'),
                _buildSection('10. Privacy and Data Protection',
                  'We collect and process personal information as described in our Privacy Policy. By using the Platform, you consent to such collection and processing. We implement industry-standard security measures to protect your data.'),
                _buildSection('11. Termination',
                  'ServiceHub reserves the right to suspend or terminate accounts that violate these terms or engage in fraudulent activity. Users may terminate their account at any time through the settings page. Upon termination, access to the Platform will be revoked.'),
                _buildSection('12. Changes to Terms',
                  'We reserve the right to modify these terms at any time. Users will be notified of material changes via email or in-app notification. Continued use of the Platform after changes constitutes acceptance of the modified terms.'),
                _buildSection('13. Governing Law',
                  'These terms are governed by the laws of India. Any disputes arising from these terms shall be subject to the exclusive jurisdiction of the courts in Bangalore, Karnataka.'),
                _buildSection('14. Contact Information',
                  'For questions or concerns regarding these terms, please contact us at support@servicehub.com or visit our Support page. We aim to respond to all inquiries within 24 hours.'),
                const SizedBox(height: AppDimensions.spacing16),
                Center(
                  child: Text(
                    '© 2026 ServiceHub Technologies Pvt. Ltd. All rights reserved.',
                    style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
                    textAlign: TextAlign.center,
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

  Widget _buildSection(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spacing16),
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
          const SizedBox(height: AppDimensions.spacing8),
          Text(
            body,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
