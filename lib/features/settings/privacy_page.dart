import 'package:flutter/material.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';

class PrivacyPage extends StatefulWidget {
  const PrivacyPage({super.key});

  @override
  State<PrivacyPage> createState() => _PrivacyPageState();
}

class _PrivacyPageState extends State<PrivacyPage> {
  bool _dataCollection = true;
  bool _locationAccess = true;
  bool _cameraAccess = false;
  bool _microphoneAccess = false;
  bool _analytics = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title:  Text('Privacy', style: AppTextStyles.titleLarge),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        children: [
          _buildSectionHeader('Privacy Settings'),
          const SizedBox(height: AppDimensions.spacing12),
          _buildPrivacyTile(
            Icons.storage_outlined,
            'Data Collection',
            'Collect data to improve your experience and provide personalized services.',
            _dataCollection,
            (v) => setState(() => _dataCollection = v),
          ),
          const SizedBox(height: AppDimensions.spacing8),
          _buildPrivacyTile(
            Icons.location_on_outlined,
            'Location Access',
            'Used to find nearby professionals and suggest relevant services.',
            _locationAccess,
            (v) => setState(() => _locationAccess = v),
          ),
          const SizedBox(height: AppDimensions.spacing8),
          _buildPrivacyTile(
            Icons.camera_alt_outlined,
            'Camera Access',
            'Used to upload photos for service requests and profile pictures.',
            _cameraAccess,
            (v) => setState(() => _cameraAccess = v),
          ),
          const SizedBox(height: AppDimensions.spacing8),
          _buildPrivacyTile(
            Icons.mic_outlined,
            'Microphone Access',
            'Used for voice input and calling features within the app.',
            _microphoneAccess,
            (v) => setState(() => _microphoneAccess = v),
          ),
          const SizedBox(height: AppDimensions.spacing8),
          _buildPrivacyTile(
            Icons.analytics_outlined,
            'Analytics',
            'Help us improve the app by sending anonymous usage data.',
            _analytics,
            (v) => setState(() => _analytics = v),
          ),
          const SizedBox(height: AppDimensions.spacing24),
          _buildSectionHeader('Privacy Policy Summary'),
          const SizedBox(height: AppDimensions.spacing12),
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
                _buildPolicyPoint(
                  'We collect personal information you provide when creating an account, booking services, or contacting support.',
                ),
                const SizedBox(height: AppDimensions.spacing12),
                _buildPolicyPoint(
                  'Your data is encrypted and stored securely. We never share your personal information with third parties without your consent.',
                ),
                const SizedBox(height: AppDimensions.spacing12),
                _buildPolicyPoint(
                  'Location data is only used while the app is in use to connect you with nearby professionals.',
                ),
                const SizedBox(height: AppDimensions.spacing12),
                _buildPolicyPoint(
                  'You can request deletion of your account and associated data at any time through settings.',
                ),
                const SizedBox(height: AppDimensions.spacing12),
                _buildPolicyPoint(
                  'We use cookies and analytics to improve app performance and user experience.',
                ),
                const SizedBox(height: AppDimensions.spacing16),
                Text(
                  'For the full privacy policy, please visit our website or contact our support team.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textTertiary,
                    fontStyle: FontStyle.italic,
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

  Widget _buildPrivacyTile(
    IconData icon,
    String title,
    String description,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
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
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppDimensions.spacing8),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 6),
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppDimensions.spacing12),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}
