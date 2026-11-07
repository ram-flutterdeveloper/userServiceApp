import 'package:flutter/material.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/data/models/payment_method_model.dart';

class PaymentMethodCard extends StatelessWidget {
  final PaymentMethodModel method;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.method,
    required this.isSelected,
    required this.onTap,
  });

  IconData _typeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'upi':
        return Icons.phone_android_rounded;
      case 'credit_card':
        return Icons.credit_card_rounded;
      case 'debit_card':
        return Icons.credit_card_rounded;
      case 'net_banking':
        return Icons.account_balance_rounded;
      case 'wallet':
        return Icons.account_balance_wallet_rounded;
      case 'cash':
        return Icons.money_rounded;
      default:
        return Icons.payment_rounded;
    }
  }

  Color _typeColor(String type) {
    switch (type.toLowerCase()) {
      case 'upi':
        return AppColors.success;
      case 'credit_card':
        return AppColors.primary;
      case 'debit_card':
        return AppColors.info;
      case 'net_banking':
        return AppColors.accent;
      case 'wallet':
        return AppColors.secondary;
      case 'cash':
        return AppColors.success;
      default:
        return AppColors.textTertiary;
    }
  }

  String _detailsText() {
    switch (method.type.toLowerCase()) {
      case 'upi':
        if (method.upiId != null && method.upiId!.isNotEmpty) {
          return method.upiId!;
        }
        return 'Google Pay, PhonePe, Paytm';
      case 'credit_card':
        if (method.lastFour.isNotEmpty) {
          return '•••• ${method.lastFour}';
        }
        return 'Visa, Mastercard, RuPay';
      case 'debit_card':
        if (method.lastFour.isNotEmpty) {
          return '•••• ${method.lastFour}';
        }
        return 'Visa, Mastercard, RuPay';
      case 'net_banking':
        return 'All major banks';
      case 'wallet':
        return method.lastFour.isNotEmpty ? '₹${method.lastFour} available' : 'Available balance';
      case 'cash':
        return 'Pay after service completes';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _typeColor(method.type);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border.withValues(alpha: 0.4),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: isSelected ? color.withValues(alpha: 0.12) : AppColors.border.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: Icon(
                _typeIcon(method.type),
                color: isSelected ? color : AppColors.textTertiary,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _detailsText(),
                    style: TextStyle(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: method.id,
              groupValue: isSelected ? method.id : null,
              onChanged: (_) => onTap(),
              activeColor: AppColors.primary,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }
}
