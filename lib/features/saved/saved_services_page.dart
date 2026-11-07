import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/constants/app_routes.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';
import 'package:user_servicehub/core/utils/image_utils.dart';
import 'package:user_servicehub/core/widgets/app_empty_state.dart';
import 'package:user_servicehub/core/widgets/app_error_state.dart';
import 'package:user_servicehub/core/widgets/app_loading_indicator.dart';
import 'package:user_servicehub/core/widgets/app_search_field.dart';
import 'package:user_servicehub/data/logic/provider/favourite_provider.dart';
import 'package:user_servicehub/data/models/service_model.dart';
import 'package:user_servicehub/data/mock/mock_services.dart';
import 'package:user_servicehub/features/saved/widgets/saved_service_card.dart';
import 'package:user_servicehub/features/services/service_details_page.dart';

class SavedServicesPage extends StatefulWidget {
  const SavedServicesPage({super.key});

  @override
  State<SavedServicesPage> createState() => _SavedServicesPageState();
}

class _SavedServicesPageState extends State<SavedServicesPage> {
  final Set<String> _selectedIds = {};
  bool _selectionMode = false;
  int _selectedFilter = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  late final FavouriteProvider _favouritesProvider;

  final List<String> _filters = [
    'All',
    'Cleaning',
    'Electrical',
    'Plumbing',
    'Salon',
    'Repair',
    'Painting',
    'AC Service',
  ];

  @override
  void initState() {
    super.initState();
    _favouritesProvider = context.read<FavouriteProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _favouritesProvider.fetchFavourites();
      _favouritesProvider.fetchPackages();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<ServiceModel> get _savedServices => _favouritesProvider.savedServices;

  List<ServiceModel> get _filteredServices {
    var list = List<ServiceModel>.from(_savedServices);
    if (_selectedFilter != 0) {
      final category = _filters[_selectedFilter];
      list = list.where((s) => s.categoryName == category).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      list =
          list
              .where(
                (s) =>
                    s.title.toLowerCase().contains(q) ||
                    s.providerName.toLowerCase().contains(q) ||
                    s.categoryName.toLowerCase().contains(q),
              )
              .toList();
    }
    return list;
  }

  Future<void> _removeItem(ServiceModel service) async {
    final removed = await _favouritesProvider.removeFavourite(service);
    if (!mounted) return;
    setState(() {
      _selectedIds.remove(service.id);
      if (_savedServices.isEmpty) _selectionMode = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          removed
              ? '${service.title} removed from favourites'
              : 'Failed to remove. Please try again.',
        ),
        backgroundColor: AppColors.textPrimary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _bulkRemove() async {
    final services =
        _savedServices.where((s) => _selectedIds.contains(s.id)).toList();
    var removed = 0;
    for (final service in services) {
      final ok = await _favouritesProvider.removeFavourite(service);
      if (ok) removed++;
    }
    if (!mounted) return;
    setState(() {
      _selectedIds.clear();
      _selectionMode = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          removed == services.length
              ? 'Services removed'
              : 'Some services could not be removed',
        ),
        backgroundColor: AppColors.textPrimary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _exitSelectionMode() {
    setState(() {
      _selectionMode = false;
      _selectedIds.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final favourites = context.watch<FavouriteProvider>();
    final filtered = _filteredServices;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        title:
            _selectionMode
                ? Text('${_selectedIds.length} Selected')
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Saved Services', style: AppTextStyles.titleLarge),
                    Text(
                      '${_savedServices.length} services saved',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
        leading:
            _selectionMode
                ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _exitSelectionMode,
                )
                : null,
        actions: [
          if (_selectionMode)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: AppColors.error),
              onPressed: _selectedIds.isEmpty ? null : _bulkRemove,
              tooltip: 'Remove selected',
            )
          else
            IconButton(
              icon: const Icon(Icons.notifications_outlined),
              onPressed: () => context.push(AppRoutes.notifications),
              color: AppColors.textPrimary,
            ),
        ],
      ),
      body:
          favourites.isLoading && _savedServices.isEmpty
              ? const AppFullScreenLoader()
              : favourites.error != null && _savedServices.isEmpty
              ? AppErrorState(
                message: favourites.error!,
                onRetry: () => _favouritesProvider.fetchFavourites(),
              )
              : _savedServices.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                onRefresh: _favouritesProvider.fetchFavourites,
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(child: _buildSearchBar()),
                    SliverToBoxAdapter(child: _buildFilterChips()),

                    // SliverToBoxAdapter(child: _buildSpecialOfferCard()),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spacing20,
                          vertical: AppDimensions.spacing8,
                        ),
                        child: Text(
                          '${filtered.length} service${filtered.length == 1 ? '' : 's'} found',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final service = filtered[index];
                        return SavedServiceCard(
                          service: service,
                          selectionMode: _selectionMode,
                          isSelected: _selectedIds.contains(service.id),
                          onSelect: (v) {
                            setState(() {
                              if (v == true) {
                                _selectedIds.add(service.id);
                              } else {
                                _selectedIds.remove(service.id);
                              }
                            });
                          },
                          onBook: () {
                            context.push(
                              AppRoutes.serviceDetails.replaceFirst(
                                ':id',
                                service.id,
                              ),
                            );
                          },
                          onRemove: () => _removeItem(service),
                          onShare: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Sharing ${service.title}...'),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                        );
                      }, childCount: filtered.length),
                    ),

                    SliverToBoxAdapter(child: _buildRecentlyViewed()),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppDimensions.spacing16,
                      ),
                      sliver: SliverToBoxAdapter(
                        child: _buildAIRecommendation(),
                      ),
                    ),
                    // SliverPadding(
                    //   padding: const EdgeInsets.only(
                    //     bottom: AppDimensions.spacing32,
                    //   ),
                    //   sliver: SliverToBoxAdapter(child: _buildBookAgain()),
                    // ),
                  ],
                ),
              ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.spacing20,
        AppDimensions.spacing16,
        AppDimensions.spacing20,
        AppDimensions.spacing8,
      ),
      child: AppSearchField(
        controller: _searchController,
        hint: 'Search saved services...',
        onChanged: (v) => setState(() => _searchQuery = v),
        suffixIcon:
            _searchQuery.isNotEmpty
                ? IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
                : null,
      ),
    );
  }

  Widget _buildFilterChips() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing20,
        ),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedFilter == index;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                _filters[index],
                style: AppTextStyles.labelMedium.copyWith(
                  color: isSelected ? AppColors.white : AppColors.textSecondary,
                ),
              ),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedFilter = index),
              selectedColor: AppColors.primary,
              checkmarkColor: AppColors.white,
              backgroundColor: AppColors.surface,
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSpecialOfferCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppDimensions.spacing20,
        AppDimensions.spacing16,
        AppDimensions.spacing20,
        0,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.spacing20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF2563EB), Color(0xFF8B5CF6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusBanner),
          boxShadow: const [
            BoxShadow(
              color: Color(0x4D8B5CF6),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusFull,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_offer,
                        color: AppColors.white,
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '25% OFF',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusFull,
                    ),
                  ),
                  child: Text(
                    'Exclusive',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing16),
            const Text(
              'Exclusive Offer',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Limited Time',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.white.withValues(alpha: 0.9),
              ),
            ),
            const SizedBox(height: AppDimensions.spacing20),
            SizedBox(
              height: 44,
              child: OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.white,
                  side: const BorderSide(color: AppColors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusButton,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                child: Text('Apply Coupon', style: AppTextStyles.buttonMedium),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentlyViewed() {
    final providerPackages = _favouritesProvider.packages;
    final items =
        providerPackages.isNotEmpty
            ? (providerPackages.length > 4
                ? providerPackages.sublist(0, 4)
                : providerPackages)
            : mockServices.sublist(0, 4);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.spacing20,
            AppDimensions.spacing24,
            AppDimensions.spacing20,
            AppDimensions.spacing12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Recently Viewed', style: AppTextStyles.titleMedium),
              TextButton(
                onPressed: () => context.push(AppRoutes.recentlyViewed),
                child: Text(
                  'See All',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 160,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing20,
              ),
              itemCount: items.length,
              itemBuilder: (_, i) {
                final s = items[i];
                return GestureDetector(
                  onTap:
                      () => {Get.to(() => PackageDetailsPage(serviceId: s.id))},

                  child: Container(
                    width: 140,
                    margin: const EdgeInsets.only(right: 12),

                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusCard,
                      ),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: AppColors.shadow,
                      //     blurRadius: 8,
                      //     offset: const Offset(0, 4),
                      //   ),
                      // ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 90,
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
                          child: _packageThumbnail(s),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                s.title,
                                style: AppTextStyles.labelMedium,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 0),
                              Text(
                                '\u20B9${s.price.toStringAsFixed(0)}',
                                style: AppTextStyles.titleSmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _packageThumbnail(ServiceModel s) {
    final url = s.imageUrl;
    final isNetworkUrl = url.startsWith('http') || url.startsWith('/');
    if (url.isEmpty || !isNetworkUrl) {
      return Center(
        child: Icon(
          Icons.image_outlined,
          color: AppColors.textTertiary.withValues(alpha: 0.5),
          size: 28,
        ),
      );
    }
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
        top: Radius.circular(AppDimensions.radiusCard),
      ),
      child: CachedNetworkImage(
        imageUrl: ImageUtils.resolveImageUrl(url) ?? url,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.contain,
        errorWidget:
            (_, __, ___) => Center(
              child: Icon(
                Icons.image_outlined,
                color: AppColors.textTertiary.withValues(alpha: 0.5),
                size: 28,
              ),
            ),
      ),
    );
  }

  Widget _buildAIRecommendation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing20),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.spacing20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusBanner),
          boxShadow: const [
            BoxShadow(
              color: Color(0x4D8B5CF6),
              blurRadius: 20,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusMedium,
                    ),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recommended for you',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Based on your preferences',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing16),
            Row(
              children: [
                Expanded(child: _chip('AC Service', Icons.ac_unit)),
                const SizedBox(width: 8),
                Expanded(child: _chip('Deep Clean', Icons.cleaning_services)),
                const SizedBox(width: 8),
                Expanded(child: _chip('Salon', Icons.content_cut)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _chip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.white.withValues(alpha: 0.15)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.white, size: 18),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookAgain() {
    final providerPackages = _favouritesProvider.packages;
    final items =
        providerPackages.isNotEmpty
            ? (providerPackages.length > 3
                ? providerPackages.sublist(0, 3)
                : providerPackages)
            : mockServices.sublist(0, 3);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.spacing20,
            AppDimensions.spacing24,
            AppDimensions.spacing20,
            AppDimensions.spacing12,
          ),
          child: Text('Book Again', style: AppTextStyles.titleMedium),
        ),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing20,
            ),
            itemCount: items.length,
            itemBuilder: (_, i) {
              final s = items[i];
              return Container(
                width: 160,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 80,
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
                      child: Center(
                        child: Icon(
                          Icons.image_outlined,
                          color: AppColors.textTertiary.withValues(alpha: 0.5),
                          size: 28,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            s.title,
                            style: AppTextStyles.labelMedium,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '\u20B9${s.price.toStringAsFixed(0)}',
                            style: AppTextStyles.titleSmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            height: 32,
                            child: FilledButton(
                              onPressed: () {},
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppDimensions.radiusSmall,
                                  ),
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              child: Text(
                                'Book Again',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return AppEmptyState(
      icon: Icons.bookmark_border,
      title: 'No Saved Services Yet',
      subtitle: 'Save your favorite services for quick booking later.',
      buttonLabel: 'Explore Services',
      onButtonTap: () => context.push(AppRoutes.categories),
    );
  }
}
