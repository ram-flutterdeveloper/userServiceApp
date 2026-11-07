import 'package:flutter/material.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';
import 'package:user_servicehub/core/widgets/app_rating.dart';
import 'package:user_servicehub/data/models/professional_model.dart';

class ProfessionalCard extends StatelessWidget {
  final ProfessionalModel professional;
  final VoidCallback onViewProfile;

  const ProfessionalCard({
    super.key,
    required this.professional,
    required this.onViewProfile,
  });

  String _initials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}';
    return name[0];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 10, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(AppDimensions.spacing12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.primary, AppColors.primaryDark]),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Center(
                  child: Text(
                    _initials(professional.name),
                    style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            professional.name,
                            style: AppTextStyles.titleSmall.copyWith(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (professional.isVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified, size: 14, color: AppColors.primary),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${professional.experience} yrs exp',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing8),
          Row(
            children: [
              AppRating(rating: professional.rating, showValue: true, size: 10),
              const SizedBox(width: 8),
              Text(
                '${professional.jobsCompleted} jobs',
                style: AppTextStyles.caption.copyWith(fontSize: 9, color: AppColors.textTertiary),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing8),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onViewProfile,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                padding: const EdgeInsets.symmetric(vertical: 8),
                minimumSize: Size.zero,
              ),
              child: const Text('View Profile', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
