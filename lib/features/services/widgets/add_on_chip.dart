import 'package:flutter/material.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';

class AddOnChip extends StatefulWidget {
  final String label;
  final String price;
  final bool initiallySelected;
  final ValueChanged<int>? onQuantityChanged;

  const AddOnChip({
    super.key,
    required this.label,
    required this.price,
    this.initiallySelected = false,
    this.onQuantityChanged,
  });

  @override
  State<AddOnChip> createState() => _AddOnChipState();
}

class _AddOnChipState extends State<AddOnChip> {
  late bool _selected;
  int _quantity = 0;

  @override
  void initState() {
    super.initState();
    _selected = widget.initiallySelected;
    if (_selected) _quantity = 1;
  }

  void _toggle() {
    setState(() {
      _selected = !_selected;
      _quantity = _selected ? 1 : 0;
      widget.onQuantityChanged?.call(_quantity);
    });
  }

  void _increment() {
    setState(() {
      _quantity++;
      widget.onQuantityChanged?.call(_quantity);
    });
  }

  void _decrement() {
    setState(() {
      if (_quantity > 1) {
        _quantity--;
        widget.onQuantityChanged?.call(_quantity);
      } else {
        _selected = false;
        _quantity = 0;
        widget.onQuantityChanged?.call(0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: _selected
          ? const EdgeInsets.symmetric(horizontal: 4, vertical: 4)
          : const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: _selected ? AppColors.primary : AppColors.background,
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(
          color: _selected ? AppColors.primary : AppColors.border,
        ),
      ),
      child: _selected ? _buildSelected() : _buildUnselected(),
    );
  }

  Widget _buildUnselected() {
    return GestureDetector(
      onTap: _toggle,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${widget.label} +${widget.price}',
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelected() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: _decrement,
          child: Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.remove, size: 16, color: AppColors.primary),
          ),
        ),
        const SizedBox(width: 8),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.label,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '${widget.price} x$_quantity',
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.white.withValues(alpha: 0.8),
                fontSize: 10,
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _increment,
          child: Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, size: 16, color: AppColors.primary),
          ),
        ),
      ],
    );
  }
}
