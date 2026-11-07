import 'package:flutter/material.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';
import 'package:user_servicehub/core/utils/currency_formatter.dart';
import 'package:user_servicehub/core/widgets/app_rating.dart';
import 'package:user_servicehub/data/models/service_model.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final bool isFavorite;
  final VoidCallback onBookNow;
  final VoidCallback onFavoriteToggle;

  const ServiceCard({
    super.key,
    required this.service,
    required this.isFavorite,
    required this.onBookNow,
    required this.onFavoriteToggle,
  });

  Color _serviceColor(int index) {
    const colors = [
      AppColors.primary,
      Color(0xFF10B981),
      Color(0xFFF59E0B),
      Color(0xFF8B5CF6),
      Color(0xFFEF4444),
      Color(0xFFEC4899),
      Color(0xFF06B6D4),
      Color(0xFF84CC16),
    ];
    return colors[index % colors.length];
  }

  IconData _serviceIcon(String category) {
    switch (category) {
      case 'Electrician':
        return Icons.flash_on;
      case 'Plumbing':
        return Icons.water_drop;
      case 'AC Repair':
        return Icons.ac_unit;
      case 'Cleaning':
        return Icons.cleaning_services;
      case 'Painting':
        return Icons.format_paint;
      case 'Carpenter':
        return Icons.handyman;
      case 'Appliance Repair':
        return Icons.kitchen;
      case 'Pest Control':
        return Icons.bug_report;
      case 'Beauty':
        return Icons.face;
      case 'Salon':
        return Icons.content_cut;
      case 'Car Wash':
        return Icons.local_car_wash;
      default:
        return Icons.build;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _serviceColor(service.id.hashCode);
    return Container(
      width: 200,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  //color
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppDimensions.radiusCard),
                  ),
                ),
                child: Center(
                  child: Icon(
                    _serviceIcon(service.categoryName),
                    color: AppColors.white,
                    size: 36,
                  ),
                ),
              ),
              if (service.discountPercentage > 0)
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSmall,
                      ),
                    ),
                    child: Text(
                      '${service.discountPercentage.toInt()}% OFF',
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: onFavoriteToggle,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 18,
                      color:
                          isFavorite
                              ? AppColors.error
                              : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spacing12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          service.title,
                          style: AppTextStyles.titleSmall.copyWith(
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (service.isVerified)
                        const Icon(
                          Icons.verified,
                          size: 14,
                          color: AppColors.primary,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    service.providerName,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      AppRating(
                        rating: service.rating,
                        showValue: true,
                        size: 10,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${service.distance.toStringAsFixed(1)} km',
                        style: AppTextStyles.caption.copyWith(
                          fontSize: 9,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (service.discountPercentage > 0)
                            Text(
                              CurrencyFormatter.formatIndianRupees(
                                service.price,
                              ),
                              style: AppTextStyles.caption.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.textTertiary,
                                fontSize: 10,
                              ),
                            ),
                          Text(
                            CurrencyFormatter.formatIndianRupees(
                              service.price *
                                  (1 - service.discountPercentage / 100),
                            ),
                            style: AppTextStyles.titleSmall.copyWith(
                              color: AppColors.primary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: onBookNow,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusFull,
                            ),
                          ),
                          child: const Text(
                            'Book Now',
                            style: TextStyle(
                              color: AppColors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
