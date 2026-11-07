import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/utils/currency_formatter.dart';
import 'package:user_servicehub/data/logic/provider/booking_provider.dart';
import 'package:user_servicehub/data/models/booking_response_model.dart';

class BookingSuccessPage extends StatefulWidget {
  const BookingSuccessPage({super.key});

  @override
  State<BookingSuccessPage> createState() => _BookingSuccessPageState();
}

class _BookingSuccessPageState extends State<BookingSuccessPage> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;
  late AnimationController _confettiController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut);
    _scaleController.forward();

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bookingData = GoRouterState.of(context).extra as Map<String, dynamic>? ?? {};
    final booking = context.watch<BookingProvider>().createdBooking;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              _buildCelebrationHeader(),
              const SizedBox(height: 24),
              _buildBookingCard(booking, bookingData),
              const SizedBox(height: 24),
              _buildActionGrid(context, booking?.id ?? ''),
              const SizedBox(height: 24),
              _buildReturnHomeButton(context),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCelebrationHeader() {
    return Stack(
      alignment: Alignment.center,
      children: [
        _buildConfettiParticles(),
        AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            );
          },
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondaryLight.withValues(alpha: 0.3),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: 0.15),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Icon(Icons.check_circle_rounded, color: AppColors.secondary, size: 60),
          ),
        ),
      ],
    );
  }

  Widget _buildConfettiParticles() {
    return AnimatedBuilder(
      animation: _confettiController,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(300, 200),
          painter: _ConfettiPainter(_confettiController.value),
        );
      },
    );
  }

  Widget _buildBookingCard(BookingData? booking, Map<String, dynamic> data) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
        boxShadow: [BoxShadow(color: AppColors.border, blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Text(
            'Booking Confirmed!',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Thank you for choosing ServiceHub',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 20),
          _detailRow(Icons.receipt_long_rounded, 'Booking ID', booking?.bookingNumber ?? data['bookingId'] ?? '#SHB-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch % 1000}'),
          const Divider(height: 24),
          _detailRow(Icons.category_rounded, 'Service', booking?.packageName ?? data['serviceName'] ?? 'Professional'),
          const Divider(height: 24),
          _detailRow(Icons.person_rounded, 'Provider', data['providerName'] ?? 'Professional'),
          const Divider(height: 24),
          _detailRow(Icons.calendar_month_rounded, 'Date', booking?.bookingDate ?? data['date'] ?? 'Today'),
          const Divider(height: 24),
          _detailRow(Icons.access_time_rounded, 'Time', booking?.bookingTime ?? data['timeSlot'] ?? '10:00 AM'),
          const Divider(height: 24),
          _detailRow(Icons.location_on_rounded, 'Address', data['address'] ?? 'Address not specified'),
          const Divider(height: 24),
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                ),
                child: const Icon(Icons.payments_rounded, color: AppColors.primary, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking?.paymentMethod ?? data['paymentMethod'] ?? '',
                      style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                    Text(
                      booking?.paymentStatus == 'PAID' ? 'Paid' : 'Pay After Service',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textPrimary),
                    ),
                  ],
                ),
              ),
              Text(
                CurrencyFormatter.formatIndianRupees(
                  num.tryParse(booking?.totalAmount ?? '')?.toDouble() ?? data['total'] ?? 0,
                ),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.border.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          ),
          child: Icon(icon, color: AppColors.textTertiary, size: 18),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
              Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionGrid(BuildContext context, String bookingId) {
    final providerId = '';

    final actions = [
      _ActionItem(Icons.track_changes_rounded, 'Track\nBooking', AppColors.primary, () => context.push('/booking-details/$bookingId')),
      _ActionItem(Icons.phone_in_talk_rounded, 'Call\nProvider', AppColors.secondary, () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Calling...')));
      }),
      _ActionItem(Icons.chat_rounded, 'Chat', AppColors.info, () => context.push('/chat/$providerId')),
      _ActionItem(Icons.download_rounded, 'Download\nInvoice', AppColors.accent, () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invoice downloaded')));
      }),
      _ActionItem(Icons.share_rounded, 'Share\nBooking', AppColors.textSecondary, () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Booking shared')));
      }),
      _ActionItem(Icons.home_rounded, 'Return\nHome', AppColors.textPrimary, () => context.go('/home')),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 0.9,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: Duration(milliseconds: 400 + index * 100),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(
              scale: value,
              child: child,
            );
          },
          child: Material(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            elevation: 0,
            child: InkWell(
              onTap: action.onTap,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                  border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: action.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                      ),
                      child: Icon(action.icon, color: action.color, size: 22),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      action.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReturnHomeButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton.icon(
        onPressed: () => context.go('/home'),
        icon: const Icon(Icons.home_rounded, color: Colors.white, size: 18),
        label: const Text('Return Home', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppDimensions.radiusButton)),
          elevation: 0,
        ),
      ),
    );
  }
}

class _ActionItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  _ActionItem(this.icon, this.label, this.color, this.onTap);
}

class _ConfettiPainter extends CustomPainter {
  final double progress;

  _ConfettiPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final random = Random(42);
    final paint = Paint();
    for (int i = 0; i < 20; i++) {
      final x = random.nextDouble() * size.width;
      final y = (random.nextDouble() * size.height * 0.6) - (progress * size.height * 0.3);
      final colors = [AppColors.primary, AppColors.secondary, AppColors.accent, AppColors.info, const Color(0xFFEC4899)];
      paint.color = colors[i % colors.length].withValues(alpha: 0.4 * (1 - progress * 0.5));
      final rotation = random.nextDouble() * pi * 2;
      canvas.save();
      canvas.translate(x, y + progress * 40);
      canvas.rotate(rotation);
      canvas.drawRect(Rect.fromCenter(center: Offset.zero, width: 6, height: 6), paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => oldDelegate.progress != progress;
}
