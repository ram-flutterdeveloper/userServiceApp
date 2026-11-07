import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';
import 'package:user_servicehub/data/models/MyBookingResponse.dart';
import 'package:user_servicehub/data/models/booking_status.dart';

class TrackPage extends StatelessWidget {
  final BookingHistoryItem booking;

  const TrackPage({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final status = BookingStatus.fromValue(booking.status);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Track Booking',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        children: [
          _buildHeader(status),
          const SizedBox(height: AppDimensions.spacing16),
          _buildProviderCard(),
          const SizedBox(height: AppDimensions.spacing16),
          _buildTimeline(status),
        ],
      ),
    );
  }

  Widget _buildHeader(BookingStatus status) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [_statusColor(status).withValues(alpha: 0.1), _statusColor(status).withValues(alpha: 0.04)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: _statusColor(status).withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _statusColor(status).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
            child: Icon(status.isCancelled ? Icons.cancel_rounded : Icons.track_changes_rounded, color: _statusColor(status), size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _statusLabel(status),
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _statusColor(status),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Booking #${booking.bookingNumber}',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProviderCard() {
    final provider = booking.provider;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
            child: Icon(provider?.profileImage != null ? Icons.person_rounded : Icons.badge_outlined, color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: provider != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.businessName.isNotEmpty ? provider.businessName : provider.ownerName,
                        style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        provider.phone.isNotEmpty ? provider.phone : provider.email,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  )
                : Text(
                    'Provider will be assigned soon',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
          ),
          if (provider != null)
            IconButton(
              icon: const Icon(Icons.chat_outlined, color: AppColors.primary),
              onPressed: () {},
            ),
        ],
      ),
    );
  }

  Widget _buildTimeline(BookingStatus current) {
    final steps = _timelineSteps();
    final currentIndex = _currentIndex(current);
    final cancelled = current.isCancelled;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Progress',
            style: AppTextStyles.titleSmall.copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
          const SizedBox(height: AppDimensions.spacing16),
          if (cancelled)
            _cancelledBanner()
          else
            ...List.generate(steps.length, (i) {
              final active = i <= currentIndex;
              return _timelineItem(steps[i], active: active, isLast: i == steps.length - 1);
            }),
        ],
      ),
    );
  }

  Widget _cancelledBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.cancel_rounded, color: AppColors.error),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'This booking was cancelled.',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _timelineItem(String label, {required bool active, required bool isLast}) {
    final color = active ? AppColors.success : AppColors.textTertiary;
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: active ? color : Colors.transparent,
                    border: Border.all(color: color, width: 2),
                  ),
                  child: active ? const Icon(Icons.check, size: 10, color: AppColors.white) : null,
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 2, color: active ? color : AppColors.border),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
              child: Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: active ? AppColors.textPrimary : AppColors.textTertiary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<String> _timelineSteps() {
    return const [
      'Booking Placed',
      'Provider Assigned',
      'Provider Accepted',
      'On The Way',
      'Arrived / Working',
      'Completed',
    ];
  }

  int _currentIndex(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
      case BookingStatus.confirmed:
        return 0;
      case BookingStatus.providerAssigned:
        return 1;
      case BookingStatus.providerAccepted:
        return 2;
      case BookingStatus.onTheWay:
        return 3;
      case BookingStatus.arrived:
      case BookingStatus.working:
      case BookingStatus.started:
        return 4;
      case BookingStatus.completed:
        return 5;
      case BookingStatus.cancelled:
      case BookingStatus.providerRejected:
        return 0;
    }
  }

  Color _statusColor(BookingStatus status) {
    if (status.isCancelled) return AppColors.error;
    if (status == BookingStatus.completed) return AppColors.success;
    if (status.isInProgress) return AppColors.info;
    return AppColors.accent;
  }

  String _statusLabel(BookingStatus status) {
    if (status.isCancelled) return 'Cancelled';
    if (status == BookingStatus.completed) return 'Completed';
    if (status.isInProgress) return 'In Progress';
    return 'Upcoming';
  }
}
