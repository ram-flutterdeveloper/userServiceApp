import 'package:flutter/material.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final String? tooltip;
  final bool hasBadge;
  final int badgeCount;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.size = AppDimensions.iconMedium,
    this.backgroundColor,
    this.iconColor,
    this.tooltip,
    this.hasBadge = false,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final button = SizedBox(
      width: 48,
      height: 48,
      child: IconButton(
        onPressed: onPressed,
        icon: Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(icon, size: size, color: iconColor ?? AppColors.textPrimary),
            if (hasBadge && badgeCount > 0)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Text(
                    badgeCount > 99 ? '99+' : badgeCount.toString(),
                    style: const TextStyle(
                      color: AppColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      height: 1,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
        splashRadius: 22,
        tooltip: tooltip,
      ),
    );

    if (backgroundColor != null) {
      return Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        ),
        child: button,
      );
    }

    return button;
  }
}
