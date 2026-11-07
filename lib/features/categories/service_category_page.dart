import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';
import 'package:user_servicehub/core/utils/currency_formatter.dart';
import 'package:user_servicehub/data/logic/provider/home_provider.dart';
import 'package:user_servicehub/data/models/home_response_model.dart';

class ServiceCategoryPage extends StatefulWidget {
  final Category? category;
  final String? categoryId;

  const ServiceCategoryPage({
    super.key,
    this.category,
    this.categoryId,
  });

  @override
  State<ServiceCategoryPage> createState() => _ServiceCategoryPageState();
}

class _ServiceCategoryPageState extends State<ServiceCategoryPage> {
  Category? _resolveCategory(HomeData? homeData) {
    if (widget.category != null) return widget.category;
    final id = widget.categoryId;
    if (id == null || id.isEmpty) return null;
    for (final c in (homeData?.categories ?? const <Category>[])) {
      if (c.id == id) return c;
    }
    return null;
  }

  List<PopularPackage> _packagesForService(
    HomeData? homeData,
    String serviceId,
  ) {
    return (homeData?.popularPackages ?? const <PopularPackage>[])
        .where((p) => p.serviceId == serviceId)
        .toList();
  }

  double _minOfferPrice(List<PopularPackage> packages) {
    if (packages.isEmpty) return 0;
    double min = double.infinity;
    for (final p in packages) {
      final v = double.tryParse(p.offerPrice) ?? 0;
      if (v < min) min = v;
    }
    return min == double.infinity ? 0 : min;
  }

  @override
  Widget build(BuildContext context) {
    final homeData = context.watch<HomeProvider>().homeData;
    final category = _resolveCategory(homeData);

    if (category == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        body: Center(
          child: Text('Category not found', style: AppTextStyles.bodyLarge),
        ),
      );
    }

    final services = category.services;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(category),
          SliverToBoxAdapter(child: _buildHeroBanner(category)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Text(
                'Services',
                style: AppTextStyles.titleMedium,
              ),
            ),
          ),
          if (services.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(
                  child: Text(
                    'No services available in this category',
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final service = services[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildServiceCard(category, service),
                  );
                }, childCount: services.length),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAppBar(Category category) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.surface,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 20),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Text(category.name, style: AppTextStyles.titleMedium),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, size: 22),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.favorite_outline, size: 22),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildHeroBanner(Category category) {
    final packages = (context.read<HomeProvider>().homeData?.popularPackages ??
            const <PopularPackage>[])
        .where((p) =>
            category.services.any((s) => s.id == p.serviceId))
        .toList();
    final minPrice = _minOfferPrice(packages);
    final serviceCount = category.services.length;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusBanner),
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF7C3AED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              _resolveIcon(category.name),
              size: 140,
              color: AppColors.white.withValues(alpha: 0.1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  '${category.name} Services',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$serviceCount service${serviceCount == 1 ? '' : 's'}'
                  '${packages.isNotEmpty ? ' • ${packages.length} package${packages.length == 1 ? '' : 's'}' : ''}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white70,
                  ),
                ),
                if (packages.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Starting from ${CurrencyFormatter.formatIndianRupees(minPrice)}',
                    style: AppTextStyles.titleMedium.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(
    Category category,
    Service service,
  ) {
    final homeData = context.read<HomeProvider>().homeData;
    final packageCount = _packagesForService(homeData, service.id).length;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        onTap: () {
          context.push(
            '/package-selection/${service.id}?name=${Uri.encodeComponent(service.name)}',
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            border: Border.all(
              color: AppColors.border,
              width: 0.5,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusMedium,
                  ),
                ),
                child: Icon(
                  _resolveIcon(service.name),
                  color: AppColors.primary,
                  size: 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service.name,
                      style: AppTextStyles.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (service.description != null &&
                        service.description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        service.description!,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusFull,
                        ),
                      ),
                      child: Text(
                        '$packageCount package${packageCount == 1 ? '' : 's'}',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textTertiary,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _resolveIcon(String name) {
    final n = name.toLowerCase();
    if (n.contains('electric')) return Icons.flash_on;
    if (n.contains('plumb')) return Icons.water_drop;
    if (n.contains('cleaning') || n.contains('clean')) {
      return Icons.cleaning_services;
    }
    if (n.contains('ac ') || n == 'ac') return Icons.ac_unit;
    if (n.contains('paint')) return Icons.format_paint;
    if (n.contains('carpenter') || n.contains('handyman')) return Icons.handyman;
    if (n.contains('appliance') || n.contains('kitchen')) return Icons.kitchen;
    if (n.contains('pest')) return Icons.bug_report;
    if (n.contains('beauty') || n.contains('makeup') || n.contains('parlour')) {
      return Icons.face;
    }
    if (n.contains('salon') || n.contains('hair')) return Icons.content_cut;
    if (n.contains('car wash') || n.contains('car_wash')) {
      return Icons.local_car_wash;
    }
    if (n.contains('repair') || n.contains('service')) return Icons.build;
    return Icons.build;
  }
}
