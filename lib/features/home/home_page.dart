import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/constants/app_images.dart';
import 'package:user_servicehub/core/constants/app_routes.dart';
import 'package:user_servicehub/core/constants/app_strings.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';
import 'package:user_servicehub/core/widgets/app_icon_button.dart';
import 'package:user_servicehub/core/widgets/app_search_field.dart';
import 'package:user_servicehub/core/widgets/app_section_header.dart';
import 'package:user_servicehub/data/logic/provider/favourite_provider.dart';
import 'package:user_servicehub/data/logic/provider/home_provider.dart';
import 'package:user_servicehub/data/mock/mock_categories.dart';
import 'package:user_servicehub/data/mock/mock_offers.dart';
import 'package:user_servicehub/data/mock/mock_professionals.dart';
import 'package:user_servicehub/data/mock/mock_reviews.dart';
import 'package:user_servicehub/data/mock/mock_services.dart';
import 'package:user_servicehub/data/mock/mock_users.dart';
import 'package:user_servicehub/data/models/home_response_model.dart';
import 'package:user_servicehub/data/models/service_model.dart';
import 'package:user_servicehub/features/booking/booking_page.dart';
import 'package:user_servicehub/features/categories/service_category_page.dart';
import 'package:user_servicehub/features/home/widgets/banner_slider.dart';
import 'package:user_servicehub/features/home/widgets/category_chip.dart';
import 'package:user_servicehub/features/home/widgets/home_shimmer.dart';
import 'package:user_servicehub/features/home/widgets/location_picker_sheet.dart';
import 'package:user_servicehub/features/home/widgets/offer_card.dart';
import 'package:user_servicehub/features/home/widgets/professional_card.dart';
import 'package:user_servicehub/features/home/widgets/review_card.dart';
import 'package:user_servicehub/features/home/widgets/service_card.dart';
import 'package:user_servicehub/features/professionals/professional_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isGuest = false;
  bool _showGuestBanner = true;
  final Set<String> _favoriteIds = {};
  bool _showRecommendation = false;

  late final FavouriteProvider _favouritesProvider;
  @override
  void initState() {
    super.initState();
    _loadPrefs();
    _favouritesProvider = context.read<FavouriteProvider>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().fetchHome();
      context.read<FavouriteProvider>().fetchPackages();
    });
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _isGuest = prefs.getBool('isGuest') ?? false;
      });
    }
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();
    if (provider.isLoading && provider.homeData == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const HomeShimmer(),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: AppDimensions.spacing32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isGuest && _showGuestBanner) _buildGuestBanner(),
              _buildHeader(provider),
              const SizedBox(height: AppDimensions.spacing12),
              _buildSearchField(),
              const SizedBox(height: AppDimensions.spacing20),
              _buildCategories(context.watch<HomeProvider>().homeData),
              const SizedBox(height: AppDimensions.spacing24),
              _buildBanners(),
              const SizedBox(height: AppDimensions.spacing24),
              _buildQuickActions(),
              const SizedBox(height: AppDimensions.spacing24),
              // _buildAIAssistant(),
              // if (_showRecommendation) ...[
              //   const SizedBox(height: AppDimensions.spacing16),
              //   _buildRecommendation(),
              // ],
              const SizedBox(height: AppDimensions.spacing24),
              _buildRecommendedServices(context.watch<HomeProvider>().homeData),
              const SizedBox(height: AppDimensions.spacing24),
              _buildPopularProfessionals(),
              // const SizedBox(height: AppDimensions.spacing24),
              // _buildSpecialOffers(),
              const SizedBox(height: AppDimensions.spacing24),
              _buildRecentReviews(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuestBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: AppColors.white, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "You're browsing as guest",
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Login for full access',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => context.go(AppRoutes.login),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => setState(() => _showGuestBanner = false),
            child: const Icon(Icons.close, color: Colors.white70, size: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(HomeProvider provider) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing16,
        vertical: AppDimensions.spacing8,
      ),
      child: Row(
        children: [
          // Container(
          //   width: 48,
          //   height: 48,
          //   decoration: BoxDecoration(
          //     gradient: const LinearGradient(
          //       colors: [AppColors.primary, AppColors.primaryDark],
          //     ),
          //     borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
          //   ),
          //   child: Center(
          //     child: Text(
          //       mockUser.photoUrl != null && mockUser.photoUrl!.isNotEmpty
          //           ? ''
          //           : mockUser.name.isNotEmpty
          //           ? '${mockUser.name.split(' ').first[0]}${mockUser.name.split(' ').last[0]}'
          //           : 'U',
          //       style: const TextStyle(
          //         color: AppColors.white,
          //         fontWeight: FontWeight.w600,
          //         fontSize: 16,
          //       ),
          //     ),
          //   ),
          // ),
          // const SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_greeting()} 👋',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                  ),
                ),
              
              ],
            ),
          ),
          AppIconButton(
            icon: Icons.notifications_outlined,
            onPressed: () => context.go(AppRoutes.notifications),
            hasBadge: true,
            badgeCount: 3,
          ),
          const SizedBox(width: AppDimensions.spacing8),
          GestureDetector(
            onTap: () => LocationPickerSheet.show(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  SizedBox(
                    width: 100,
                    child: Flexible(
                      child: Text(
                        provider.locationLabel ?? 'Set location',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 2),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 14,
                    color: AppColors.primary,
                  ),
                  if (provider.isLocating || provider.isLoading) ...[
                    const SizedBox(width: 4),
                    const SizedBox(
                      width: 10,
                      height: 10,
                      child: CircularProgressIndicator(
                        strokeWidth: 1.5,
                        color: AppColors.primary,
                      ),
                    ),
                  
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      child: AppSearchField(
        hint: 'Search for services...',
        onChanged: (_) {},
        onSubmitted: (v) {},
      ),
    );
  }

  Widget _buildBanners() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: BannerSlider(
        banners: const [
          PromoBanner(
            title: 'Home Services up to 40% OFF',
            subtitle: 'Electrician, Plumbing & more',
            gradientStart: Color(0xFF2563EB),
            gradientEnd: Color(0xFF7C3AED),
            image: AppImages.acrepair,
          ),
          PromoBanner(
            title: 'Professional Cleaning at \u20B9199',
            subtitle: 'Deep cleaning starting at just \u20B9199',
            gradientStart: Color(0xFF10B981),
            gradientEnd: Color(0xFF0D9488),
            image: AppImages.plumbing,
          ),
          PromoBanner(
            title: 'Flat 25% Off on AC Repair',
            subtitle: 'Beat the heat with cool savings',
            gradientStart: Color(0xFFF97316),
            gradientEnd: Color(0xFFEC4899),
            image: AppImages.homeService,
          ),
          PromoBanner(
            title: 'Flat 25% Off on AC Repair',
            subtitle: 'Beat the heat with cool savings',
            gradientStart: Color(0xFFF97316),
            gradientEnd: Color(0xFFEC4899),
            image: AppImages.cleaning,
          ),
          PromoBanner(
            title: 'Flat 25% Off on AC Repair',
            subtitle: 'Beat the heat with cool savings',
            gradientStart: Color(0xFFF97316),
            gradientEnd: Color(0xFFEC4899),
            image: AppImages.electrician,
          ),
          PromoBanner(
            title: 'Flat 25% Off on AC Repair',
            subtitle: 'Beat the heat with cool savings',
            gradientStart: Color(0xFFF97316),
            gradientEnd: Color(0xFFEC4899),
            image: AppImages.carpentry,
          ),
          PromoBanner(
            title: 'Flat 25% Off on AC Repair',
            subtitle: 'Beat the heat with cool savings',
            gradientStart: Color(0xFFF97316),
            gradientEnd: Color(0xFFEC4899),
            image: AppImages.painting,
          ),
          PromoBanner(
            title: 'Flat 25% Off on AC Repair',
            subtitle: 'Beat the heat with cool savings',
            gradientStart: Color(0xFFF97316),
            gradientEnd: Color(0xFFEC4899),
            image: AppImages.acrepair,
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(HomeData? homeData) {
    final categories = homeData?.categories ?? [];
    return categories.length > 0
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDimensions.spacing12),
            SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing16,
                ),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder:
                    (_, i) => CategoryChip(
                      category: categories[i],
                      onTap:
                          () => Get.to(()=> ServiceCategoryPage(category: categories[i])
                           ,
                          ),
                    ),
              ),
            ),
          ],
        )
        : SizedBox.shrink();
  }

  Widget _buildQuickActions() {
    final actions = [
      _QuickActionData(
        Icons.emergency,
        'Emergency',
        AppStrings.emergencyService,
        AppColors.error,
      ),
      _QuickActionData(
        Icons.replay,
        'Book Again',
        AppStrings.bookAgain,
        AppColors.primary,
      ),
      _QuickActionData(
        Icons.near_me,
        'Track',
        AppStrings.trackBooking,
        AppColors.secondary,
      ),
      _QuickActionData(
        Icons.explore,
        'Nearby',
        AppStrings.nearbyExperts,
        AppColors.accent,
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      child: Row(
        children:
            actions.map((a) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _QuickActionCard(
                    icon: a.icon,
                    label: a.title,
                    subtitle: a.subtitle,
                    color: a.color,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${a.title} tapped')),
                      );
                    },
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }

  Widget _buildAIAssistant() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7C3AED), Color(0xFF2563EB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF7C3AED).withValues(alpha: 0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(AppDimensions.spacing20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusFull,
                    ),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppDimensions.spacing16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Describe your problem',
                        style: TextStyle(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'AI-powered service assistant',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing16),
            Row(
              children: [
                _AIChip(
                  icon: Icons.mic,
                  label: AppStrings.voiceInput,
                  onTap: () {},
                ),
                const SizedBox(width: 8),
                Spacer(),
                _AIChip(
                  icon: Icons.image_outlined,
                  label: AppStrings.uploadImage,
                  onTap: () {},
                ),
                // const SizedBox(width: 8),
                // _AIChip(
                //   icon: Icons.keyboard,
                //   label: AppStrings.typeProblem,
                //   onTap: () {},
                // ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed:
                    () => setState(
                      () => _showRecommendation = !_showRecommendation,
                    ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.white,
                  side: BorderSide(
                    color: AppColors.white.withValues(alpha: 0.3),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusFull,
                    ),
                  ),
                ),
                child: Text(
                  _showRecommendation
                      ? 'Hide Recommendation'
                      : AppStrings.recommendService,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendation() {
    final service = mockServices.first;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFEF3C7), Color(0xFFFFF7ED)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(color: AppColors.accent.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.accent,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Recommended for You',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing12),
            Text(service.title, style: AppTextStyles.titleMedium),
            const SizedBox(height: 4),
            Text(
              'Package: ${service.duration}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Estimated Cost: \u20B9${(service.price * (1 - service.discountPercentage / 100)).toStringAsFixed(0)}',
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Duration: ${service.duration}',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    () => context.push(
                      '/booking',
                      extra: {'service': service.id},
                    ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusFull,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: const Text(
                  'Book Now',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendedServices(HomeData? homeData) {
    // final services = _recommendedServiceModels(homeData);

    final providerPackages = _favouritesProvider.packages;

    return providerPackages.length > 0
        ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.spacing20,
              ),
              child: AppSectionHeader(title: AppStrings.recommendService),
            ),
            const SizedBox(height: AppDimensions.spacing12),
            SizedBox(
              height: 260,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spacing16,
                ),
                itemCount: providerPackages.length,
                separatorBuilder:
                    (_, __) => const SizedBox(width: AppDimensions.spacing12),
                itemBuilder: (_, i) {
                  final service = providerPackages[i];
                  return ServiceCard(
                    service: service,
                    isFavorite: _favoriteIds.contains(service.id),
                    onBookNow:
                        () => Get.to(
                          () => BookingPage(
                            packageId: service.id,
                            packageName: service.title,
                            packagePrice: service.price.toString(),
                          ),
                        ),
                    // context.push(
                    //   '/booking',
                    //   extra: {
                    //     'service': service.id,
                    //     'title': service.title,
                    //     'price': service.price,
                    //   },
                    // ),
                    onFavoriteToggle: () {
                      setState(() {
                        if (_favoriteIds.contains(service.id)) {
                          _favoriteIds.remove(service.id);
                        } else {
                          _favoriteIds.add(service.id);
                        }
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _favoriteIds.contains(service.id)
                                ? 'Added to favorites'
                                : 'Removed from favorites',
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        )
        : SizedBox.shrink();
  }

  /// Maps the discovery home API services (with matching package pricing)
  /// into the [ServiceModel] shape used by the existing service cards.
  List<ServiceModel> _recommendedServiceModels(HomeData? homeData) {
    if (homeData == null) return const [];

    final Map<String, String> categoryNames = {
      for (final c in homeData.categories)
        if (c.id != null) c.id!: c.name ?? '',
    };

    return homeData.recommendedServices.map((s) {
      PopularPackage? pkg;
      for (final p in homeData.popularPackages) {
        if (p.serviceId == s.id) {
          pkg = p;
          break;
        }
      }

      double discount = 0;

      final minutes = pkg?.durationMinutes;

      return ServiceModel(
        id: s.id ?? '',
        title: s.name ?? 'Service',
        description: s.description ?? '',
        categoryId: s.categoryId ?? '',
        categoryName: categoryNames[s.categoryId] ?? '',
        imageUrl: s.image ?? '',
        providerName: '',
        providerId: '',
        rating: 0,
        reviewCount: 0,
        completedJobs: 0,
        responseTime: '',
        experience: '',
        price: 200,
        discountPercentage: discount,
        duration: minutes != null ? '$minutes mins' : '',
        isVerified: s.isFeatured ?? false,
        distance: homeData.location?.cityDistance?.toDouble() ?? 0,
      );
    }).toList();
  }

  Widget _buildPopularProfessionals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing20),
          child: AppSectionHeader(title: AppStrings.popularProfessionals),
        ),
        const SizedBox(height: AppDimensions.spacing12),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing16,
            ),
            itemCount: mockProfessionals.length,
            separatorBuilder:
                (_, __) => const SizedBox(width: AppDimensions.spacing12),
            itemBuilder:
                (_, i) => ProfessionalCard(
                  professional: mockProfessionals[i],
                  onViewProfile:
                      () => Get.to(
                        () => ProfessionalDetailsPage(
                          professionalId: mockProfessionals[i].id,
                        ),
                      ),
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildSpecialOffers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing20),
          child: AppSectionHeader(title: AppStrings.specialOffers),
        ),
        const SizedBox(height: AppDimensions.spacing12),
        SizedBox(
          height: 170,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacing16,
            ),
            itemCount: mockOffers.length,
            separatorBuilder:
                (_, __) => const SizedBox(width: AppDimensions.spacing12),
            itemBuilder: (_, i) => OfferCard(offer: mockOffers[i]),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentReviews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacing20),
          child: AppSectionHeader(title: AppStrings.recentReviews),
        ),
        const SizedBox(height: AppDimensions.spacing12),
        ...mockReviews
            .take(4)
            .map(
              (review) => Padding(
                padding: const EdgeInsets.only(
                  left: AppDimensions.spacing16,
                  right: AppDimensions.spacing16,
                  bottom: AppDimensions.spacing12,
                ),
                child: ReviewCard(review: review),
              ),
            ),
      ],
    );
  }
}

class _QuickActionData {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _QuickActionData(this.icon, this.title, this.subtitle, this.color);
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppDimensions.spacing12,
            horizontal: 8,
          ),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusMedium,
                  ),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AIChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AIChip({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppColors.white, size: 14),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
