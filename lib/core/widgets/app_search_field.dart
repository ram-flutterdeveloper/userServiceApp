import 'package:flutter/material.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';

class AppSearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final bool autoFocus;
  final Widget? suffixIcon;

  const AppSearchField({
    super.key,
    this.controller,
    this.hint,
    this.onChanged,
    this.onSubmitted,
    this.autoFocus = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusBanner),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        onSubmitted: onSubmitted,
        autofocus: autoFocus,
        style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint ?? 'Search services...',
          hintStyle: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textTertiary,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(AppDimensions.spacing12),
            child: Icon(
              Icons.search_rounded,
              size: AppDimensions.iconMedium,
              color: AppColors.textTertiary,
            ),
          ),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spacing16,
            vertical: AppDimensions.spacing16,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusBanner),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusBanner),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusBanner),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          ),
        ),
      ),
    );
  }
}
