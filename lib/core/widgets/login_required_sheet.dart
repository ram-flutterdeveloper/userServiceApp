import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/constants/app_routes.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';

class LoginRequiredSheet extends StatelessWidget {
  const LoginRequiredSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusBottomSheet),
          topRight: Radius.circular(AppDimensions.radiusBottomSheet),
        ),
      ),
      builder: (_) => const LoginRequiredSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.spacing24,
            AppDimensions.spacing8,
            AppDimensions.spacing24,
            AppDimensions.spacing24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: AppDimensions.spacing24),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                ),
                child: const Icon(
                  Icons.lock_outline_rounded,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing24),
              // Title
              Text(
                'Login Required',
                style: AppTextStyles.headlineMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing12),
              // Description
              Text(
                'Please log in to access this feature and enjoy a personalized experience.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spacing32),
              // Login button
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.push(AppRoutes.login);
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, AppDimensions.buttonHeight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
                  ),
                ),
                child: const Text('Login'),
              ),
              const SizedBox(height: AppDimensions.spacing12),
              // Continue browsing button
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  minimumSize: const Size(double.infinity, AppDimensions.buttonHeightSmall),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
                  ),
                  foregroundColor: AppColors.textSecondary,
                ),
                child: const Text('Continue Browsing'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
