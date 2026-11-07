import 'package:flutter/material.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/data/models/offer_model.dart';

class OfferCard extends StatelessWidget {
  final OfferModel offer;

  const OfferCard({super.key, required this.offer});

  IconData _resolveIcon(String iconName) {
    switch (iconName) {
      case 'ac_unit': return Icons.ac_unit;
      case 'savings': return Icons.savings;
      case 'card_giftcard': return Icons.card_giftcard;
      case 'search': return Icons.search;
      default: return Icons.local_offer;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = Color(offer.bgColor);
    return Container(
      width: 220,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      ),
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                ),
                child: Text(
                  offer.discountPercentage > 0
                      ? '${offer.discountPercentage.toInt()}% OFF'
                      : '₹${offer.discountAmount.toInt()} OFF',
                  style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w700, fontSize: 13),
                ),
              ),
              const Spacer(),
              Icon(_resolveIcon(offer.iconName), color: AppColors.white, size: 18),
            ],
          ),
          const Spacer(),
          Text(
            offer.title,
            style: const TextStyle(color: AppColors.white, fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            offer.description,
            style: TextStyle(color: AppColors.white.withValues(alpha: 0.85), fontSize: 11),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            'Code: ${offer.code}',
            style: TextStyle(color: AppColors.white.withValues(alpha: 0.7), fontSize: 10, fontWeight: FontWeight.w600),
          ),
          if (offer.isExpiring)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                'Valid till ${offer.validUntil}',
                style: TextStyle(color: AppColors.white.withValues(alpha: 0.6), fontSize: 9),
              ),
            ),
        ],
      ),
    );
  }
}
