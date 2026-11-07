import 'package:flutter/material.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/data/models/user_address_model.dart';

class AddressSelector extends StatelessWidget {
  final List<UserAddressModel> addresses;
  final String? selectedId;
  final ValueChanged<String> onSelected;
  final VoidCallback onAddNew;

  const AddressSelector({
    super.key,
    required this.addresses,
    required this.selectedId,
    required this.onSelected,
    required this.onAddNew,
  });

  IconData _typeIcon(String type) {
    switch (type.toUpperCase()) {
      case 'HOME':
        return Icons.home_rounded;
      case 'WORK':
        return Icons.business_rounded;
      default:
        return Icons.location_on_rounded;
    }
  }

  Color _typeColor(String type) {
    switch (type.toUpperCase()) {
      case 'HOME':
        return AppColors.primary;
      case 'WORK':
        return AppColors.accent;
      default:
        return AppColors.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...addresses.map((address) {
          final isSelected = selectedId == address.id;
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => onSelected(address.id),
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
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isSelected ? _typeColor(address.addressType).withValues(alpha: 0.12) : AppColors.border.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                      ),
                      child: Icon(_typeIcon(address.addressType), color: isSelected ? _typeColor(address.addressType) : AppColors.textTertiary, size: 22),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: _typeColor(address.addressType).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  address.addressType,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: _typeColor(address.addressType),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 6),
                              if (address.isDefault)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.secondaryLight,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Default',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.secondary,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            address.addressLine.isNotEmpty
                                ? address.addressLine
                                : address.fullDisplayAddress,
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Radio<String>(
                      value: address.id,
                      groupValue: selectedId,
                      onChanged: (v) {
                        if (v != null) onSelected(v);
                      },
                      activeColor: AppColors.primary,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        GestureDetector(
          onTap: onAddNew,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                  ),
                  child: const Icon(Icons.add, color: AppColors.primary, size: 18),
                ),
                const SizedBox(width: 10),
                Text(
                  'Add New Address',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios, color: AppColors.textTertiary, size: 14),
              ],
            ),
          ),
        ),
     
      ],
    );
  }
}
