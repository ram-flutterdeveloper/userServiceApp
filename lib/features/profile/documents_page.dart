import 'package:flutter/material.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';

class DocumentsPage extends StatelessWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final documents = [
      _DocumentInfo(
        icon: Icons.badge_outlined,
        name: 'Aadhaar Card',
        status: 'Uploaded',
        isUploaded: true,
      ),
      _DocumentInfo(
        icon: Icons.credit_card_outlined,
        name: 'PAN Card',
        status: 'Pending',
        isUploaded: false,
      ),
      _DocumentInfo(
        icon: Icons.drive_eta_outlined,
        name: "Driver's License",
        status: 'Pending',
        isUploaded: false,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'My Documents',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(AppDimensions.spacing20),
        itemCount: documents.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, index) {
          final doc = documents[index];
          return Container(
            padding: const EdgeInsets.all(AppDimensions.spacing16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: doc.isUploaded
                        ? AppColors.secondaryLight
                        : AppColors.accentLight,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusMedium,
                    ),
                  ),
                  child: Icon(
                    doc.icon,
                    color: doc.isUploaded
                        ? AppColors.success
                        : AppColors.accent,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc.name,
                        style: AppTextStyles.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            doc.isUploaded
                                ? Icons.check_circle
                                : Icons.access_time,
                            size: 14,
                            color: doc.isUploaded
                                ? AppColors.success
                                : AppColors.accent,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            doc.status,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: doc.isUploaded
                                  ? AppColors.success
                                  : AppColors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 38,
                  child: FilledButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '${doc.name} upload coming soon',
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: doc.isUploaded
                          ? AppColors.secondaryLight
                          : AppColors.primary,
                      foregroundColor: doc.isUploaded
                          ? AppColors.success
                          : AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusButton,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                    ),
                    child: Text(
                      doc.isUploaded ? 'Update' : 'Upload',
                      style: AppTextStyles.buttonMedium,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _DocumentInfo {
  final IconData icon;
  final String name;
  final String status;
  final bool isUploaded;

  const _DocumentInfo({
    required this.icon,
    required this.name,
    required this.status,
    required this.isUploaded,
  });
}
