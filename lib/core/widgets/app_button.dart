import 'package:flutter/material.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';

enum AppButtonVariant { filled, outlined, text }

enum AppButtonSize { large, medium, small }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final IconData? icon;
  final bool expanded;
  final Color? color;
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.size = AppButtonSize.large,
    this.isLoading = false,
    this.icon,
    this.expanded = false,
    this.color,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;
    final btnColor = color ?? Theme.of(context).colorScheme.primary;

    final height = switch (size) {
      AppButtonSize.large => AppDimensions.buttonHeight,
      AppButtonSize.medium => AppDimensions.buttonHeightSmall,
      AppButtonSize.small => 36.0,
    };

    final textStyle = switch (size) {
      AppButtonSize.large => AppTextStyles.buttonLarge,
      AppButtonSize.medium => AppTextStyles.buttonLarge.copyWith(fontSize: 14),
      AppButtonSize.small => AppTextStyles.labelLarge,
    };

    Widget button;

    switch (variant) {
      case AppButtonVariant.filled:
        button = FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: FilledButton.styleFrom(
            backgroundColor: btnColor,
            foregroundColor: AppColors.white,
            disabledBackgroundColor: btnColor.withValues(alpha: 0.5),
            disabledForegroundColor: AppColors.white.withValues(alpha: 0.7),
            minimumSize: Size(fullWidth ? double.infinity : 0, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
            ),
            textStyle: textStyle,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
          ),
          child: _buildChild(textStyle, btnColor),
        );
      case AppButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: btnColor,
            side: BorderSide(
              color: isEnabled ? btnColor : btnColor.withValues(alpha: 0.4),
            ),
            disabledForegroundColor: btnColor.withValues(alpha: 0.5),
            minimumSize: Size(fullWidth ? double.infinity : 0, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
            ),
            textStyle: textStyle,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
          ),
          child: _buildChild(textStyle, btnColor),
        );
      case AppButtonVariant.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: btnColor,
            disabledForegroundColor: btnColor.withValues(alpha: 0.5),
            minimumSize: Size(fullWidth ? double.infinity : 0, height),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
            ),
            textStyle: textStyle,
            padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing24),
          ),
          child: _buildChild(textStyle, btnColor),
        );
    }

    if (!fullWidth && !expanded) {
      button = IntrinsicWidth(child: button);
    }

    return button;
  }

  Widget _buildChild(TextStyle textStyle, Color btnColor) {
    if (isLoading) {
      final spinnerSize = switch (size) {
        AppButtonSize.large => 24.0,
        AppButtonSize.medium => 20.0,
        AppButtonSize.small => 16.0,
      };
      return SizedBox(
        width: spinnerSize,
        height: spinnerSize,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: variant == AppButtonVariant.filled ? AppColors.white : btnColor,
        ),
      );
    }

    final iconSize = switch (size) {
      AppButtonSize.large => 20.0,
      AppButtonSize.medium => 18.0,
      AppButtonSize.small => 16.0,
    };

    final children = <Widget>[];
    if (icon != null) {
      children.add(Icon(icon, size: iconSize));
      children.add(const SizedBox(width: 8));
    }
    children.add(Text(label, style: textStyle));

    return Row(
      mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }
}
