// import 'package:flutter/material.dart';
// import 'package:user_servicehub/core/constants/app_colors.dart';
// import 'package:user_servicehub/core/constants/app_dimensions.dart';
// import 'package:user_servicehub/core/theme/app_text_styles.dart';
// import 'package:user_servicehub/data/models/booking_model.dart';

// class BookingCard extends StatelessWidget {
//   final BookingModel booking;
//   final Map<String, VoidCallback>? onAction;

//   const BookingCard({super.key, required this.booking, this.onAction});

//   @override
//   Widget build(BuildContext context) {
//     final statusColor = _statusColor(booking.status);
//     final statusLabel = _statusLabel(booking.status);

//     return Container(
//       margin: const EdgeInsets.only(bottom: 14),
//       decoration: BoxDecoration(
//         color: AppColors.surface,
//         borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
//         border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
//         boxShadow: [
//           BoxShadow(
//             color: AppColors.shadow,
//             blurRadius: 8,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(AppDimensions.spacing16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildHeaderRow(statusColor, statusLabel),
//             const SizedBox(height: 14),
//             Container(height: 1, color: AppColors.border),
//             const SizedBox(height: 14),
//             _buildInfoRow(),
//             const SizedBox(height: 14),
//             Container(height: 1, color: AppColors.border),
//             const SizedBox(height: 14),
//             _buildActionButtons(context),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeaderRow(Color statusColor, String statusLabel) {
//     return Row(
//       children: [
//         Container(
//           width: 44,
//           height: 44,
//           decoration: BoxDecoration(
//             color: AppColors.primaryLight,
//             borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
//           ),
//           child: Icon(Icons.build_outlined, color: AppColors.primary, size: 22),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 booking.serviceName,
//                 style: AppTextStyles.titleSmall.copyWith(
//                   fontWeight: FontWeight.w600,
//                   color: AppColors.textPrimary,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 booking.providerName,
//                 style: AppTextStyles.bodySmall.copyWith(
//                   color: AppColors.textSecondary,
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Container(
//           padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//           decoration: BoxDecoration(
//             color: statusColor.withValues(alpha: 0.12),
//             borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
//           ),
//           child: Text(
//             statusLabel,
//             style: AppTextStyles.labelSmall.copyWith(
//               color: statusColor,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildInfoRow() {
//     return Row(
//       children: [
//         _infoChip(Icons.calendar_today_outlined, booking.date),
//         const SizedBox(width: 16),
//         _infoChip(Icons.access_time_outlined, booking.timeSlot),
//         const Spacer(),
//         Text(
//           '\u20B9${booking.totalAmount.toStringAsFixed(0)}',
//           style: AppTextStyles.titleSmall.copyWith(
//             fontWeight: FontWeight.w700,
//             color: AppColors.textPrimary,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _infoChip(IconData icon, String text) {
//     return Row(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(icon, size: 14, color: AppColors.textTertiary),
//         const SizedBox(width: 4),
//         Text(
//           text,
//           style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
//         ),
//       ],
//     );
//   }

//   Widget _buildActionButtons(BuildContext context) {
//     switch (booking.status) {
//       case 'upcoming':
//         return Row(
//           children: [
//             Expanded(
//               child: _actionButton(
//                 'Details',
//                 Icons.navigation,
//                 AppColors.primary,
//                 onAction?['track'],
//               ),
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: _actionButton(
//                 'Chat',
//                 Icons.chat_outlined,
//                 AppColors.info,
//                 onAction?['chat'],
//               ),
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: _actionButton(
//                 'Call',
//                 Icons.call_outlined,
//                 AppColors.success,
//                 onAction?['call'],
//               ),
//             ),
//           ],
//         );
//       case 'active':
//         return Row(
//           children: [
//             Expanded(
//               child: _actionButton(
//                 'Track',
//                 Icons.navigation,
//                 AppColors.primary,
//                 onAction?['track'],
//               ),
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: _actionButton(
//                 'Chat',
//                 Icons.chat_outlined,
//                 AppColors.info,
//                 onAction?['chat'],
//               ),
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: _actionButton(
//                 'Call',
//                 Icons.call_outlined,
//                 AppColors.success,
//                 onAction?['call'],
//               ),
//             ),
//           ],
//         );
//       case 'completed':
//         return Row(
//           children: [
//             Expanded(
//               child: _actionButton(
//                 'Review',
//                 Icons.star_outline,
//                 AppColors.accent,
//                 onAction?['review'],
//               ),
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: _actionButton(
//                 'Book Again',
//                 Icons.replay,
//                 AppColors.primary,
//                 onAction?['bookAgain'],
//               ),
//             ),
//             const SizedBox(width: 8),
//             Expanded(
//               child: _outlinedButton(
//                 'Invoice',
//                 Icons.receipt_outlined,
//                 onAction?['invoice'],
//               ),
//             ),
//           ],
//         );
//       case 'cancelled':
//         return Row(
//           children: [
//             Expanded(
//               child: _actionButton(
//                 'Book Again',
//                 Icons.replay,
//                 AppColors.primary,
//                 onAction?['bookAgain'],
//               ),
//             ),
//           ],
//         );
//       default:
//         return const SizedBox.shrink();
//     }
//   }

//   Widget _actionButton(
//     String label,
//     IconData icon,
//     Color color,
//     VoidCallback? onTap,
//   ) {
//     return SizedBox(
//       height: 38,
//       child: FilledButton.icon(
//         onPressed: onTap,
//         icon: Icon(icon, size: 16),
//         label: Text(label, style: AppTextStyles.buttonMedium),
//         style: FilledButton.styleFrom(
//           backgroundColor: color.withValues(alpha: 0.12),
//           foregroundColor: color,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
//           ),
//           elevation: 0,
//           padding: const EdgeInsets.symmetric(horizontal: 8),
//         ),
//       ),
//     );
//   }

//   Widget _outlinedButton(String label, IconData icon, VoidCallback? onTap) {
//     return SizedBox(
//       height: 38,
//       child: OutlinedButton.icon(
//         onPressed: onTap,
//         icon: Icon(icon, size: 16),
//         label: Text(label, style: AppTextStyles.buttonMedium),
//         style: OutlinedButton.styleFrom(
//           foregroundColor: AppColors.textSecondary,
//           side: const BorderSide(color: AppColors.border),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
//           ),
//           padding: const EdgeInsets.symmetric(horizontal: 8),
//         ),
//       ),
//     );
//   }

//   Color _statusColor(String status) {
//     switch (status) {
//       case 'upcoming':
//         return AppColors.info;
//       case 'active':
//         return AppColors.success;
//       case 'completed':
//         return AppColors.secondary;
//       case 'cancelled':
//         return AppColors.error;
//       default:
//         return AppColors.textTertiary;
//     }
//   }

//   String _statusLabel(String status) {
//     switch (status) {
//       case 'upcoming':
//         return 'Bookings';
//       case 'active':
//         return 'Active';
//       case 'completed':
//         return 'Completed';
//       case 'cancelled':
//         return 'Cancelled';
//       default:
//         return status;
//     }
//   }
// }

import 'package:flutter/material.dart';

import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';
import 'package:user_servicehub/data/models/MyBookingResponse.dart';

class BookingCard extends StatelessWidget {
  final BookingHistoryItem booking;
  final Map<String, VoidCallback>? onAction;

  const BookingCard({super.key, required this.booking, this.onAction});

  String get _serviceName {
    if (booking.items.isNotEmpty &&
        booking.items.first.packageName.isNotEmpty) {
      return booking.items.first.packageName;
    }

    return booking.bookingNumber;
  }

  String get _providerName {
    final businessName = booking.provider?.businessName ?? '';
    if (businessName.isNotEmpty) return businessName;

    final ownerName = booking.provider?.ownerName ?? '';
    if (ownerName.isNotEmpty) return ownerName;

    return 'Not assigned';
  }

  String get _displayStatus {
    switch (booking.status.toUpperCase()) {
      case 'PENDING':
      case 'CONFIRMED':
        return 'upcoming';

      case 'ONGOING':
      case 'IN_PROGRESS':
      case 'STARTED':
      case 'ON_THE_WAY':
      case 'ARRIVED':
        return 'active';

      case 'COMPLETED':
      case 'DONE':
        return 'completed';

      case 'CANCELLED':
      case 'CANCELED':
      case 'REJECTED':
      case 'PROVIDER_REJECTED':
        return 'cancelled';

      default:
        return booking.status.toLowerCase();
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(_displayStatus);
    final statusLabel = _statusLabel(_displayStatus);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderRow(statusColor, statusLabel),
            const SizedBox(height: 14),
            Container(height: 1, color: AppColors.border),
            const SizedBox(height: 14),
            _buildInfoRow(),
            const SizedBox(height: 14),
            Container(height: 1, color: AppColors.border),
            const SizedBox(height: 14),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow(Color statusColor, String statusLabel) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          child: const Icon(
            Icons.build_outlined,
            color: AppColors.primary,
            size: 22,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _serviceName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _providerName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                booking.bookingNumber,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          ),
          child: Text(
            statusLabel,
            style: AppTextStyles.labelSmall.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow() {
    final amount = double.tryParse(booking.totalAmount) ?? 0;

    return Wrap(
      spacing: 16,
      runSpacing: 10,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        _infoChip(
          Icons.calendar_today_outlined,
          _formatDate(booking.bookingDate!),
        ),
        _infoChip(Icons.access_time_outlined, booking.bookingTime),
        Text(
          '₹${amount.toStringAsFixed(0)}',
          style: AppTextStyles.titleSmall.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }
  Widget _infoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.textTertiary),
        const SizedBox(width: 4),
        Text(
          text,
          style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    switch (_displayStatus) {
      case 'upcoming':
        return Row(
          children: [
            Expanded(
              child: _actionButton(
                'Details',
                Icons.navigation,
                AppColors.primary,
                onAction?['track'],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _actionButton(
                'Chat',
                Icons.chat_outlined,
                AppColors.info,
                onAction?['chat'],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _actionButton(
                'Cancel',
                Icons.cancel_outlined,
                AppColors.error,
                onAction?['cancel'],
              ),
            ),
          ],
        );

      case 'active':
        return Row(
          children: [
            Expanded(
              child: _actionButton(
                'Track',
                Icons.navigation,
                AppColors.primary,
                onAction?['track'],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _actionButton(
                'Chat',
                Icons.chat_outlined,
                AppColors.info,
                onAction?['chat'],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _actionButton(
                'Call',
                Icons.call_outlined,
                AppColors.success,
                onAction?['call'],
              ),
            ),
          ],
        );

      case 'completed':
        return Row(
          children: [
            Expanded(
              child: _actionButton(
                'Review',
                Icons.star_outline,
                AppColors.accent,
                onAction?['review'],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _actionButton(
                'Book Again',
                Icons.replay,
                AppColors.primary,
                onAction?['bookAgain'],
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _outlinedButton(
                'Invoice',
                Icons.receipt_outlined,
                onAction?['invoice'],
              ),
            ),
          ],
        );

      case 'cancelled':
        return Row(
          children: [
            Expanded(
              child: _actionButton(
                'Book Again',
                Icons.replay,
                AppColors.primary,
                onAction?['bookAgain'],
              ),
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _actionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback? onTap,
  ) {
    return SizedBox(
      height: 38,
      child: FilledButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(
          label,
          style: AppTextStyles.buttonMedium,
          overflow: TextOverflow.ellipsis,
        ),
        style: FilledButton.styleFrom(
          backgroundColor: color.withValues(alpha: 0.12),
          foregroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 6),
        ),
      ),
    );
  }

  Widget _outlinedButton(String label, IconData icon, VoidCallback? onTap) {
    return SizedBox(
      height: 38,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(
          label,
          style: AppTextStyles.buttonMedium,
          overflow: TextOverflow.ellipsis,
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textSecondary,
          side: const BorderSide(color: AppColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 6),
        ),
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'upcoming':
        return AppColors.info;
      case 'active':
        return AppColors.success;
      case 'completed':
        return AppColors.secondary;
      case 'cancelled':
        return AppColors.error;
      default:
        return AppColors.textTertiary;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'upcoming':
        return 'Pending';
      case 'active':
        return 'Active';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status.replaceAll('_', ' ');
    }
  }
}
