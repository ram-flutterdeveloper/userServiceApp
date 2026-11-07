import 'package:flutter/material.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';

class AppEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? buttonLabel;
  final VoidCallback? onButtonTap;
  final String? illustrationPath;

  const AppEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.buttonLabel,
    this.onButtonTap,
    this.illustrationPath,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (illustrationPath != null)
              Container(
                width: 120,
                height: 120,
                margin: const EdgeInsets.only(bottom: AppDimensions.spacing24),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                  child: Image.asset(
                    illustrationPath!,
                    fit: BoxFit.contain,
                  ),
                ),
              )
            else
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                ),
                child: Icon(icon, size: 40, color: AppColors.textTertiary),
              ),
            const SizedBox(height: AppDimensions.spacing24),
            Text(
              title,
              style: AppTextStyles.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null && subtitle!.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.spacing8),
              Text(
                subtitle!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            if (buttonLabel != null && onButtonTap != null) ...[
              const SizedBox(height: AppDimensions.spacing24),
              FilledButton(
                onPressed: onButtonTap,
                child: Text(buttonLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
