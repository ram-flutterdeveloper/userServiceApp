import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:user_servicehub/core/constants/api.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';
import 'package:user_servicehub/core/widgets/app_button.dart';
import 'package:user_servicehub/core/widgets/app_error_state.dart';
import 'package:user_servicehub/core/widgets/app_loading_indicator.dart';
import 'package:user_servicehub/data/logic/provider/profile_provider.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<ProfileProvider>();
      provider.fetchProfile();
    });
  }

  void _showPhotoOptions(ProfileProvider provider) {
    final hasImage =
        provider.profileImageFile != null ||
        (provider.profile?.profileImage?.isNotEmpty == true);
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusBottomSheet),
        ),
      ),
      builder:
          (ctx) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spacing20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.border,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing20),
                  Text(
                    'Change Profile Photo',
                    style: AppTextStyles.titleMedium,
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  ListTile(
                    leading: const Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.textPrimary,
                    ),
                    title: const Text(
                      'Take Photo',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      provider.pickProfileImage(ImageSource.camera);
                    },
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.photo_library_outlined,
                      color: AppColors.textPrimary,
                    ),
                    title: const Text(
                      'Choose from Gallery',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                    onTap: () {
                      Navigator.of(ctx).pop();
                      provider.pickProfileImage(ImageSource.gallery);
                    },
                  ),
                  if (hasImage)
                    ListTile(
                      leading: const Icon(
                        Icons.delete_outline,
                        color: AppColors.error,
                      ),
                      title: const Text(
                        'Remove Photo',
                        style: TextStyle(color: AppColors.error),
                      ),
                      onTap: () {
                        Navigator.of(ctx).pop();
                        provider.removeProfileImage();
                      },
                    ),
                ],
              ),
            ),
          ),
    );
  }

  Future<void> _pickDate(ProfileProvider provider) async {
    DateTime initialDate = DateTime(1998, 5, 18);
    if (provider.dob.isNotEmpty) {
      final parts = provider.dob.split('-');
      if (parts.length == 3) {
        initialDate = DateTime(
          int.tryParse(parts[0]) ?? 1998,
          int.tryParse(parts[1]) ?? 5,
          int.tryParse(parts[2]) ?? 18,
        );
      }
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(
              context,
            ).colorScheme.copyWith(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      provider.setDateOfBirth(picked);
    }
  }

  Future<void> _saveProfile(ProfileProvider provider) async {
    if (!_formKey.currentState!.validate()) return;

    final success = await provider.updateProfile();
    if (!mounted) return;

    if (provider.updateError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.updateError!),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      if (context.mounted) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();

    if (_hasInitialized == false && provider.profile != null) {
      _hasInitialized = true;
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final shouldPop = await showDialog<bool>(
          context: context,
          builder:
              (ctx) => AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                ),
                title: const Text('Discard Changes?'),
                content: const Text(
                  'Are you sure you want to go back? Unsaved changes will be lost.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(false),
                    child: const Text('Keep Editing'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(ctx).pop(true),
                    child: const Text(
                      'Discard',
                      style: TextStyle(color: AppColors.error),
                    ),
                  ),
                ],
              ),
        );
        if (shouldPop == true && context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: AppColors.textPrimary,
            ),
            onPressed: () async {
              final shouldPop = await showDialog<bool>(
                context: context,
                builder:
                    (ctx) => AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusCard,
                        ),
                      ),
                      title: const Text('Discard Changes?'),
                      content: const Text(
                        'Are you sure you want to go back? Unsaved changes will be lost.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          child: const Text('Keep Editing'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          child: const Text(
                            'Discard',
                            style: TextStyle(color: AppColors.error),
                          ),
                        ),
                      ],
                    ),
              );
              if (shouldPop == true && context.mounted) context.pop();
            },
          ),
          title: Text('Edit Profile', style: AppTextStyles.titleLarge),
          centerTitle: true,
        ),
        bottomNavigationBar:
            provider.isLoading
                ? null
                : SafeArea(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacing20,
                      vertical: AppDimensions.spacing16,
                    ),
                    decoration: BoxDecoration(
                      // color: AppColors.surface,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 8,
                          offset: const Offset(0, -2),
                        ),
                      ],
                    ),
                    child: AppButton(
                      label: 'Save Changes',
                      isLoading: provider.isUpdating,
                      onPressed:
                          provider.isUpdating
                              ? null
                              : () => _saveProfile(provider),
                    ),
                  ),
                ),
        body: _buildBody(provider),
      ),
    );
  }

  Widget _buildBody(ProfileProvider provider) {
    if (provider.isLoading) {
      return const AppFullScreenLoader(message: 'Loading profile...');
    }

    if (provider.error != null && provider.profile == null) {
      return AppErrorState(
        message: provider.error!,
        onRetry: () => provider.fetchProfile(),
      );
    }

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(
          left: AppDimensions.spacing20,
          right: AppDimensions.spacing20,
          bottom: AppDimensions.spacing40,
        ),
        child: Column(
          children: [
            const SizedBox(height: AppDimensions.spacing24),
            _buildPhotoSection(provider),
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              provider.profile?.fullName ?? '',
              style: AppTextStyles.titleMedium,
              textAlign: TextAlign.center,
            ),
            if (provider.profile?.mobile != null) ...[
              const SizedBox(height: AppDimensions.spacing4),
              Text(
                provider.fullPhone,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: AppDimensions.spacing24),
            _buildVerificationBadges(provider),
            const SizedBox(height: AppDimensions.spacing24),
            _buildSectionCard(
              title: 'Personal Details',
              child: Column(
                children: [
                  _buildTextField(
                    label: 'First Name',
                    controller: provider.firstNameController,
                    icon: Icons.person_outline,
                    textCapitalization: TextCapitalization.words,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty)
                        return 'First name is required';
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  _buildTextField(
                    label: 'Last Name',
                    controller: provider.lastNameController,
                    icon: Icons.person_outline,
                    textCapitalization: TextCapitalization.words,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacing16),
            _buildSectionCard(
              title: 'Contact Information',
              child: Column(
                children: [
                  _buildTextField(
                    label: 'Phone Number',
                    controller: TextEditingController(text: provider.fullPhone),
                    icon: Icons.phone_outlined,
                    readOnly: true,
                    keyboardType: TextInputType.phone,
                    suffixIcon: Icon(
                      Icons.lock_outline,
                      size: 18,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing16),
                  _buildTextField(
                    label: 'Email Address',
                    controller: provider.emailController,
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) {
                      if (v != null &&
                          v.isNotEmpty &&
                          !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacing16),
            _buildSectionCard(
              title: 'Additional Information',
              child: Column(
                children: [
                  _buildGenderDropdown(provider),
                  const SizedBox(height: AppDimensions.spacing16),
                  _buildDateField(provider),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacing24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spacing20),
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
          Text(title, style: AppTextStyles.titleSmall),
          const SizedBox(height: AppDimensions.spacing16),
          child,
        ],
      ),
    );
  }

  Widget _buildPhotoSection(ProfileProvider provider) {
    final hasLocalImage = provider.profileImageFile != null;

    final hasNetworkImage =
        provider.profile?.profileImage?.isNotEmpty == true && !hasLocalImage;

    return Center(
      child: GestureDetector(
        onTap: () => _showPhotoOptions(provider),
        child: Stack(
          children: [
            if (hasLocalImage)
              CircleAvatar(
                radius: 56,
                backgroundColor: AppColors.primaryLight,
                backgroundImage: FileImage(provider.profileImageFile!),
              )
            else if (hasNetworkImage)
              CircleAvatar(
                radius: 56,
                backgroundColor: AppColors.primaryLight,
                backgroundImage: CachedNetworkImageProvider(
                  "${APIURL.IMAGE_URL}${provider.profile!.profileImage}",
                ),
              )
            else
              CircleAvatar(
                radius: 56,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  provider.profile?.nameInitial ?? '?',
                  style: AppTextStyles.displayMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt,
                  size: 20,
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerificationBadges(ProfileProvider provider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildVerifiedChip(
          label: 'Mobile Verified',
          isVerified: provider.profile?.isMobileVerified == true,
          icon: Icons.phone_outlined,
        ),
        const SizedBox(width: AppDimensions.spacing12),
        _buildVerifiedChip(
          label: 'Email Verified',
          isVerified: provider.profile?.isEmailVerified == true,
          icon: Icons.email_outlined,
        ),
      ],
    );
  }

  Widget _buildVerifiedChip({
    required String label,
    required bool isVerified,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spacing12,
        vertical: AppDimensions.spacing8,
      ),
      decoration: BoxDecoration(
        color:
            isVerified
                ? AppColors.success.withValues(alpha: 0.1)
                : AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        border: Border.all(
          color:
              isVerified
                  ? AppColors.success.withValues(alpha: 0.3)
                  : AppColors.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isVerified ? Icons.check_circle_outline : Icons.info_outline,
            size: 16,
            color: isVerified ? AppColors.success : AppColors.warning,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.labelMedium.copyWith(
              color: isVerified ? AppColors.success : AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool readOnly = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextCapitalization textCapitalization = TextCapitalization.none,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      textCapitalization: textCapitalization,
      style: AppTextStyles.bodyMedium.copyWith(
        color: readOnly ? AppColors.textTertiary : AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textTertiary,
        ),
        prefixIcon: Icon(icon, color: AppColors.primary),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: readOnly ? AppColors.background : AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing16,
        ),
      ),
    );
  }

  Widget _buildGenderDropdown(ProfileProvider provider) {
    return DropdownButtonFormField<String>(
      value: provider.displayGender,
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(16),
      items:
          ['Male', 'Female', 'Other'].map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(e, style: TextStyle(color: Colors.black)),
            );
          }).toList(),
      onChanged: (v) {
        if (v != null) provider.setGender(v);
      },
      style: AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        labelText: 'Gender',
        labelStyle: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textTertiary,
        ),
        prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing16,
        ),
      ),
    );
  }

  Widget _buildDateField(ProfileProvider provider) {
    return GestureDetector(
      onTap: () => _pickDate(provider),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing16,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
        ),
        child: Row(
          children: [
            const Icon(Icons.calendar_month_outlined, color: AppColors.primary),
            const SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date of Birth',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    provider.displayDob,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color:
                          provider.dob.isEmpty
                              ? AppColors.textTertiary
                              : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
