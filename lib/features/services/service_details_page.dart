import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/utils/currency_formatter.dart';
import 'package:user_servicehub/core/utils/image_utils.dart';
import 'package:user_servicehub/core/widgets/app_error_state.dart';
import 'package:user_servicehub/core/widgets/app_rating.dart';
import 'package:user_servicehub/core/widgets/app_badge.dart';
import 'package:user_servicehub/core/widgets/app_card.dart';
import 'package:user_servicehub/core/widgets/auth_guard.dart';
import 'package:user_servicehub/data/logic/provider/package_details_provider.dart';
import 'package:user_servicehub/data/logic/provider/package_reviews_provider.dart';
import 'package:user_servicehub/data/logic/provider/favourite_provider.dart';
import 'package:user_servicehub/data/models/package_details_model.dart';
import 'package:user_servicehub/data/models/package_reviews_model.dart';
import 'package:user_servicehub/data/models/service_model.dart';
import 'package:user_servicehub/data/models/package_model.dart';
import 'package:user_servicehub/data/models/review_model.dart';
import 'package:user_servicehub/data/models/professional_model.dart';
import 'package:user_servicehub/data/mock/mock_services.dart';
import 'package:user_servicehub/data/mock/mock_professionals.dart';
import 'package:user_servicehub/features/booking/booking_page.dart';
import 'package:user_servicehub/features/services/widgets/expandable_section.dart';
import 'package:user_servicehub/features/services/widgets/add_on_chip.dart';

class PackageDetailsPage extends StatefulWidget {
  final String serviceId;

  const PackageDetailsPage({super.key, required this.serviceId});

  @override
  State<PackageDetailsPage> createState() => _PackageDetailsPageState();
}

class _PackageDetailsPageState extends State<PackageDetailsPage> {
  late ServiceModel _service;
  late ProfessionalModel _professional;
  late PackageModel? _selectedPackage;
  PackageDetails? _details;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  late final FavouriteProvider _favouritesProvider;

  final List<Map<String, dynamic>> _addOnItems = [
    {'label': 'Extra Worker', 'price': '₹299', 'quantity': 0},
    {'label': 'Deep Cleaning', 'price': '₹499', 'quantity': 0},
    {'label': 'Sofa Shampoo', 'price': '₹349', 'quantity': 0},
    {'label': 'Carpet Wash', 'price': '₹599', 'quantity': 0},
    {'label': 'Window Polish', 'price': '₹199', 'quantity': 0},
  ];
  final List<String> _galleryImages = [
    'https://images.unsplash.com/photo-1581578731548-c64695cc6952',
    'https://images.unsplash.com/photo-1527515637462-cff94eecc1ac',
    'https://images.unsplash.com/photo-1555041469-a586c61ea9bc',
  ];

  @override
  void initState() {
    super.initState();

    _favouritesProvider = context.read<FavouriteProvider>();

    print('View Details tapped for package: ${widget.serviceId} ');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PackageDetailsProvider>().fetchPackageDetails(
        widget.serviceId,
      );
      context.read<PackageReviewsProvider>().fetchReviews(
        packageId: widget.serviceId,
      );
      _favouritesProvider.fetchFavourites();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _toggleFavourite() async {
    final wasFavourite = _favouritesProvider.isFavourite(widget.serviceId);
    final success = await _favouritesProvider.toggleFavourite(widget.serviceId);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          !success
              ? 'Something went wrong. Please try again.'
              : wasFavourite
              ? 'Removed from favourites'
              : 'Added to favourites',
        ),
        backgroundColor: AppColors.textPrimary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<PackageDetailsProvider>();

    if (provider.isLoading && _details == null) {
      return const Scaffold(
        backgroundColor: AppColors.surface,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (provider.error != null && _details == null) {
      return Scaffold(
        backgroundColor: AppColors.surface,
        body: AppErrorState(
          message: 'Unable to load package details',
          onRetry:
              () => context.read<PackageDetailsProvider>().fetchPackageDetails(
                widget.serviceId,
              ),
        ),
      );
    }

    final details = provider.details ?? _details;
    if (details != null) _details = details;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildImageGallery(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.spacing16,
                    AppDimensions.spacing16,
                    AppDimensions.spacing16,
                    100,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoSection(),
                      const SizedBox(height: AppDimensions.spacing24),
                      _buildExpandableSections(),
                      const SizedBox(height: AppDimensions.spacing24),
                      // _buildAddOnsSection(),
                      // const SizedBox(height: AppDimensions.spacing24),
                      _buildReviewsSection(),
                      const SizedBox(height: AppDimensions.spacing24),
                      // _buildProviderSection(),
                    ],
                  ),
                ),
              ),
            ],
          ),

          _buildAppBarOverlay(),
          _buildStickyBottom(details),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // API data helpers (mock data is used only as a fallback)
  // ------------------------------------------------------------

  String get _displayTitle {
    final name = _details?.package.name ?? '';
    return name.isNotEmpty ? name : _service.title;
  }

  String get _displayDescription {
    final description = _details?.description ?? '';
    if (description.isNotEmpty) return description;
    final packageDescription = _details?.package.description ?? '';
    if (packageDescription.isNotEmpty) return packageDescription;
    return _service.description;
  }

  double get _offerPrice {
    final pkg = _details?.package;
    if (pkg != null) {
      final parsed = double.tryParse(pkg.offerPrice) ?? 0;
      if (parsed > 0) return parsed;
    }
    return _service.price * (1 - _service.discountPercentage / 100);
  }

  double get _originalPrice {
    final pkg = _details?.package;
    if (pkg != null) {
      final parsed = double.tryParse(pkg.defaultPrice) ?? 0;
      if (parsed > _offerPrice) return parsed;
    }
    return _service.price;
  }

  int get _discountPercent {
    if (_originalPrice > _offerPrice) {
      return ((_originalPrice - _offerPrice) / _originalPrice * 100).round();
    }
    return _service.discountPercentage.toInt();
  }

  String get _displayDuration {
    final minutes = _details?.package.durationMinutes ?? 0;
    if (minutes > 0) return '$minutes mins';
    return _service.duration;
  }

  List<String> get _displayGalleryImages {
    final urls = <String>[];
    for (final img in _details?.images ?? const <PackageImage>[]) {
      final resolved = ImageUtils.resolveImageUrl(img.image);
      if (resolved != null) urls.add(resolved);
    }
    if (urls.isEmpty) {
      final primary = ImageUtils.resolveImageUrl(_details?.package.image);
      if (primary != null) urls.add(primary);
    }
    return urls.isNotEmpty ? urls : _galleryImages;
  }

  Widget _buildImageGallery() {
    final galleryImages = _displayGalleryImages;
    return SliverToBoxAdapter(
      child: SizedBox(
        height: 260,
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: (i) => setState(() => _currentPage = i),
              children:
                  galleryImages.map((url) {
                    return Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        image: DecorationImage(
                          image: NetworkImage(url),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
                  }).toList(),
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(galleryImages.length, (i) {
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: i == _currentPage ? 20 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color:
                          i == _currentPage
                              ? AppColors.primary
                              : Colors.white54,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarOverlay() {
    final favouritesProvider = context.watch<FavouriteProvider>();
    return Positioned(
      top: MediaQuery.of(context).padding.top,
      left: 8,
      right: 8,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(9999),
            ),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                size: 20,
                color: AppColors.textPrimary,
              ),
              onPressed: () => context.pop(),
            ),
          ),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.share_outlined,
                    size: 20,
                    color: AppColors.textPrimary,
                  ),
                  onPressed: () {},
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.9),
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: IconButton(
                  icon: Icon(
                    favouritesProvider.isFavourite(widget.serviceId)
                        ? Icons.favorite
                        : Icons.favorite_outline,
                    size: 20,
                    color:
                        favouritesProvider.isFavourite(widget.serviceId)
                            ? AppColors.error
                            : AppColors.textPrimary,
                  ),
                  onPressed: _toggleFavourite,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    final discountedPrice = _offerPrice;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_displayTitle, style: AppTextStyles.headlineMedium),
        const SizedBox(height: AppDimensions.spacing8),
        // Row(
        //   children: [
        //     Text(
        //       _service.providerName,
        //       style: AppTextStyles.bodyLarge.copyWith(
        //         color: AppColors.textSecondary,
        //       ),
        //     ),
        //     const SizedBox(width: AppDimensions.spacing8),
        //     if (_service.isVerified) const VerifiedBadge(size: 18),
        //   ],
        // ),
        // const SizedBox(height: AppDimensions.spacing8),
        // Row(
        //   children: [
        //     AppRating(rating: _service.rating, size: 16),
        //     const SizedBox(width: AppDimensions.spacing8),
        //     Text(
        //       '(${_service.reviewCount} reviews)',
        //       style: AppTextStyles.bodySmall.copyWith(
        //         color: AppColors.textSecondary,
        //       ),
        //     ),
        //   ],
        // ),
        // const SizedBox(height: AppDimensions.spacing16),
        // _buildStatsRow(),
        const SizedBox(height: AppDimensions.spacing16),
        _buildPriceDisplay(discountedPrice),
      ],
    );
  }

  Widget _buildStatsRow() {
    final stats = [
      {
        'value': '${_service.completedJobs}',
        'label': 'Jobs Done',
        'icon': Icons.work_outline,
      },
      {
        'value': _service.responseTime,
        'label': 'Response',
        'icon': Icons.timer_outlined,
      },
      {
        'value': _service.experience,
        'label': 'Experience',
        'icon': Icons.auto_awesome_outlined,
      },
    ];

    return Row(
      children:
          stats.map((s) {
            return Expanded(
              child: Column(
                children: [
                  Icon(
                    s['icon'] as IconData,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: 4),
                  Text(s['value'] as String, style: AppTextStyles.titleSmall),
                  Text(s['label'] as String, style: AppTextStyles.caption),
                ],
              ),
            );
          }).toList(),
    );
  }

  Widget _buildPriceDisplay(double discountedPrice) {
    return Row(
      children: [
        Text(
          CurrencyFormatter.formatIndianRupees(discountedPrice),
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: AppDimensions.spacing8),
        Text(
          CurrencyFormatter.formatIndianRupees(_originalPrice),
          style: AppTextStyles.bodyMedium.copyWith(
            decoration: TextDecoration.lineThrough,
            color: AppColors.textTertiary,
          ),
        ),
        const SizedBox(width: AppDimensions.spacing8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.secondaryLight,
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          ),
          child: Text(
            '$_discountPercent% OFF',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const Spacer(),
        _buildInfoChip(Icons.timer_outlined, _displayDuration),
      ],
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

  Widget _buildExpandableSections() {
    final sections = _buildSectionData();
    return Column(
      children:
          sections.map((s) {
            return ExpandableSection(
              title: s['title'] as String,
              children: [s['content'] as Widget],
            );
          }).toList(),
    );
  }

  List<Map<String, dynamic>> _buildSectionData() {
    final details = _details;
    final includedItems =
        (details?.included ?? const <IncludedItem>[]).isNotEmpty
            ? details!.included.map((e) => e.title).toList()
            : <String>[
              'Dusting & wiping of all surfaces',
              'Vacuuming carpets & rugs',
              'Mopping all floors',
              'Kitchen counter & sink cleaning',
              'Bathroom scrubbing & sanitization',
              'Trash removal & disposal',
            ];
    final excludedItems =
        (details?.excluded ?? const <ExcludedItem>[]).isNotEmpty
            ? details!.excluded.map((e) => e.title).toList()
            : <String>[
              'External window cleaning',
              'Pest control services',
              'Carpet deep cleaning',
              'Appliance interior cleaning',
              'Garden maintenance',
              'Moving heavy furniture',
            ];
    final works =
        (details?.howItWorks ?? const <HowItWorksStep>[]).isNotEmpty
            ? details!.howItWorks
            : <HowItWorksStep>[
              HowItWorksStep(
                id: '',
                step: 1,
                title: 'Book a service with your preferred time slot',
              ),
              HowItWorksStep(
                id: '',
                step: 2,
                title: 'We assign a verified professional',
              ),
              HowItWorksStep(
                id: '',
                step: 3,
                title: 'Professional arrives at scheduled time',
              ),
              HowItWorksStep(
                id: '',
                step: 4,
                title: 'Service is completed with quality check',
              ),
              HowItWorksStep(
                id: '',
                step: 5,
                title: 'You can rate & review after service',
              ),
            ];
    final faqs =
        (details?.faqs ?? const <FAQ>[]).isNotEmpty
            ? details!.faqs
            : <FAQ>[
              FAQ(
                id: '',
                question: 'How long does the service take?',
                answer: 'Typically 2-3 hours depending on home size.',
              ),
              FAQ(
                id: '',
                question: 'Do I need to be home?',
                answer: 'Yes, or you can authorize someone else.',
              ),
              FAQ(
                id: '',
                question: 'What if I am not satisfied?',
                answer: 'We offer a free redo within 48 hours.',
              ),
              FAQ(
                id: '',
                question: 'Is equipment provided?',
                answer: 'Yes, all cleaning equipment is provided.',
              ),
            ];
    final whyChooseUs = details?.whyChooseUs ?? '';

    return [
      {
        'title': 'About this Service',
        'content': Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(_displayDescription, style: AppTextStyles.bodyMedium),
        ),
      },
      {
        'title': 'Included / Not Included',
        'content': Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            children: [
              _buildIncludedList(
                'Included',
                includedItems,
                Icons.check_circle,
                AppColors.success,
              ),
              const SizedBox(height: 12),
              _buildIncludedList(
                'Not Included',
                excludedItems,
                Icons.cancel,
                AppColors.error,
              ),
            ],
          ),
        ),
      },
      {
        'title': 'How it Works',
        'content': Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            children: works.map((w) => _buildStep(w.step, w.title)).toList(),
          ),
        ),
      },
      {
        'title': 'Safety Measures',
        'content': Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            children: [
              _buildSafetyItem('All professionals wear masks & gloves'),
              _buildSafetyItem('Eco-friendly cleaning products used'),
              _buildSafetyItem('Equipment sanitized before each visit'),
              _buildSafetyItem('Contactless service available'),
              _buildSafetyItem('COVID-19 vaccinated staff'),
              _buildSafetyItem('Insurance covered for damages'),
            ],
          ),
        ),
      },
      {
        'title': 'FAQ',
        'content': Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:
                faqs.map((f) => _buildFaqItem(f.question, f.answer)).toList(),
          ),
        ),
      },
      {
        'title': 'Why Choose Us',
        'content': Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            children:
                whyChooseUs.isNotEmpty
                    ? [_buildWhyChooseItem(whyChooseUs)]
                    : [
                      _buildWhyChooseItem('100% satisfaction guarantee'),
                      _buildWhyChooseItem('Verified & trained professionals'),
                      _buildWhyChooseItem('Eco-friendly products'),
                      _buildWhyChooseItem('Affordable pricing'),
                      _buildWhyChooseItem('Flexible scheduling'),
                      _buildWhyChooseItem('Dedicated customer support'),
                    ],
          ),
        ),
      },
    ];
  }

  Widget _buildIncludedList(
    String title,
    List<String> items,
    IconData icon,
    Color color,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.titleSmall.copyWith(color: color)),
        const SizedBox(height: 8),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, size: 18, color: color),
                const SizedBox(width: 8),
                Expanded(child: Text(item, style: AppTextStyles.bodyMedium)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep(int number, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$number',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(text, style: AppTextStyles.bodyMedium),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shield, size: 18, color: AppColors.success),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Q: ',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              Expanded(
                child: Text(
                  question,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'A: ',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.secondary,
                ),
              ),
              Expanded(
                child: Text(
                  answer,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWhyChooseItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle, size: 18, color: AppColors.success),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }

  Widget _buildAddOnsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Add-ons', style: AppTextStyles.titleLarge),
        const SizedBox(height: AppDimensions.spacing12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: List.generate(_addOnItems.length, (i) {
            final item = _addOnItems[i];
            return AddOnChip(
              label: item['label'] as String,
              price: item['price'] as String,
              initiallySelected: (item['quantity'] as int) > 0,
              onQuantityChanged: (qty) {
                setState(() => _addOnItems[i]['quantity'] = qty);
              },
            );
          }),
        ),
        if (_addOnItems.any((a) => (a['quantity'] as int) > 0))
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Text(
              'Total add-ons: ${CurrencyFormatter.formatIndianRupees(_totalAddOnCost())}',
              style: AppTextStyles.titleSmall.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }

  double _totalAddOnCost() {
    double total = 0;
    for (final item in _addOnItems) {
      final qty = item['quantity'] as int;
      final priceStr = (item['price'] as String).replaceAll('₹', '');
      final price = double.tryParse(priceStr) ?? 0;
      total += price * qty;
    }
    return total;
  }

  Widget _buildReviewsSection() {
    final reviewsProv = context.watch<PackageReviewsProvider>();
    final reviews = reviewsProv.reviews;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Customer Reviews', style: AppTextStyles.titleLarge),
            TextButton(
              onPressed: _showWriteReviewDialog,
              child: Text(
                'Write a Review',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppDimensions.spacing12),
        _buildRatingSummary(reviewsProv.summary),
        const SizedBox(height: AppDimensions.spacing16),
        if (reviewsProv.isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
            ),
          )
        else if (reviews.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Center(
              child: Text(
                'No reviews yet for this service',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
              ),
            ),
          )
        else
          ...reviews.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: AppDimensions.spacing12),
              child: _buildReviewCard(r),
            ),
          ),
      ],
    );
  }

  Widget _buildRatingSummary(ReviewSummary? summary) {
    final averageRating = summary?.averageRating ?? 0;
    final totalReviews = summary?.totalReviews ?? 0;
    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                averageRating > 0 ? averageRating.toStringAsFixed(1) : '0.0',
                style: AppTextStyles.displayMedium.copyWith(
                  color: AppColors.accent,
                ),
              ),
              AppRating(rating: averageRating, size: 14, showValue: false),
              Text('$totalReviews reviews', style: AppTextStyles.caption),
            ],
          ),
          const SizedBox(width: AppDimensions.spacing16),
          Expanded(
            child: Column(
              children: List.generate(5, (i) {
                final star = 5 - i;
                final percentage = summary?.distributionFor(star) ?? 0.0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Text('$star', style: AppTextStyles.caption),
                      const SizedBox(width: 4),
                      Icon(Icons.star, size: 12, color: AppColors.accent),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: percentage,
                            backgroundColor: AppColors.border,
                            color: AppColors.accent,
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${(percentage * 100).toInt()}%',
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(ReviewModel review) {
    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  review.userName.isNotEmpty
                      ? review.userName[0].toUpperCase()
                      : '?',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.userName, style: AppTextStyles.titleSmall),
                    Text(review.date, style: AppTextStyles.caption),
                  ],
                ),
              ),
              AppRating(rating: review.rating, size: 14, showValue: false),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing8),
          Text(review.comment, style: AppTextStyles.bodyMedium),
          if (review.images.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.spacing8),
            SizedBox(
              height: 60,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: review.images.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  return Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.image_outlined,
                      color: AppColors.primary,
                      size: 24,
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showWriteReviewDialog() {
    double rating = 5;
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return AlertDialog(
              title: const Text('Write a Review'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (i) {
                      return IconButton(
                        icon: Icon(
                          i < rating ? Icons.star : Icons.star_border,
                          color: AppColors.accent,
                          size: 32,
                        ),
                        onPressed: () => setDialogState(() => rating = i + 1),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Share your experience...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Review submitted!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                  ),
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildProviderSection() {
    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  _professional.name.isNotEmpty
                      ? _professional.name[0].toUpperCase()
                      : '?',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: AppDimensions.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          _professional.name,
                          style: AppTextStyles.titleMedium,
                        ),
                        const SizedBox(width: AppDimensions.spacing8),
                        if (_professional.isVerified)
                          const VerifiedBadge(size: 16),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_professional.experience} years experience',
                      style: AppTextStyles.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        AppRating(
                          rating: _professional.rating,
                          size: 14,
                          showValue: true,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${_professional.jobsCompleted} jobs',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed:
                    () => context.push('/professional/${_professional.id}'),
                child: Text(
                  'View Profile',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          if (_professional.skills.isNotEmpty) ...[
            const SizedBox(height: AppDimensions.spacing12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children:
                  _professional.skills.take(4).map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Text(
                        skill,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ],
          const SizedBox(height: AppDimensions.spacing12),
          Row(
            children: [
              if (_professional.languages.isNotEmpty)
                Text(
                  _professional.languages.join(', '),
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              const Spacer(),
              if (_professional.isEmergencyAvailable)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.secondaryLight,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Emergency Available',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.secondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStickyBottom(PackageDetails? details) {
    final discountedPrice = _offerPrice;
    final totalAddOn = _totalAddOnCost();
    final total = discountedPrice + totalAddOn;

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
                    'Total',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    CurrencyFormatter.formatIndianRupees(total),
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
                      packageId: details!.package.id,
                      packageName: details!.package.name,
                      packagePrice: details!.package.offerPrice,
                    ),
                  );
                },

                // () => context.push(
                //   '/booking',
                //   extra: {
                //     'service': _service,
                //     'package': _selectedPackage,
                //     'addOns':
                //         _addOnItems
                //             .where((a) => (a['quantity'] as int) > 0)
                //             .toList(),
                //   },
                // ),
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
                child: Text('Book Now', style: AppTextStyles.buttonLarge),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
