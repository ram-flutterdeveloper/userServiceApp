import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';
import 'package:user_servicehub/core/widgets/app_search_field.dart';
import 'package:user_servicehub/data/logic/provider/home_provider.dart';
import 'package:user_servicehub/data/models/searched_place.dart';

class LocationPickerSheet extends StatefulWidget {
  const LocationPickerSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusBottomSheet),
          topRight: Radius.circular(AppDimensions.radiusBottomSheet),
        ),
      ),
      builder: (_) => const LocationPickerSheet(),
    );
  }

  @override
  State<LocationPickerSheet> createState() => _LocationPickerSheetState();
}

class _LocationPickerSheetState extends State<LocationPickerSheet> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<HomeProvider>().searchPlaces(value);
    });
  }

  void _onSelectPlace(SearchedPlace place) {
    Navigator.of(context).pop();
    context.read<HomeProvider>().selectPlace(place);
  }

  void _onUseCurrentLocation() {
    Navigator.of(context).pop();
    context.read<HomeProvider>().useCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<HomeProvider>();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.75,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(top: 12, bottom: 12),
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Change Location',
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 22),
                      color: AppColors.textSecondary,
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: AppSearchField(
                  controller: _searchController,
                  hint: 'Search area, street, landmark...',
                  autoFocus: true,
                  onChanged: _onSearchChanged,
                ),
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  padding: const EdgeInsets.only(bottom: 16),
                  children: [
                    if (_searchController.text.trim().length < 3) ...[
                      _buildSectionTitle('Current Location'),
                      _buildCurrentLocationTile(provider),
                      _buildSectionTitle('Selected Address'),
                      _buildSelectedAddressTile(provider),
                    ] else ...[
                      _buildSectionTitle('Search Results'),
                      _buildSearchBody(provider),
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

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        title,
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.textTertiary,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildCurrentLocationTile(HomeProvider provider) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: provider.isLocating
            ? const Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.primary,
                ),
              )
            : const Icon(
                Icons.my_location_rounded,
                size: 20,
                color: AppColors.primary,
              ),
      ),
      title: Text(
        'Use my current location',
        style: AppTextStyles.bodyMedium.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
      subtitle: Text(
        'GPS will detect your position automatically',
        style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
      ),
      onTap: provider.isLocating ? null : _onUseCurrentLocation,
    );
  }

  Widget _buildSelectedAddressTile(HomeProvider provider) {
    final label = provider.locationLabel;
    final isSet = label != 'Set your location';

    return ListTile(
      enabled: false,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.secondary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        ),
        child: Icon(
          isSet ? Icons.location_on_rounded : Icons.location_off_rounded,
          size: 20,
          color: AppColors.secondary,
        ),
      ),
      title: Text(
        isSet ? label : 'No address selected yet',
        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        isSet ? 'Currently showing services for this location' : '',
        style: AppTextStyles.caption.copyWith(color: AppColors.textTertiary),
      ),
    );
  }

  Widget _buildSearchBody(HomeProvider provider) {
    if (provider.isSearching) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (provider.searchResults.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 36,
              color: AppColors.textTertiary,
            ),
            const SizedBox(height: 8),
            Text(
              'No addresses found',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Try a different area or landmark name',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textTertiary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children:
          provider.searchResults.map((place) {
            return ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                ),
                child: const Icon(
                  Icons.place_outlined,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
              ),
              title: Text(
                place.label,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                place.locality.isNotEmpty
                    ? place.locality
                    : '${place.latitude.toStringAsFixed(4)}, ${place.longitude.toStringAsFixed(4)}',
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textTertiary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: const Icon(
                Icons.north_east_rounded,
                size: 16,
                color: AppColors.textTertiary,
              ),
              onTap: () => _onSelectPlace(place),
            );
          }).toList(),
    );
  }
}
