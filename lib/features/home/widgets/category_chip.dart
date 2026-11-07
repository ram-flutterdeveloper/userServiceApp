import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';
import 'dart:math';
import 'package:user_servicehub/data/models/home_response_model.dart';

class CategoryChip extends StatefulWidget {
  final Category category;
  final VoidCallback onTap;

  const CategoryChip({super.key, required this.category, required this.onTap});

  @override
  State<CategoryChip> createState() => _CategoryChipState();
}

class _CategoryChipState extends State<CategoryChip>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;
  final randomColor =
      Colors.primaries[Random().nextInt(Colors.primaries.length)];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
      lowerBound: 0.95,
      upperBound: 1.0,
    )..value = 1.0;
    _scale = _controller;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) => _controller.reverse();
  void _onTapUp(TapUpDetails details) => _controller.forward();
  void _onTapCancel() => _controller.forward();

  IconData _resolveIcon(String iconName) {
    switch (iconName) {
      case 'flash_on':
        return Icons.flash_on;
      case 'water_drop':
        return Icons.water_drop;
      case 'ac_unit':
        return Icons.ac_unit;
      case 'cleaning_services':
        return Icons.cleaning_services;
      case 'format_paint':
        return Icons.format_paint;
      case 'handyman':
        return Icons.handyman;
      case 'kitchen':
        return Icons.kitchen;
      case 'bug_report':
        return Icons.bug_report;
      case 'face':
        return Icons.face;
      case 'content_cut':
        return Icons.content_cut;
      case 'local_car_wash':
        return Icons.local_car_wash;
      case 'more_horiz':
        return Icons.more_horiz;
      default:
        return Icons.circle;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scale,
        builder:
            (context, child) =>
                Transform.scale(scale: _scale.value, child: child),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Container(
            //   width: 64,
            //   height: 64,
            //   decoration: BoxDecoration(
            //     //color:  color.withValues(alpha: 0.12),
            //     color: randomColor.withValues(alpha: 0.12),
            //     borderRadius: BorderRadius.circular(
            //       //  AppDimensions.radiusMedium + 10,
            //       20,
            //     ),
            //   ),
            //   child: Image.network(
            //     'https://cscindia.info/media/service_image/dl_service_copy.jpg',
            //   ),
            // ),
            Container(
              width: 150.w,
              height: 150.h,
              decoration: BoxDecoration(
                color: randomColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  'https://cscindia.info/media/service_image/dl_service_copy.jpg',
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 6),
            SizedBox(
              // width: 72,
              child: Text(
                widget.category.name ?? "",
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.caption.copyWith(
                  fontSize: 18,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
