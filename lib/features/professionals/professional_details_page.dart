import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/widgets/app_rating.dart';
import 'package:user_servicehub/core/widgets/app_card.dart';
import 'package:user_servicehub/core/utils/currency_formatter.dart';
import 'package:user_servicehub/data/models/professional_model.dart';
import 'package:user_servicehub/data/models/review_model.dart';
import 'package:user_servicehub/data/mock/mock_professionals.dart';
import 'package:user_servicehub/data/mock/mock_reviews.dart';

class ProfessionalDetailsPage extends StatefulWidget {
  final String professionalId;

  const ProfessionalDetailsPage({super.key, required this.professionalId});

  @override
  State<ProfessionalDetailsPage> createState() =>
      _ProfessionalDetailsPageState();
}

class _ProfessionalDetailsPageState extends State<ProfessionalDetailsPage> {
  late ProfessionalModel _professional;
  late List<ReviewModel> _reviews;
  late List<DateTime> _dates;
  int _selectedDateIndex = 0;
  String? _selectedSlot;
  final List<String> _morningSlots = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
  ];
  final List<String> _afternoonSlots = [
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
  ];
  final List<String> _unavailableSlots = ['11:00 AM', '03:00 PM'];
  final List<String> _galleryImages = [
    'assets/images/gallery/work1.jpg',
    'assets/images/gallery/work2.jpg',
    'assets/images/gallery/work3.jpg',
    'assets/images/gallery/work4.jpg',
    'assets/images/gallery/work5.jpg',
    'assets/images/gallery/work6.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _professional = mockProfessionals.firstWhere(
      (p) => p.id == widget.professionalId,
      orElse: () => mockProfessionals.first,
    );
    _reviews =
        mockReviews
            .where(
              (r) => _professional.skills.any(
                (s) => r.serviceName.toLowerCase().contains(s.toLowerCase()),
              ),
            )
            .toList();
    if (_reviews.isEmpty) {
      _reviews = mockReviews.take(3).toList();
    }
    _dates = List.generate(7, (i) {
      return DateTime.now().add(Duration(days: i));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text('Professional', style: AppTextStyles.titleMedium),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, size: 20),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
            const SizedBox(height: AppDimensions.spacing16),
            _buildStatsRow(),
            const SizedBox(height: AppDimensions.spacing16),
            _buildSkillsSection(),
            const SizedBox(height: AppDimensions.spacing16),
            _buildLanguagesSection(),
            const SizedBox(height: AppDimensions.spacing16),
            _buildServiceAreasSection(),
            const SizedBox(height: AppDimensions.spacing16),
            _buildGallerySection(),
            const SizedBox(height: AppDimensions.spacing16),
            _buildReviewsSection(),
            const SizedBox(height: AppDimensions.spacing16),
            // _buildAvailableSlotsSection(),
            // const SizedBox(height: AppDimensions.spacing16),
            // _buildPricingSection(),
            // const SizedBox(height: 120),
          ],
        ),
      ),

      // bottomNavigationBar: Container(
      //   padding: const EdgeInsets.fromLTRB(
      //     AppDimensions.spacing16,
      //     AppDimensions.spacing12,
      //     AppDimensions.spacing16,
      //     AppDimensions.spacing24,
      //   ),
      //   decoration: BoxDecoration(
      //     color: AppColors.surface,
      //     boxShadow: [
      //       BoxShadow(
      //         color: AppColors.shadow,
      //         blurRadius: 12,
      //         offset: const Offset(0, -4),
      //       ),
      //     ],
      //   ),
      //   child: SizedBox(
      //     width: double.infinity,
      //     height: AppDimensions.buttonHeight,
      //     child: ElevatedButton(
      //       onPressed:
      //           () => context.push(
      //             '/booking',
      //             extra: {'professional': _professional, 'slot': _selectedSlot},
      //           ),
      //       style: ElevatedButton.styleFrom(
      //         backgroundColor: AppColors.primary,
      //         foregroundColor: AppColors.white,
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
      //         ),
      //         elevation: 0,
      //       ),
      //       child: Text(
      //         'Book ${_professional.name.split(' ').first}',
      //         style: AppTextStyles.buttonLarge,
      //       ),
      //     ),
      //   ),
      // ),
    );
  }

  Widget _buildProfileHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      child: AppCard(
        padding: const EdgeInsets.all(AppDimensions.spacing20),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: AppColors.primaryLight,
                  child: Text(
                    _professional.name.isNotEmpty
                        ? _professional.name[0].toUpperCase()
                        : '?',
                    style: AppTextStyles.displayMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
                if (_professional.isVerified)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.verified,
                        size: 20,
                        color: AppColors.white,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_professional.name, style: AppTextStyles.headlineSmall),
                if (_professional.isVerified) ...[
                  const SizedBox(width: 6),
                  const Icon(
                    Icons.verified,
                    size: 20,
                    color: AppColors.primary,
                  ),
                ],
              ],
            ),
            const SizedBox(height: AppDimensions.spacing8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppRating(
                  rating: _professional.rating,
                  size: 18,
                  showValue: true,
                ),
                const SizedBox(width: 8),
                Text(
                  '(${_professional.jobsCompleted} jobs)',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      child: Row(
        children: [
          Expanded(
            child: _statCard(
              '${_professional.jobsCompleted}',
              'Jobs Completed',
              AppColors.primary,
            ),
          ),
          const SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: _statCard(
              _professional.responseTime,
              'Response Time',
              AppColors.secondary,
            ),
          ),
          const SizedBox(width: AppDimensions.spacing12),
          Expanded(
            child: _statCard(
              '${_professional.experience} yrs',
              'Experience',
              AppColors.accent,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppDimensions.spacing16,
        horizontal: AppDimensions.spacing8,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.titleLarge.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('Skills', style: AppTextStyles.titleMedium),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _professional.skills.map((s) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(9999),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      s,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguagesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('Languages', style: AppTextStyles.titleMedium),
          ),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                _professional.languages.map((l) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondaryLight,
                      borderRadius: BorderRadius.circular(9999),
                      border: Border.all(
                        color: AppColors.secondary.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      l,
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceAreasSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      child: AppCard(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              ),
              child: const Icon(
                Icons.location_on_outlined,
                color: AppColors.primary,
                size: 22,
              ),
            ),
            const SizedBox(width: AppDimensions.spacing16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Service Areas',
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _professional.serviceAreas.join(', '),
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGallerySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text('Gallery', style: AppTextStyles.titleMedium),
          ),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _galleryImages.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, i) {
                return Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusMedium,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.image_outlined,
                        size: 32,
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Work ${i + 1}',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Reviews', style: AppTextStyles.titleMedium),
              TextButton(onPressed: () {}, child: const Text('See All')),
            ],
          ),
          if (_reviews.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'No reviews yet',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ),
            )
          else
            ..._reviews
                .take(3)
                .map(
                  (r) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildReviewCard(r),
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
        ],
      ),
    );
  }

  Widget _buildAvailableSlotsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      child: AppCard(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Available Slots', style: AppTextStyles.titleMedium),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _dates.isNotEmpty
                            ? _formatDate(_dates[_selectedDateIndex])
                            : '',
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing16),
            SizedBox(
              height: 60,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _dates.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final date = _dates[i];
                  final selected = _selectedDateIndex == i;
                  return GestureDetector(
                    onTap:
                        () => setState(() {
                          _selectedDateIndex = i;
                          _selectedSlot = null;
                        }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 60,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        color:
                            selected ? AppColors.primary : AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color:
                              selected ? AppColors.primary : AppColors.border,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getDayAbbr(date),
                            style: AppTextStyles.labelSmall.copyWith(
                              color:
                                  selected
                                      ? AppColors.white
                                      : AppColors.textTertiary,
                              fontSize: 10,
                            ),
                          ),
                          Text(
                            '${date.day}',
                            style: AppTextStyles.titleSmall.copyWith(
                              color:
                                  selected
                                      ? AppColors.white
                                      : AppColors.textPrimary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            _getMonthAbbr(date),
                            style: AppTextStyles.labelSmall.copyWith(
                              color:
                                  selected
                                      ? AppColors.white
                                      : AppColors.textTertiary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppDimensions.spacing16),
            _buildTimeSlots('Morning', _morningSlots),
            const SizedBox(height: AppDimensions.spacing12),
            _buildTimeSlots('Afternoon', _afternoonSlots),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlots(String label, List<String> slots) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              slots.map((slot) {
                final isUnavailable = _unavailableSlots.contains(slot);
                final isSelected = _selectedSlot == slot;
                return GestureDetector(
                  onTap:
                      isUnavailable
                          ? null
                          : () => setState(() => _selectedSlot = slot),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color:
                          isSelected
                              ? AppColors.primary
                              : isUnavailable
                              ? AppColors.border.withValues(alpha: 0.3)
                              : AppColors.background,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            isSelected
                                ? AppColors.primary
                                : isUnavailable
                                ? AppColors.border.withValues(alpha: 0.3)
                                : AppColors.border,
                      ),
                    ),
                    child: Text(
                      slot,
                      style: AppTextStyles.labelMedium.copyWith(
                        color:
                            isSelected
                                ? AppColors.white
                                : isUnavailable
                                ? AppColors.textTertiary
                                : AppColors.textPrimary,
                        decoration:
                            isUnavailable ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildPricingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing16),
      child: AppCard(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Pricing', style: AppTextStyles.titleMedium),
            const SizedBox(height: AppDimensions.spacing12),
            Row(
              children: [
                Text(
                  CurrencyFormatter.formatIndianRupees(_professional.basePrice),
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Starting price',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing12),
            const Divider(height: 1),
            const SizedBox(height: AppDimensions.spacing12),
            Text('Packages Available', style: AppTextStyles.titleSmall),
            const SizedBox(height: AppDimensions.spacing8),
            _buildPackageRow('Basic', '1 hour', _professional.basePrice),
            _buildPackageRow(
              'Standard',
              '2-3 hours',
              _professional.basePrice * 2.5,
            ),
            _buildPackageRow(
              'Premium',
              '4-6 hours',
              _professional.basePrice * 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageRow(String name, String duration, double price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              name,
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              duration,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Text(
            CurrencyFormatter.formatIndianRupees(price),
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getDayAbbr(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  String _getMonthAbbr(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[date.month - 1];
  }

  String _formatDate(DateTime date) {
    return '${date.day} ${_getMonthAbbr(date)}';
  }
}
