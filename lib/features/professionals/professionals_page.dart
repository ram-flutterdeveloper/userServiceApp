import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/widgets/app_rating.dart';
import 'package:user_servicehub/data/models/professional_model.dart';
import 'package:user_servicehub/data/mock/mock_professionals.dart';

class ProfessionalsPage extends StatefulWidget {
  const ProfessionalsPage({super.key});

  @override
  State<ProfessionalsPage> createState() => _ProfessionalsPageState();
}

class _ProfessionalsPageState extends State<ProfessionalsPage> {
  String _selectedFilter = 'All';
  late List<ProfessionalModel> _filtered;

  final List<String> _filters = [
    'All',
    'Electricians',
    'Plumbers',
    'Cleaners',
    'AC Repair',
    'Painters',
    'Carpenters',
  ];

  @override
  void initState() {
    super.initState();
    _filtered = List.from(mockProfessionals);
  }

  void _applyFilter(String filter) {
    setState(() {
      _selectedFilter = filter;
      if (filter == 'All') {
        _filtered = List.from(mockProfessionals);
      } else {
        final skillMap = {
          'Electricians': ['Wiring', 'Circuit', 'Switchboard', 'Fan', 'Inverter'],
          'Plumbers': ['Pipe', 'Tap', 'Drainage', 'Water Heater', 'Bathroom Fitting'],
          'Cleaners': ['Deep Cleaning', 'Sofa', 'Carpet', 'Kitchen', 'Bathroom Cleaning'],
          'AC Repair': ['AC Installation', 'Gas Refilling', 'Compressor', 'Split AC', 'Inverter AC'],
          'Painters': ['Interior Painting', 'Exterior Painting', 'Wall Texture', 'Waterproofing', 'Wood Polishing'],
          'Carpenters': ['Furniture Assembly', 'Door Fitting', 'Window Repair', 'Modular Kitchen', 'Custom Woodwork'],
        };
        final keywords = skillMap[filter] ?? [];
        _filtered = mockProfessionals.where((p) {
          return p.skills.any((s) => keywords.any((k) => s.contains(k)));
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        title:  Text('Professionals', style: AppTextStyles.titleMedium),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilterChips(),
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.person_search_outlined,
                          size: 64,
                          color: AppColors.textTertiary,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No professionals found',
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.spacing16,
                      AppDimensions.spacing8,
                      AppDimensions.spacing16,
                      AppDimensions.spacing24,
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: AppDimensions.spacing12,
                      mainAxisSpacing: AppDimensions.spacing12,
                    ),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) => _buildProfessionalCard(_filtered[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      color: AppColors.surface,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing12,
        ),
        child: Row(
          children: _filters.map((f) {
            final selected = _selectedFilter == f;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(
                  f,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: selected ? AppColors.white : AppColors.textPrimary,
                  ),
                ),
                selected: selected,
                selectedColor: AppColors.primary,
                checkmarkColor: AppColors.white,
                backgroundColor: AppColors.background,
                side: BorderSide(
                  color: selected ? AppColors.primary : AppColors.border,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9999),
                ),
                onSelected: (_) => _applyFilter(f),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildProfessionalCard(ProfessionalModel professional) {
    return GestureDetector(
      onTap: () => context.push('/professional/${professional.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          boxShadow: [
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
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppDimensions.radiusCard),
                  ),
                ),
                child: Stack(
                  children: [
                    Center(
                      child: Text(
                        professional.name.isNotEmpty
                            ? professional.name[0].toUpperCase()
                            : '?',
                        style: AppTextStyles.displayMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    if (professional.isVerified)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.verified,
                            size: 14,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondaryLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${professional.experience} yrs',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.secondary,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacing12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    professional.name,
                    style: AppTextStyles.titleSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      AppRating(
                        rating: professional.rating,
                        size: 12,
                        showValue: true,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${professional.jobsCompleted})',
                        style: AppTextStyles.caption.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (professional.skills.isNotEmpty)
                    Text(
                      professional.skills.take(2).join(', '),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    height: 32,
                    child: ElevatedButton(
                      onPressed: () =>
                          context.push('/professional/${professional.id}'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        'View Profile',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.white,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
