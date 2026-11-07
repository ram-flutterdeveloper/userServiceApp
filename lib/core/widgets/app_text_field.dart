import 'package:flutter/material.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final int? maxLines;
  final bool enabled;
  final ValueChanged<String>? onChanged;
  final String? errorText;

  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.validator,
    this.keyboardType,
    this.maxLines = 1,
    this.enabled = true,
    this.onChanged,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacing8),
            child: Text(
              label!,
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          validator: validator,
          keyboardType: keyboardType,
          maxLines: maxLines,
          enabled: enabled,
          onChanged: onChanged,
          style: AppTextStyles.bodyLarge.copyWith(
            color: enabled ? AppColors.textPrimary : AppColors.textTertiary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textTertiary,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: AppDimensions.iconMedium, color: AppColors.textTertiary)
                : null,
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: enabled ? AppColors.background : AppColors.background.withValues(alpha: 0.7),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing16,
              vertical: maxLines != null && maxLines! > 1 ? AppDimensions.spacing16 : 0,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
              borderSide: BorderSide(
                color: errorText != null ? AppColors.error : AppColors.border,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
            errorStyle: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: AppDimensions.spacing4),
          Padding(
            padding: const EdgeInsets.only(left: AppDimensions.spacing4),
            child: Text(
              errorText!,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ],
    );
  }
}
