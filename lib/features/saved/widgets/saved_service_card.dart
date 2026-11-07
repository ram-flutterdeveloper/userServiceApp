import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';
import 'package:user_servicehub/core/utils/image_utils.dart';
import 'package:user_servicehub/core/widgets/app_badge.dart';
import 'package:user_servicehub/core/widgets/app_rating.dart';
import 'package:user_servicehub/data/models/service_model.dart';

class SavedServiceCard extends StatefulWidget {
  final ServiceModel service;
  final VoidCallback onBook;
  final VoidCallback onRemove;
  final VoidCallback onShare;
  final bool selectionMode;
  final bool isSelected;
  final ValueChanged<bool?>? onSelect;

  const SavedServiceCard({
    super.key,
    required this.service,
    required this.onBook,
    required this.onRemove,
    required this.onShare,
    this.selectionMode = false,
    this.isSelected = false,
    this.onSelect,
  });

  @override
  State<SavedServiceCard> createState() => _SavedServiceCardState();
}

class _SavedServiceCardState extends State<SavedServiceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _heartController;
  late Animation<double> _heartScale;
  bool _isFavorited = true;

  @override
  void initState() {
    super.initState();
    _heartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heartScale = Tween<double>(begin: 1.0, end: 1.4).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _heartController.dispose();
    super.dispose();
  }

  void _toggleFavorite() {
    _heartController.forward().then((_) {
      _heartController.reverse();
      widget.onRemove();
    });
    setState(() => _isFavorited = !_isFavorited);
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.service;
    final discountedPrice = s.price * (1 - s.discountPercentage / 100);

    return Dismissible(
      key: Key('saved_${s.id}'),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppDimensions.spacing24),
        margin: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing20,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: AppColors.white,
          size: 28,
        ),
      ),
      onDismissed: (_) => widget.onRemove(),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing20,
          vertical: 6,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageSection(s, discountedPrice),
              Padding(
                padding: const EdgeInsets.all(AppDimensions.spacing16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTitleRow(s),
                    const SizedBox(height: AppDimensions.spacing4),
                    _buildCategoryRow(s),
                    const SizedBox(height: AppDimensions.spacing4),
                    _buildStatsRow(s),
                    const SizedBox(height: AppDimensions.spacing4),
                    _buildInfoRow(s),
                    if (s.discountPercentage > 0) ...[
                      const SizedBox(height: AppDimensions.spacing4),
                      _buildDiscountChip(s),
                    ],
                    const SizedBox(height: AppDimensions.spacing4),
                    _buildActionRow(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection(ServiceModel s, double discountedPrice) {
    return Container(
      height: AppDimensions.cardImageHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryLight.withValues(alpha: 0.5),
            const Color(0xFF8B5CF6).withValues(alpha: 0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusCard),
        ),
      ),
      child: Stack(
        children: [
          if (s.imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppDimensions.radiusCard),
              ),
              child: CachedNetworkImage(
                imageUrl: ImageUtils.resolveImageUrl(s.imageUrl) ?? '',
                width: double.infinity,
                height: AppDimensions.cardImageHeight,
                fit: BoxFit.contain,
                errorWidget: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          if (s.discountPercentage > 0)
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                  ),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x4DEF4444),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  '${s.discountPercentage.toStringAsFixed(0)}% OFF',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          Positioned(
            top: 12,
            left: 12,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusFull,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star, size: 14, color: AppColors.accent),
                      const SizedBox(width: 4),
                      Text(
                        s.rating.toStringAsFixed(1),
                        style: AppTextStyles.labelSmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (widget.selectionMode) const SizedBox(width: 8),
                if (widget.selectionMode)
                  Checkbox(
                    value: widget.isSelected,
                    onChanged: widget.onSelect,
                    activeColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleRow(ServiceModel s) {
    return Row(
      children: [
        Expanded(
          child: Text(
            s.title,
            style: AppTextStyles.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        ScaleTransition(
          scale: _heartScale,
          child: IconButton(
            icon: Icon(
              _isFavorited ? Icons.favorite : Icons.favorite_border,
              color: _isFavorited ? AppColors.error : AppColors.textTertiary,
              size: 22,
            ),
            onPressed: _toggleFavorite,
            splashRadius: 20,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryRow(ServiceModel s) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          ),
          child: Text(
            s.categoryName,
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(s.providerName, style: AppTextStyles.bodySmall),
        if (s.isVerified) ...[
          const SizedBox(width: 4),
          const VerifiedBadge(size: 14),
        ],
      ],
    );
  }

  Widget _buildStatsRow(ServiceModel s) {
    return Row(
      children: [
        AppRating(rating: s.rating, size: 14, count: 5),
        const SizedBox(width: AppDimensions.spacing8),
        Text(
          '${s.completedJobs} jobs',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const Spacer(),
        Icon(
          Icons.location_on_outlined,
          size: 14,
          color: AppColors.textTertiary,
        ),
        const SizedBox(width: 2),
        Text(
          '${s.distance.toStringAsFixed(1)} km',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(ServiceModel s) {
    final discountedPrice = s.price * (1 - s.discountPercentage / 100);
    return Row(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '\u20B9${discountedPrice.toStringAsFixed(0)}',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (s.discountPercentage > 0) ...[
                  const SizedBox(width: 6),
                  Text(
                    '\u20B9${s.price.toStringAsFixed(0)}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textTertiary,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 2),
            Text(
              s.duration,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const Spacer(),
        _buildFeatureChip('Available'),
        const SizedBox(width: 6),
        _buildFeatureChip(s.responseTime),
      ],
    );
  }

  Widget _buildFeatureChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.secondaryLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.success,
          fontSize: 9,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildDiscountChip(ServiceModel s) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.accentLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.local_offer, size: 12, color: AppColors.accent),
          const SizedBox(width: 4),
          Text(
            'Save \u20B9${(s.price * s.discountPercentage / 100).toStringAsFixed(0)}',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.accent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SizedBox(
            height: 40,
            child: FilledButton(
              onPressed: widget.onBook,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusButton,
                  ),
                ),
              ),
              child: Text(
                'Book Now',
                style: AppTextStyles.buttonMedium.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 40,
          child: OutlinedButton(
            onPressed: widget.onRemove,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: Text('Remove', style: AppTextStyles.buttonMedium),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 40,
          child: OutlinedButton(
            onPressed: widget.onShare,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            child: const Icon(Icons.share_outlined, size: 18),
          ),
        ),
      ],
    );
  }
}
