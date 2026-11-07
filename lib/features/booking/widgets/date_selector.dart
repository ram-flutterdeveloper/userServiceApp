import 'package:flutter/material.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';

class DateSelector extends StatelessWidget {
  final int? selectedDate;
  final ValueChanged<int> onDateSelected;

  const DateSelector({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  List<DateTime> _generateDates() {
    final now = DateTime.now();
    return List.generate(7, (i) => DateTime(now.year, now.month, now.day + i));
  }

  String _dayName(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  String _monthName(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[date.month - 1];
  }

  String _dayLabel(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) {
      return 'Today';
    }
    return _dayName(date);
  }

  @override
  Widget build(BuildContext context) {
    final dates = _generateDates();
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 2),
        itemCount: dates.length,
        separatorBuilder: (_, _) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final date = dates[index];
          final isSelected = selectedDate == index;
          return GestureDetector(
            onTap: () => onDateSelected(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 72,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border.withValues(alpha: 0.4),
                  width: isSelected ? 1.5 : 1,
                ),
                boxShadow: isSelected
                    ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 2))]
                    : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _dayLabel(date),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? AppColors.white : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${date.day}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? AppColors.white : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    _monthName(date),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? AppColors.white.withValues(alpha: 0.8) : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
