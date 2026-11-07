import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/constants/app_strings.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';
import 'package:user_servicehub/core/widgets/app_search_field.dart';
import 'package:user_servicehub/data/logic/provider/home_provider.dart';
import 'package:user_servicehub/data/models/home_response_model.dart';
import 'package:user_servicehub/features/categories/service_category_page.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedFilter;

  static const List<int> _palette = [
    0xFFFFA726,
    0xFF42A5F5,
    0xFF66BB6A,
    0xFFAB47BC,
    0xFFEF5350,
    0xFF8D6E63,
    0xFF26C6DA,
    0xFF7E57C2,
    0xFFEC407A,
    0xFF5C6BC0,
    0xFF29B6F6,
    0xFF78909C,
  ];

  final List<String> _filterOptions = [
    'All',
    'Cleaning',
    'Electrical',
    'Plumbing',
    'AC Repair',
    'Painting',
    'Carpenter',
    'Beauty',
    'Salon',
    'Car Wash',
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<HomeProvider>();
      if (provider.homeData == null && !provider.isLoading) {
        // provider.fetchHome();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeData = context.watch<HomeProvider>().homeData;
    final isLoading = context.watch<HomeProvider>().isLoading;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          AppStrings.allCategories,
          style: AppTextStyles.headlineSmall,
        ),
        centerTitle: false,
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0.5,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: AppSearchField(
              controller: _searchController,
              hint: AppStrings.searchCategories,
              onChanged: (v) => setState(() => _searchQuery = v),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filterOptions.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                final option = _filterOptions[i];
                final isSelected =
                    _selectedFilter == option ||
                    (option == 'All' && _selectedFilter == null);
                return FilterChip(
                  label: Text(
                    option,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                      color:
                          isSelected
                              ? AppColors.primary
                              : AppColors.textSecondary,
                    ),
                  ),
                  selected: isSelected,
                  onSelected: (_) {
                    setState(() {
                      _selectedFilter = option == 'All' ? null : option;
                    });
                  },
                  backgroundColor: AppColors.background,
                  selectedColor: AppColors.primaryLight,
                  side: BorderSide(
                    color: isSelected ? AppColors.primary : AppColors.border,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusFull,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Expanded(child: _buildBody(homeData, isLoading)),
        ],
      ),
    );
  }

  Widget _buildBody(HomeData? homeData, bool isLoading) {
    if (isLoading && homeData == null) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (homeData == null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off, size: 48, color: AppColors.textTertiary),
            const SizedBox(height: 12),
            Text(
              'Failed to load categories',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.read<HomeProvider>().fetchHome(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final filtered = _filteredCategories(homeData.categories);

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off, size: 48, color: AppColors.textTertiary),
            const SizedBox(height: 12),
            Text(
              'No categories found',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: AppDimensions.spacing12,
        mainAxisSpacing: AppDimensions.spacing12,
        childAspectRatio: 0.85,
      ),
      itemCount: filtered.length,
      itemBuilder: (_, i) => _buildCategoryCard(filtered[i], i),
    );
  }

  List<Category> _filteredCategories(List<Category> categories) {
    var cats =
        categories.where((c) {
          if (_searchQuery.isEmpty) return true;
          return c.name.toLowerCase().contains(_searchQuery.toLowerCase());
        }).toList();

    if (_selectedFilter != null && _selectedFilter != 'All') {
      cats =
          cats
              .where(
                (c) => c.name.toLowerCase().contains(
                  _selectedFilter!.toLowerCase(),
                ),
              )
              .toList();
    }

    return cats;
  }

  Widget _buildCategoryCard(Category cat, int index) {
    final color = Color(_palette[index % _palette.length]);
    final serviceCount = cat.services.length;

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        onTap: () => Get.to(()=>ServiceCategoryPage(category: cat)),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            boxShadow: const [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusMedium,
                  ),
                ),
                child: Icon(
                  _resolveIcon(cat.icon ?? cat.name),
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(height: AppDimensions.spacing8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Text(
                  cat.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelSmall.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    height: 1.3,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '$serviceCount service${serviceCount == 1 ? '' : 's'}',
                style: AppTextStyles.caption.copyWith(
                  fontSize: 9,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _resolveIcon(String nameOrIcon) {
    switch (nameOrIcon) {
      case 'flash_on':
        return Icons.flash_on;
      case 'water_drop':
        return Icons.water_drop;
      case 'ac_unit':
        return Icons.ac_unit;
      case 'cleaning_services':
        return Icons.cleaning_services;
      case 'format_paint':
        return Icons.format_paint;
      case 'handyman':
        return Icons.handyman;
      case 'kitchen':
        return Icons.kitchen;
      case 'bug_report':
        return Icons.bug_report;
      case 'face':
        return Icons.face;
      case 'content_cut':
        return Icons.content_cut;
      case 'local_car_wash':
        return Icons.local_car_wash;
      case 'more_horiz':
        return Icons.more_horiz;
    }

    final n = nameOrIcon.toLowerCase();
    if (n.contains('electric')) return Icons.flash_on;
    if (n.contains('plumb')) return Icons.water_drop;
    if (n.contains('clean')) return Icons.cleaning_services;
    if (n.contains('ac ') || n == 'ac' || n.contains('air condition')) {
      return Icons.ac_unit;
    }
    if (n.contains('paint')) return Icons.format_paint;
    if (n.contains('carpenter') || n.contains('handyman')) {
      return Icons.handyman;
    }
    if (n.contains('appliance') || n.contains('kitchen')) return Icons.kitchen;
    if (n.contains('pest')) return Icons.bug_report;
    if (n.contains('beauty') || n.contains('makeup')) return Icons.face;
    if (n.contains('salon') || n.contains('hair')) return Icons.content_cut;
    if (n.contains('car wash') || n.contains('car_wash')) {
      return Icons.local_car_wash;
    }
    if (n.contains('repair')) return Icons.build;
    return Icons.category_outlined;
  }
}
