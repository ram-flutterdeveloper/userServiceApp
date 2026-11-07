import 'package:flutter/material.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';
import 'package:user_servicehub/core/widgets/app_rating.dart';
import 'package:user_servicehub/data/models/review_model.dart';

class ReviewCard extends StatelessWidget {
  final ReviewModel review;

  const ReviewCard({super.key, required this.review});

  String _initials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}';
    return name[0];
  }

  Color _avatarColor(int hash) {
    const colors = [
      AppColors.primary,
      Color(0xFF10B981),
      Color(0xFFF59E0B),
      Color(0xFF8B5CF6),
      Color(0xFFEF4444),
      Color(0xFFEC4899),
    ];
    return colors[hash % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        boxShadow: const [
          BoxShadow(color: AppColors.shadow, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _avatarColor(review.userName.hashCode),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                ),
                child: Center(
                  child: Text(
                    _initials(review.userName),
                    style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w600, fontSize: 12),
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.userName, style: AppTextStyles.titleSmall.copyWith(fontSize: 14)),
                    const SizedBox(height: 2),
                    AppRating(rating: review.rating, showValue: true, size: 10),
                  ],
                ),
              ),
              Text(
                review.date,
                style: AppTextStyles.caption.copyWith(fontSize: 9, color: AppColors.textTertiary),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing8),
          Text(
            review.comment,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 13),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppDimensions.spacing8),
          Text(
            'Service: ${review.serviceName}',
            style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
