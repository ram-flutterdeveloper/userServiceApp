import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';
import 'package:user_servicehub/core/widgets/app_error_state.dart';
import 'package:user_servicehub/core/widgets/app_loading_indicator.dart';
import 'package:user_servicehub/data/logic/provider/booking_details_provider.dart';
import 'package:user_servicehub/data/models/MyBookingResponse.dart';
import 'package:user_servicehub/data/models/booking_response_model.dart';
import 'package:user_servicehub/data/models/booking_status.dart';

class BookingDetailsPage extends StatefulWidget {
  final String bookingId;
  const BookingDetailsPage({super.key, required this.bookingId});

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingDetailsProvider>().fetchBooking(widget.bookingId);
    });
  }

  Color _statusColor(BookingStatus status) {
    if (status.isCancelled) return AppColors.error;
    if (status == BookingStatus.completed) return AppColors.success;
    if (status.isInProgress) return AppColors.info;
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BookingDetailsProvider>();

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
          'Booking Details',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: _buildBody(context, provider),
    );
  }

  Widget _buildBody(BuildContext context, BookingDetailsProvider provider) {
    if (provider.error != null && provider.booking == null) {
      return AppErrorState(
        message: provider.error!,
        onRetry:
            () => context.read<BookingDetailsProvider>().fetchBooking(
              widget.bookingId,
            ),
      );
    }

    if (provider.isLoading && provider.booking == null) {
      return const AppFullScreenLoader();
    }

    final booking = provider.booking;
    if (booking == null) {
      return const AppFullScreenLoader();
    }

    final status = BookingStatus.fromValue(booking.status);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusBanner(status, booking),
          const SizedBox(height: 20),
          _buildInfoSection(booking),
          const SizedBox(height: 20),
          _buildProviderSection(booking),
          const SizedBox(height: 20),
          if (booking.items.isNotEmpty) ...[
            _buildItemsSection(booking.items),
            const SizedBox(height: 20),
          ],
          _buildPriceSection(booking),
          const SizedBox(height: 20),
          _buildActionButtons(status, booking),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildStatusBanner(BookingStatus status, BookingHistoryItem booking) {
    final color = _statusColor(status);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.1), color.withValues(alpha: 0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            child: Icon(
              status.isCancelled ? Icons.cancel_rounded : Icons.build_rounded,
              color: color,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _statusLabel(status),
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w700,
                    color: color,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Booking #${booking.bookingNumber}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(BookingHistoryItem booking) {
    final address = booking.address;
    return _section(
      title: 'Service Details',
      icon: Icons.build_rounded,
      iconColor: AppColors.primary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (booking.items.isNotEmpty)
            Text(
              booking.items.first.packageName,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          const SizedBox(height: 16),
          _infoRow(
            Icons.calendar_month_rounded,
            'Date',
            _formatDate(booking.bookingDate),
          ),
          const SizedBox(height: 14),
          _infoRow(Icons.access_time_rounded, 'Time', booking.bookingTime),
          const SizedBox(height: 14),
          _infoRow(
            Icons.payment_rounded,
            'Payment',
            '${booking.paymentMethod} · ${booking.paymentStatus}',
          ),
          if (address != null) ...[
            const SizedBox(height: 14),
            _infoRow(
              Icons.location_on_rounded,
              'Address',
              address.fullDisplayAddress,
            ),
          ],
          if (booking.notes != null && booking.notes!.isNotEmpty) ...[
            const SizedBox(height: 14),
            _infoRow(Icons.notes_rounded, 'Notes', booking.notes!),
          ],
        ],
      ),
    );
  }

  Widget _buildProviderSection(BookingHistoryItem booking) {
    final provider = booking.provider;
    return _section(
      title: 'Service Provider',
      icon: Icons.person_rounded,
      iconColor: AppColors.secondary,
      child:
          provider != null
              ? Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusMedium,
                      ),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          provider.businessName.isNotEmpty
                              ? provider.businessName
                              : provider.ownerName,
                          style: AppTextStyles.titleSmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          provider.phone.isNotEmpty
                              ? provider.phone
                              : provider.email,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
              : Text(
                'A provider will be assigned to your booking soon.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
    );
  }

  Widget _buildItemsSection(List<BookingHistoryLineItem> items) {
    return _section(
      title: 'Items',
      icon: Icons.shopping_bag_outlined,
      iconColor: AppColors.accent,
      child: Column(
        children:
            items.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.packageName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Text(
                      'x${item.quantity}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '₹${item.totalPrice}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildPriceSection(BookingHistoryItem booking) {
    return _section(
      title: 'Price Breakdown',
      icon: Icons.receipt_long_rounded,
      iconColor: AppColors.primary,
      child: Column(
        children: [
          _priceRow('Subtotal', '₹${booking.subtotal}'),
          const SizedBox(height: 8),
          _priceRow(
            'Discount',
            '- ₹${booking.discount}',
            color: AppColors.success,
          ),
          const SizedBox(height: 8),
          _priceRow('Tax', '₹${booking.tax}'),
          const SizedBox(height: 8),
          _priceRow('Extra Charge', '₹${booking.extraCharge}'),
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                '₹${booking.totalAmount}',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BookingStatus status, BookingHistoryItem booking) {
    return _section(
      title: 'Quick Actions',
      icon: Icons.bolt_rounded,
      iconColor: AppColors.info,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          _actionChip(
            Icons.track_changes_rounded,
            'Track',
            AppColors.primary,
            () {
              context.push('/booking-track', extra: booking);
            },
          ),
          if (booking.provider != null) ...[
            _actionChip(Icons.chat_rounded, 'Chat', AppColors.info, () {
              context.push('/chat/${booking.provider!.id}');
            }),
            _actionChip(
              Icons.phone_in_talk_rounded,
              'Call',
              AppColors.secondary,
              () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Calling provider...')),
                );
              },
            ),
          ],
          if (!status.isCancelled && status != BookingStatus.completed)
            _actionChip(
              Icons.cancel_outlined,
              context.watch<BookingDetailsProvider>().isCancelling
                  ? 'Cancelling...'
                  : 'Cancel',
              AppColors.error,
              context.watch<BookingDetailsProvider>().isCancelling
                  ? null
                  : () => _showCancelDialog(context, booking),
            ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context, BookingHistoryItem booking) {
    final reasonController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            backgroundColor: AppColors.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
            title: const Text('Cancel Booking'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Are you sure you want to cancel this booking?',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: reasonController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    hintText: 'Reason (optional)',
                    hintStyle: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusInput,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  reasonController.dispose();
                  Navigator.pop(ctx);
                },
                child: Text(
                  'Keep Booking',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
              FilledButton(
                onPressed: () async {
                  final confirmation = reasonController.text;
                  Navigator.pop(ctx);
                  reasonController.dispose();
                  await _cancelBooking(
                    context,
                    booking.id,
                    reason: confirmation,
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.error,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSmall,
                    ),
                  ),
                ),
                child: const Text('Cancel Booking'),
              ),
            ],
          ),
    );
  }

  Future<void> _cancelBooking(
    BuildContext context,
    String bookingId, {
    String? reason,
  }) async {
    final provider = context.read<BookingDetailsProvider>();
    final success = await provider.cancelBooking(bookingId, reason: reason);

    if (!mounted) return;

    if (success) {
      await context.read<BookingDetailsProvider>().fetchBooking(
        bookingId,
        refresh: true,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Booking cancelled')));
    } else {
      final message =
          context.read<BookingDetailsProvider>().error ??
          'Failed to cancel booking';
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }
  }

  Widget _section({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.border,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusSmall,
                  ),
                ),
                child: Icon(icon, color: iconColor, size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: AppTextStyles.titleSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.border.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          ),
          child: Icon(icon, color: AppColors.textTertiary, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _priceRow(String label, String amount, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          amount,
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _actionChip(
    IconData icon,
    String label,
    Color color,
    VoidCallback? onTap,
  ) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _statusLabel(BookingStatus status) {
    if (status.isCancelled) return 'Cancelled';
    if (status == BookingStatus.completed) return 'Completed';
    if (status.isInProgress) return 'In Progress';
    return 'Upcoming';
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }
}
