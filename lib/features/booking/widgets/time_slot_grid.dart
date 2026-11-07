import 'package:flutter/material.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/data/models/timeSlot_response.dart';

class TimeSlotGrid extends StatelessWidget {
  final String? selectedSlot;
  final ValueChanged<TimeSlotData> onSlotSelected;
  final List<String> unavailableSlots;
  final List<TimeSlotData> timeSlotlist;

  const TimeSlotGrid({
    super.key,
    required this.selectedSlot,
    required this.onSlotSelected,
    this.unavailableSlots = const [],
    required this.timeSlotlist,
  });

  List<String> get _slots {
    return [
      '9:00 AM - 11:00 AM',
      '11:00 AM - 1:00 PM',
      '1:00 PM - 3:00 PM',
      '3:00 PM - 5:00 PM',
      '5:00 PM - 7:00 PM',
    ];
  }

  @override
  Widget build(BuildContext context) {
    final slots = _slots;

    return timeSlotlist.isNotEmpty
        ? GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 2.6,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: timeSlotlist.length,
          itemBuilder: (context, index) {
            final slot = timeSlotlist[index];
            final isSelected = selectedSlot == slot.bookingTime;
            final isUnavailable = unavailableSlots.contains(slot.bookingTime);
            return GestureDetector(
              onTap:
                  isUnavailable ? null : () => onSlotSelected(slot),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      isSelected
                          ? AppColors.primary
                          : isUnavailable
                          ? AppColors.border.withValues(alpha: 0.3)
                          : AppColors.surface,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusMedium,
                  ),
                  border: Border.all(
                    color:
                        isSelected
                            ? AppColors.primary
                            : isUnavailable
                            ? AppColors.textPrimary.withValues(alpha: 0.2)
                            : AppColors.textPrimary.withValues(alpha: 0.4),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isUnavailable)
                      Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: Icon(
                          Icons.lock_outline,
                          size: 14,
                          color: AppColors.textTertiary.withValues(alpha: 0.5),
                        ),
                      ),
                    Flexible(
                      child: Text(
                        slot.bookingTime,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color:
                              isSelected
                                  ? AppColors.white
                                  : isUnavailable
                                  ? AppColors.textTertiary.withValues(
                                    alpha: 0.5,
                                  )
                                  : AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        )
        : SizedBox();
  }
}
