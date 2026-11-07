import 'package:flutter/material.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';

class AppErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final String? illustrationPath;

  const AppErrorState({
    super.key,
    this.message = 'Something went wrong',
    this.onRetry,
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
                  color: AppColors.error.withValues(alpha: 0.1),
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
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                ),
                child: const Icon(
                  Icons.error_outline,
                  size: 40,
                  color: AppColors.error,
                ),
              ),
            const SizedBox(height: AppDimensions.spacing24),
            Text(
              message,
              style: AppTextStyles.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppDimensions.spacing24),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
