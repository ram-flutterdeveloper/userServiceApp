import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/utils/currency_formatter.dart';
import 'package:user_servicehub/data/logic/provider/booking_provider.dart';
import 'package:user_servicehub/data/models/payment_method_model.dart';
import 'package:user_servicehub/features/payment/widgets/payment_method_card.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key, this.bookingData});

  final Map<String, dynamic>? bookingData;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

enum PayGroup { cash, online }

class _PaymentPageState extends State<PaymentPage> {
  PayGroup _selectedGroup = PayGroup.online;
  String? _selectedOnlineId;
  bool _useRewardPoints = false;
  bool _isPaying = false;

  final List<PaymentMethodModel> _onlineMethods = const [
    PaymentMethodModel(
      id: 'upi',
      type: 'upi',
      name: 'UPI',
      lastFour: '',
      isDefault: true,
      iconName: 'phone_android',
      upiId: 'user@paytm',
    ),
    PaymentMethodModel(
      id: 'credit',
      type: 'credit_card',
      name: 'Credit Card',
      lastFour: '4521',
      isDefault: false,
      iconName: 'credit_card',
    ),
    PaymentMethodModel(
      id: 'debit',
      type: 'debit_card',
      name: 'Debit Card',
      lastFour: '8876',
      isDefault: false,
      iconName: 'credit_card',
    ),
    PaymentMethodModel(
      id: 'netbanking',
      type: 'net_banking',
      name: 'Net Banking',
      lastFour: '',
      isDefault: false,
      iconName: 'account_balance',
    ),
    PaymentMethodModel(
      id: 'wallet',
      type: 'wallet',
      name: 'Wallet',
      lastFour: '250',
      isDefault: false,
      iconName: 'account_balance_wallet',
    ),
  ];

  @override
  void initState() {
    super.initState();
    final defaultMethod = _onlineMethods.where((m) => m.isDefault).firstOrNull;
    if (defaultMethod != null) _selectedOnlineId = defaultMethod.id;
  }

  Map<String, dynamic> get _data => widget.bookingData ?? {};

  double get _serviceCharge =>
      (_data['serviceCharge'] as num?)?.toDouble() ?? 79.0;
  double get _platformFee => (_data['platformFee'] as num?)?.toDouble() ?? 5.0;
  double get _gst =>
      (_data['gst'] as num?)?.toDouble() ?? (_serviceCharge + _platformFee) * 0.18;
  double get _discount => (_data['discount'] as num?)?.toDouble() ?? 0.0;
  double get _rewardDiscount => _useRewardPoints ? 2.5 : 0.0;
  double get _total =>
      _serviceCharge + _platformFee + _gst - _discount - _rewardDiscount;

  String get _paymentMethodValue {
    if (_selectedGroup == PayGroup.cash) return 'COD';
    final selected = _onlineMethods
        .where((m) => m.id == _selectedOnlineId)
        .firstOrNull;
    return selected?.type.toUpperCase() ?? 'ONLINE';
  }

  String get _paymentMethodLabel {
    if (_selectedGroup == PayGroup.cash) return 'Cash on Delivery';
    final selected = _onlineMethods
        .where((m) => m.id == _selectedOnlineId)
        .firstOrNull;
    return selected?.name ?? 'Online';
  }

  @override
  Widget build(BuildContext context) {
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
          'Payment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPaymentGroups(),
            const SizedBox(height: 20),
            if (_selectedGroup == PayGroup.online) ...[
              _buildOnlineMethods(),
              const SizedBox(height: 20),
            ],
            if (_discount > 0) ...[
              _buildCouponApplied(_discount),
              const SizedBox(height: 20),
            ],
            _buildRewardPoints(),
            const SizedBox(height: 20),
            _buildTotalPayable(),
            const SizedBox(height: 12),
            _buildSecureMessage(),
            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.border,
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton.icon(
              onPressed: _isPaying ? null : _handlePayNow,
              icon: _isPaying
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(
                      Icons.lock_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
              label: Text(
                _isPaying
                    ? 'Processing...'
                    : 'Pay ${CurrencyFormatter.formatIndianRupees(_total)}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusButton,
                  ),
                ),
                elevation: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentGroups() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Payment Method',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        _groupCard(
          group: PayGroup.online,
          icon: Icons.language_rounded,
          title: 'Online Payment',
          subtitle: 'UPI, Cards, Net Banking & more',
        ),
        const SizedBox(height: 10),
        _groupCard(
          group: PayGroup.cash,
          icon: Icons.money_rounded,
          title: 'Cash on Delivery (COD)',
          subtitle: 'Pay in cash after service',
        ),
      ],
    );
  }

  Widget _groupCard({
    required PayGroup group,
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedGroup == group;
    return GestureDetector(
      onTap: () => setState(() => _selectedGroup = group),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.border.withValues(alpha: 0.4),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryLight
                    : AppColors.border.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textTertiary,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Radio<PayGroup>(
              value: group,
              groupValue: _selectedGroup,
              onChanged: (v) {
                if (v != null) setState(() => _selectedGroup = v);
              },
              activeColor: AppColors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOnlineMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Online Methods',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ..._onlineMethods.map(
          (method) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: PaymentMethodCard(
              method: method,
              isSelected: _selectedOnlineId == method.id,
              onTap: () => setState(() => _selectedOnlineId = method.id),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCouponApplied(double discount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.secondaryLight.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.secondaryLight),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.secondaryLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            child: const Icon(
              Icons.discount_rounded,
              color: AppColors.secondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Coupon Applied',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.secondary,
                  ),
                ),
                Text(
                  'SAVE20 - ${CurrencyFormatter.formatIndianRupees(discount)} saved',
                  style: TextStyle(fontSize: 11, color: AppColors.secondary),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            child: Text(
              '-${CurrencyFormatter.formatIndianRupees(discount)}',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardPoints() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.accentLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            child: const Icon(
              Icons.card_giftcard_rounded,
              color: AppColors.accent,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reward Points',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Use 250 points = ₹2.50',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Switch(
            value: _useRewardPoints,
            onChanged: (v) => setState(() => _useRewardPoints = v),
            activeColor: AppColors.primary,
            activeTrackColor: AppColors.primaryLight,
          ),
        ],
      ),
    );
  }

  Widget _buildTotalPayable() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
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
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusSmall,
                  ),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: AppColors.primary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Total Payable',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _payRow('Item Total', CurrencyFormatter.formatIndianRupees(_serviceCharge)),
          if (_discount > 0) ...[
            const SizedBox(height: 8),
            _payRow(
              'Discount',
              '-${CurrencyFormatter.formatIndianRupees(_discount)}',
              color: AppColors.success,
            ),
          ],
          const SizedBox(height: 8),
          _payRow('Platform Fee', CurrencyFormatter.formatIndianRupees(_platformFee)),
          const SizedBox(height: 8),
          _payRow('GST (18%)', CurrencyFormatter.formatIndianRupees(_gst)),
          if (_rewardDiscount > 0) ...[
            const SizedBox(height: 8),
            _payRow(
              'Reward Discount',
              '-${CurrencyFormatter.formatIndianRupees(_rewardDiscount)}',
              color: AppColors.success,
            ),
          ],
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                CurrencyFormatter.formatIndianRupees(_total),
                style: TextStyle(
                  fontSize: 22,
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

  Widget _payRow(String label, String amount, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildSecureMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.lock_rounded, size: 14, color: AppColors.textTertiary),
        const SizedBox(width: 6),
        Text(
          '100% Secure Payment',
          style: TextStyle(fontSize: 12, color: AppColors.textTertiary),
        ),
      ],
    );
  }

  Future<void> _handlePayNow() async {
    if (_selectedGroup == PayGroup.online && _selectedOnlineId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an online payment method')),
      );
      return;
    }

    setState(() => _isPaying = true);

    final bookingProvider = context.read<BookingProvider>();
    final success = await bookingProvider.creatBookings(
      context,
      paymentMethod: _paymentMethodValue,
      notes: _data['notes'] as String?,
    );

    if (!mounted) return;

    if (!success) {
      setState(() => _isPaying = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to create booking. Please try again.')),
      );
      return;
    }

    final successData = {
      ..._data,
      'total': _total.floor(),
      'paymentMethod': _paymentMethodLabel,
      'bookingId':
          'SHB-${DateTime.now().year}-${DateTime.now().millisecondsSinceEpoch % 10000}',
    };

    context.pushReplacement('/booking-success', extra: successData);
  }
}
