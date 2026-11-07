import 'package:flutter/material.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';

class AppRating extends StatelessWidget {
  final double rating;
  final double size;
  final bool showValue;
  final TextStyle? valueStyle;
  final int count;

  const AppRating({
    super.key,
    required this.rating,
    this.size = 14,
    this.showValue = true,
    this.valueStyle,
    this.count = 5,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(count, (i) {
          if (i < rating.floor()) {
            return Icon(Icons.star, size: size, color: AppColors.accent);
          } else if (i < rating && i >= rating.floor()) {
            return Icon(Icons.star_half, size: size, color: AppColors.accent);
          }
          return Icon(Icons.star_border, size: size, color: AppColors.accent);
        }),
        if (showValue) ...[
          const SizedBox(width: AppDimensions.spacing4),
          Text(
            rating.toStringAsFixed(1),
            style: valueStyle ??
                TextStyle(
                  fontSize: size,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
          ),
        ],
      ],
    );
  }
}
