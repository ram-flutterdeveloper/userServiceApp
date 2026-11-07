import 'package:flutter/material.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';

enum BadgeVariant { new_, sale, promo, status }

enum BadgeSize { small, medium }

class AppBadge extends StatelessWidget {
  final String label;
  final BadgeVariant variant;
  final BadgeSize size;

  const AppBadge({
    super.key,
    required this.label,
    this.variant = BadgeVariant.new_,
    this.size = BadgeSize.small,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _variantColors(context);
    final horzPadding = size == BadgeSize.small ? 8.0 : 12.0;
    final vertPadding = size == BadgeSize.small ? 3.0 : 5.0;
    final fontSize = size == BadgeSize.small ? 10.0 : 12.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horzPadding,
        vertical: vertPadding,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: colors.foreground,
        ),
      ),
    );
  }

  _BadgeColors _variantColors(BuildContext context) {
    switch (variant) {
      case BadgeVariant.new_:
        return const _BadgeColors(
          background: AppColors.primaryLight,
          foreground: AppColors.primary,
        );
      case BadgeVariant.sale:
        return const _BadgeColors(
          background: AppColors.accentLight,
          foreground: AppColors.accent,
        );
      case BadgeVariant.promo:
        return const _BadgeColors(
          background: AppColors.secondaryLight,
          foreground: AppColors.secondary,
        );
      case BadgeVariant.status:
        return _statusColors();
    }
  }

  _BadgeColors _statusColors() {
    final lower = label.toLowerCase();
    if (lower == 'active' || lower == 'completed' || lower == 'confirmed') {
      return const _BadgeColors(
        background: AppColors.secondaryLight,
        foreground: AppColors.success,
      );
    }
    if (lower == 'pending' || lower == 'in progress') {
      return const _BadgeColors(
        background: AppColors.accentLight,
        foreground: AppColors.warning,
      );
    }
    if (lower == 'cancelled' || lower == 'rejected' || lower == 'failed') {
      return const _BadgeColors(
        background: Color(0xFFFEE2E2),
        foreground: AppColors.error,
      );
    }
    return const _BadgeColors(
      background: AppColors.primaryLight,
      foreground: AppColors.primary,
    );
  }
}

class _BadgeColors {
  final Color background;
  final Color foreground;

  const _BadgeColors({required this.background, required this.foreground});
}

class VerifiedBadge extends StatelessWidget {
  final double size;

  const VerifiedBadge({super.key, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.verified, size: size, color: AppColors.primary);
  }
}
