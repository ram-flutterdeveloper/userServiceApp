import 'package:flutter/material.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';

class MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconBackground;
  final Color? iconColor;
  final Widget? trailing;

  const MenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconBackground,
    this.iconColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconBackground ?? AppColors.primaryLight,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: Icon(
          icon,
          color: iconColor ?? AppColors.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
      trailing: trailing ??
          const Icon(
            Icons.chevron_right,
            size: 20,
            color: AppColors.textTertiary,
          ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
      ),
      visualDensity: VisualDensity.compact,
    );
  }
}
