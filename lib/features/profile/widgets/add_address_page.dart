import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/constants/google_places_config.dart';
import 'package:user_servicehub/core/utils/google_place_helpers.dart';
import 'package:user_servicehub/data/logic/provider/address_provider.dart';
import 'package:user_servicehub/features/widget/custom_text_field.dart';

class AddAddressPage extends StatefulWidget {
  const AddAddressPage({super.key});

  @override
  State<AddAddressPage> createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressProvider>().fetchCities();
    });
  }

  Future<void> _onPlaceSelected(Prediction prediction) async {
    if (prediction.placeId == null) return;

    final provider = context.read<AddressProvider>();
    provider.setFetchingPlaceDetails(true);
    provider.addressSearchController.text = prediction.description ?? '';

    final detail = await GooglePlaceHelpers.getPlaceDetailsFromPlaceId(
      prediction.placeId!,
    );

    if (!mounted) return;

    if (detail == null) {
      provider.setFetchingPlaceDetails(false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to fetch place details')),
        );
      }
      return;
    }

    final parsed = GooglePlaceHelpers.parsePlaceComponents(detail);

    provider.streetController.text = parsed.street;
    provider.latitudeController.text = parsed.latitude.toString();
    provider.longitudeController.text = parsed.longitude.toString();

    provider.autoSelectCityAndArea(parsed);

    provider.addressLineController.text = [
      if (parsed.street.isNotEmpty) parsed.street,
      if (parsed.city.isNotEmpty) parsed.city,
      if (parsed.state.isNotEmpty) parsed.state,
      if (parsed.pincode.isNotEmpty) parsed.pincode,
    ].join(', ');

    provider.setFetchingPlaceDetails(false);
  }

  Future<void> _submitAddress() async {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<AddressProvider>();

    if (provider.selectedCity == null) {
      _showError('Please select a city');
      return;
    }
    if (provider.selectedArea == null) {
      _showError('Please select an area');
      return;
    }

    final lat = double.tryParse(provider.latitudeController.text.trim());
    final lng = double.tryParse(provider.longitudeController.text.trim());
    if (lat == null || lng == null || (lat == 0.0 && lng == 0.0)) {
      _showError('Please search for a valid address to get coordinates');
      return;
    }

    final data = provider.buildAddressData();
    final success = await provider.createAddress(data);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Address saved successfully')),
      );
      provider.fetchAddresses();
      context.pop();
    } else if (mounted) {
      final error = provider.error;
      _showError(error ?? 'Failed to save address');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AddressProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Add New Address',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _buildSectionHeader('Location'),
              const SizedBox(height: 12),
              _buildCityDropdown(provider),
              const SizedBox(height: 12),
              _buildAreaDropdown(provider),
              const SizedBox(height: 24),
              _buildSectionHeader('Address Details'),
              const SizedBox(height: 12),

              _buildSectionHeader('Search Address'),
              const SizedBox(height: 12),
              _buildGooglePlacesSearch(provider),
              if (provider.isFetchingPlaceDetails) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Fetching place details...',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              CustomTextField(
                controller: provider.addressLineController,
                labelText: 'Full Address Line',

                prefix: Icon(Icons.location_on_outlined, size: 20),
                maxLines: 2,
                validator:
                    (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: provider.houseNoController,
                labelText: 'House No.',

                prefix: Icon(Icons.home_outlined, size: 20),
                validator:
                    (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              CustomTextField(
                controller: provider.buildingNameController,
                labelText: 'Building Name',
                prefix: Icon(Icons.apartment_outlined, size: 20),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: provider.floorController,
                labelText: 'Floor',
                prefix: Icon(Icons.layers_outlined, size: 20),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: provider.streetController,
                labelText: 'Street',
                prefix: Icon(Icons.route_outlined, size: 20),
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: provider.landmarkController,
                labelText: 'Landmark',
                prefix: Icon(Icons.pin_drop_outlined, size: 20),
              ),
              const SizedBox(height: 12),

              const SizedBox(height: 24),
              _buildSectionHeader('Coordinates'),
              const SizedBox(height: 12),
              // Row(
              //   children: [
              //     Expanded(
              //       child: CustomTextField(
              //         controller: provider.latitudeController,
              //         label: 'Latitude',
              //         icon: Icons.my_location,
              //         keyboardType: TextInputType.number,
              //       ),
              //     ),
              //     const SizedBox(width: 12),
              //     Expanded(
              //       child: CustomTextField(
              //         controller: provider.longitudeController,
              //         label: 'Longitude',
              //         icon: Icons.my_location,
              //         keyboardType: TextInputType.number,
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 24),
              _buildSectionHeader('Contact Person'),
              const SizedBox(height: 12),
              CustomTextField(
                controller: provider.contactPersonController,
                labelText: 'Contact Person Name',

                prefix: Icon(Icons.person_outline, size: 20),
                validator:
                    (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                controller: provider.contactNumberController,
                labelText: 'Contact Number',

                prefix: Icon(Icons.phone_outlined, size: 20),
                keyBoardType: TextInputType.phone,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Required';
                  if (v.trim().length < 10) return 'Enter valid number';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _buildSectionHeader('Address Type'),
              const SizedBox(height: 12),
              _buildAddressTypeSelector(provider),
              const SizedBox(height: 16),
              _buildDefaultSwitch(provider),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildSubmitButton(provider),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildGooglePlacesSearch(AddressProvider provider) {
    return Container(
      decoration: BoxDecoration(
        // color: Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary, width: 1),
      ),
      child: GooglePlaceAutoCompleteTextField(
        textEditingController: provider.addressSearchController,
        googleAPIKey: GooglePlacesConfig.apiKey,
        inputDecoration: InputDecoration(
          hintText: 'Search address...',
          hintStyle: TextStyle(fontSize: 14, color: AppColors.textTertiary),
          prefixIcon: const Icon(Icons.search_rounded, size: 22),
          suffixIcon:
              provider.isFetchingPlaceDetails
                  ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    ),
                  )
                  : null,
          filled: false,

          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          // border: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          //   borderSide: BorderSide(
          //     color: AppColors.border.withValues(alpha: 0.4),
          //   ),
          // ),
          // enabledBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          //   borderSide: BorderSide(
          //     color: AppColors.border.withValues(alpha: 0.4),
          //   ),
          // ),
          // focusedBorder: OutlineInputBorder(
          //   borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          //   borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
          // ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),

        debounceTime: 400,
        countries: const ["in"],
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) {
          _onPlaceSelected(prediction);
        },
        itemClick: (Prediction prediction) {
          provider.addressSearchController.text = prediction.description ?? '';
          provider
              .addressSearchController
              .selection = TextSelection.fromPosition(
            TextPosition(offset: prediction.description?.length ?? 0),
          );
        },
        seperatedBuilder: Divider(
          height: 1,
          color: AppColors.border.withValues(alpha: 0.3),
        ),
        containerHorizontalPadding: 10,
        itemBuilder: (context, index, Prediction prediction) {
          return Container(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSmall,
                    ),
                  ),
                  child: const Icon(
                    Icons.location_on_rounded,
                    color: AppColors.primary,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    prediction.description ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
        isCrossBtnShown: true,
      ),
    );
  }

  Widget _buildCityDropdown(AddressProvider provider) {
    return DropdownButtonFormField<String>(
      value: provider.selectedCityId,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Select City',
        prefixIcon: const Icon(Icons.location_city_outlined, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          borderSide: const BorderSide(color: AppColors.primary, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          borderSide: const BorderSide(color: AppColors.primary, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
      items:
          provider.cities.map((city) {
            return DropdownMenuItem<String>(
              value: city.id,
              child: Text(
                '${city.name}, ${city.state}',
                style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
              ),
            );
          }).toList(),
      onChanged: (cityId) {
        if (cityId != null) {
          provider.setSelectedCity(cityId);
        }
      },
      validator: (v) => v == null ? 'Please select a city' : null,
    );
  }

  Widget _buildAreaDropdown(AddressProvider provider) {
    if (provider.selectedCityId == null) {
      return DropdownButtonFormField<String>(
        isExpanded: true,
        decoration: InputDecoration(
          labelText: 'Select Area',
          prefixIcon: const Icon(Icons.map_outlined, size: 20),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            borderSide: const BorderSide(color: AppColors.primary, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            borderSide: const BorderSide(color: AppColors.primary, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 14,
          ),
        ),
        items: const [],
        onChanged: null,
      );
    }

    if (provider.isLoadingAreas) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(width: 12),
            Text(
              'Loading areas...',
              style: TextStyle(fontSize: 14, color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }

    return DropdownButtonFormField<String>(
      value: provider.selectedAreaId,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: 'Select Area',
        prefixIcon: const Icon(Icons.map_outlined, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
      items:
          provider.areas.map((area) {
            return DropdownMenuItem<String>(
              value: area.id,
              child: Text(
                area.name,
                style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
              ),
            );
          }).toList(),
      onChanged: (areaId) {
        if (areaId != null) {
          provider.setSelectedArea(areaId);
        }
      },
      validator: (v) => v == null ? 'Please select an area' : null,
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildAddressTypeSelector(AddressProvider provider) {
    final types = [
      {'value': 'HOME', 'label': 'Home', 'icon': Icons.home_rounded},
      {'value': 'WORK', 'label': 'Work', 'icon': Icons.business_rounded},
      {'value': 'OTHER', 'label': 'Other', 'icon': Icons.location_on_rounded},
    ];

    return Row(
      children:
          types.map((type) {
            final isSelected = provider.addressType == type['value'];
            return Expanded(
              child: GestureDetector(
                onTap: () => provider.setAddressType(type['value'] as String),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? AppColors.primaryLight : AppColors.surface,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSmall,
                    ),
                    border: Border.all(
                      color:
                          isSelected
                              ? AppColors.primary
                              : AppColors.border.withValues(alpha: 0.4),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        type['icon'] as IconData,
                        color:
                            isSelected
                                ? AppColors.primary
                                : AppColors.textTertiary,
                        size: 22,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        type['label'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color:
                              isSelected
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget _buildDefaultSwitch(AddressProvider provider) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: provider.isDefault ? AppColors.primaryLight : AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(
          color:
              provider.isDefault
                  ? AppColors.primary
                  : AppColors.border.withValues(alpha: 0.4),
          width: provider.isDefault ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color:
                  provider.isDefault
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : AppColors.border.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            child: Icon(
              Icons.star_rounded,
              color:
                  provider.isDefault
                      ? AppColors.primary
                      : AppColors.textTertiary,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set as Default Address',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color:
                        provider.isDefault
                            ? AppColors.primary
                            : AppColors.textPrimary,
                  ),
                ),
                Text(
                  'This address will be selected by default for bookings',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: provider.isDefault,
            onChanged: (v) => provider.setIsDefault(v),
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(AddressProvider provider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: AppColors.border,
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: FilledButton.icon(
            onPressed: provider.isCreatingAddress ? null : _submitAddress,
            icon:
                provider.isCreatingAddress
                    ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                    : const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 18,
                    ),
            label: Text(
              provider.isCreatingAddress ? 'Saving...' : 'Save Address',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
              ),
              elevation: 0,
            ),
          ),
        ),
      ),
    );
  }
}
