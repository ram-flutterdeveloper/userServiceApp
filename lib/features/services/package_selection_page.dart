import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:user_servicehub/core/constants/api.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';
import 'package:user_servicehub/core/utils/currency_formatter.dart';
import 'package:user_servicehub/core/widgets/auth_guard.dart';
import 'package:user_servicehub/data/logic/provider/package_provider.dart';
import 'package:user_servicehub/data/models/home_response_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:user_servicehub/features/booking/booking_page.dart';
import 'package:user_servicehub/features/services/service_details_page.dart';

class PackageSelectionPage extends StatefulWidget {
  final String serviceId;
  final String serviceName;

  const PackageSelectionPage({
    super.key,
    required this.serviceId,
    this.serviceName = '',
  });

  @override
  State<PackageSelectionPage> createState() => _PackageSelectionPageState();
}

class _PackageSelectionPageState extends State<PackageSelectionPage> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PackageProvider>().fetchPackages(widget.serviceId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PackageProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text('Select Package', style: AppTextStyles.titleMedium),
      ),
      body: _buildBody(provider),
    );
  }

  Widget _buildBody(PackageProvider provider) {
    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spacing24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: AppColors.error),
              const SizedBox(height: AppDimensions.spacing16),
              Text(
                provider.error!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing16),
              ElevatedButton(
                onPressed: () => provider.fetchPackages(widget.serviceId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusButton,
                    ),
                  ),
                ),
                child: Text('Retry', style: AppTextStyles.buttonMedium),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.packages.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 48,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: AppDimensions.spacing16),
            Text(
              'No packages available',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (_selectedIndex >= provider.packages.length) {
      _selectedIndex = 0;
    }

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.spacing16,
            AppDimensions.spacing16,
            AppDimensions.spacing16,
            120,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildServiceHeader(provider.packages.length),
              const SizedBox(height: AppDimensions.spacing24),
              ...List.generate(provider.packages.length, (i) {
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppDimensions.spacing16,
                  ),
                  child: _buildPackageCard(provider.packages[i], i),
                );
              }),
            ],
          ),
        ),
        _buildStickyBottom(provider.packages),
      ],
    );
  }

  Widget _buildServiceHeader(int count) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEEF2FF), Color(0xFFE0E7FF)],
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
            child: const Icon(
              Icons.workspace_premium,
              color: AppColors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.serviceName.isNotEmpty
                      ? widget.serviceName
                      : 'Service',
                  style: AppTextStyles.titleSmall,
                ),
                const SizedBox(height: 2),
                Text(
                  '$count package${count == 1 ? '' : 's'} available',
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

  Widget _buildPackageCard(PopularPackage pkg, int index) {
    final isSelected = _selectedIndex == index;
    final offer = double.tryParse(pkg.offerPrice) ?? 0;
    final original = double.tryParse(pkg.defaultPrice) ?? 0;
    final save = original > offer ? original - offer : 0.0;

    return InkWell(
      onTap: () {
        setState(() => _selectedIndex = index);
      },
      borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      child: AnimatedScale(
        scale: isSelected ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 250),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border,
              width: isSelected ? 1.5 : 1,
            ),
            boxShadow:
                isSelected
                    ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                    : [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (pkg.image != null && pkg.image!.isNotEmpty)
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppDimensions.radiusCard),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: '${APIURL.IMAGE_URL}${pkg.image!}',
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    placeholder:
                        (context, url) => Container(
                          height: 140,
                          color: AppColors.background,
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => Container(
                          height: 140,
                          color: AppColors.background,
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            size: 40,
                            color: AppColors.textTertiary,
                          ),
                        ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(AppDimensions.spacing16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Radio<int>(
                          value: index,
                          groupValue: _selectedIndex,
                          onChanged: (v) => setState(() => _selectedIndex = v!),
                          activeColor: AppColors.primary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      pkg.name,
                                      style: AppTextStyles.titleLarge,
                                    ),
                                  ),
                                  if (pkg.isFeatured)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFF59E0B),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(
                                            AppDimensions.radiusSmall,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Featured',
                                        style: AppTextStyles.labelSmall
                                            .copyWith(
                                              color: AppColors.white,
                                              fontSize: 10,
                                            ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    CurrencyFormatter.formatIndianRupees(offer),
                                    style: AppTextStyles.titleLarge.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  if (original > offer) ...[
                                    Text(
                                      CurrencyFormatter.formatIndianRupees(
                                        original,
                                      ),
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        decoration: TextDecoration.lineThrough,
                                        color: AppColors.textTertiary,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.secondaryLight,
                                        borderRadius: BorderRadius.circular(
                                          AppDimensions.radiusSmall,
                                        ),
                                      ),
                                      child: Text(
                                        'Save ${CurrencyFormatter.formatIndianRupees(save)}',
                                        style: AppTextStyles.labelSmall
                                            .copyWith(
                                              color: AppColors.secondary,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 10,
                                            ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 40),
                      child: Row(
                        children: [
                          if (pkg.durationMinutes > 0)
                            _buildInfoChip(
                              Icons.timer_outlined,
                              '${pkg.durationMinutes} mins',
                            ),
                          Spacer(),

                          InkWell(
                            onTap: () {
                             
                              Get.to(
                                () => PackageDetailsPage(serviceId: pkg.id),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(AppDimensions.radiusSmall),
                                ),
                              ),
                              child: Text(
                                'View Details',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (pkg.description != null &&
                        pkg.description!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      const Divider(height: 1),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.only(left: 40),
                        child: Text(
                          pkg.description!,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(label, style: AppTextStyles.caption.copyWith(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildStickyBottom(List<PopularPackage> packages) {
    if (packages.isEmpty) return const SizedBox.shrink();
    final pkg = packages[_selectedIndex];
    final offer = double.tryParse(pkg.offerPrice) ?? 0;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppDimensions.spacing16,
          AppDimensions.spacing12,
          AppDimensions.spacing16,
          AppDimensions.spacing24,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    pkg.name,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    CurrencyFormatter.formatIndianRupees(offer),
                    style: AppTextStyles.titleLarge.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 180,
              height: AppDimensions.buttonHeight,
              child: ElevatedButton(
                onPressed: () async {
                  final isAuthenticated = await AuthGuard.requireLogin(context);

                  if (!isAuthenticated) return;
                  if (!context.mounted) return;

                  Get.to(
                    () => BookingPage(
                      packageId: pkg.id,
                      packageName: pkg.name,
                      packagePrice: pkg.offerPrice,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusButton,
                    ),
                  ),
                  elevation: 0,
                ),
                child: Text('Continue', style: AppTextStyles.buttonLarge),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
