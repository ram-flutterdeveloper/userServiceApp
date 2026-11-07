import 'package:flutter/material.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? elevation;
  final double? borderRadius;
  final Color? color;
  final bool hasShadow;
  final bool bordered;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.elevation,
    this.borderRadius,
    this.color,
    this.hasShadow = true,
    this.bordered = false,
  });

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? AppDimensions.radiusCard;
    final shadowBlur = elevation ?? 8.0;
    final shadowOffset = Offset(0, (elevation ?? 2).clamp(1, 4).toDouble());

    final card = Container(
      margin: margin ?? EdgeInsets.zero,
      padding: padding ?? const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: color ?? AppColors.surface,
        borderRadius: BorderRadius.circular(radius),
        border: bordered ? Border.all(color: AppColors.border, width: 0.5) : null,
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: shadowBlur,
                  offset: shadowOffset,
                ),
              ]
            : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(radius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(radius),
          child: card,
        ),
      );
    }

    return card;
  }
}
