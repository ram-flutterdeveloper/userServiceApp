import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';
import 'package:user_servicehub/data/models/user_model.dart';

class EditProfilePage extends StatefulWidget {
  final UserModel user;

  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _emergencyController;
  late TextEditingController _addressController;
  late String _gender;
  late String _dateOfBirth;
  late String _language;
  bool _isLoading = false;
  bool _hasChanges = false;

  final List<String> _genderOptions = ['Male', 'Female', 'Other'];
  final List<String> _languageOptions = [
    'Hindi',
    'English',
    'Punjabi',
    'Tamil',
    'Telugu',
    'Bengali',
    'Marathi',
    'Gujarati',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phone);
    _emailController = TextEditingController(text: widget.user.email);
    _emergencyController = TextEditingController(
      text: widget.user.emergencyContact ?? '',
    );
    _addressController = TextEditingController(text: widget.user.address);
    _gender = widget.user.gender;
    _dateOfBirth = widget.user.dateOfBirth;
    _language = widget.user.language;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _emergencyController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _markChanged() {
    if (!_hasChanges) setState(() => _hasChanges = true);
  }

  bool _hasUnsavedChanges() {
    return _nameController.text != widget.user.name ||
        _emailController.text != widget.user.email ||
        _emergencyController.text != (widget.user.emergencyContact ?? '') ||
        _addressController.text != widget.user.address ||
        _gender != widget.user.gender ||
        _dateOfBirth != widget.user.dateOfBirth ||
        _language != widget.user.language;
  }

  Future<void> _pickDate() async {
    final parts = _dateOfBirth.split('-');
    int year = 1992, month = 1, day = 1;
    if (parts.length == 3) {
      year = int.tryParse(parts[0]) ?? 1992;
      month = int.tryParse(parts[1]) ?? 1;
      day = int.tryParse(parts[2]) ?? 1;
    }
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(year, month, day),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateOfBirth =
            '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
        _markChanged();
      });
    }
  }

  void _showPhotoOptions() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusBottomSheet),
        ),
      ),
      builder: (ctx) => SafeArea(
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
              const SizedBox(height: AppDimensions.spacing20),
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.of(ctx).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.of(ctx).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_outline, color: AppColors.error),
                title: const Text(
                  'Remove Photo',
                  style: TextStyle(color: AppColors.error),
                ),
                onTap: () {
                  Navigator.of(ctx).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final updated = widget.user.copyWith(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      gender: _gender,
      dateOfBirth: _dateOfBirth,
      language: _language,
      emergencyContact: _emergencyController.text.trim().isEmpty
          ? null
          : _emergencyController.text.trim(),
      address: _addressController.text.trim(),
    );

    Future.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.pop(updated);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        if (!_hasUnsavedChanges()) {
          if (context.mounted) context.pop();
          return;
        }
        final discard = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            ),
            title: const Text('Discard Changes?'),
            content: const Text(
              'You have unsaved changes. Are you sure you want to discard them?',
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
        if (discard == true && context.mounted) {
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
            icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            onPressed: () async {
              if (!_hasUnsavedChanges()) {
                if (context.mounted) context.pop();
                return;
              }
              final discard = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Discard Changes?'),
                  content: const Text(
                    'You have unsaved changes. Are you sure?',
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
              if (discard == true && context.mounted) context.pop();
            },
          ),
          title: Text(
            'Edit Profile',
            style: AppTextStyles.titleLarge,
          ),
          centerTitle: true,
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppDimensions.spacing20),
            child: Column(
              children: [
                _buildPhotoSection(),
                const SizedBox(height: AppDimensions.spacing24),
                _buildTextField(
                  label: 'Full Name',
                  controller: _nameController,
                  icon: Icons.person_outline,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return 'Name is required';
                    return null;
                  },
                  onChanged: (_) => _markChanged(),
                ),
                const SizedBox(height: AppDimensions.spacing16),
                _buildTextField(
                  label: 'Phone Number',
                  controller: _phoneController,
                  icon: Icons.phone_outlined,
                  readOnly: true,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: AppDimensions.spacing16),
                _buildTextField(
                  label: 'Email',
                  controller: _emailController,
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) {
                    if (v != null &&
                        v.isNotEmpty &&
                        !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v)) {
                      return 'Invalid email address';
                    }
                    return null;
                  },
                  onChanged: (_) => _markChanged(),
                ),
                const SizedBox(height: AppDimensions.spacing16),
                _buildDropdownField(
                  label: 'Gender',
                  icon: Icons.person_outline,
                  value: _gender,
                  items: _genderOptions,
                  onChanged: (v) {
                    setState(() => _gender = v!);
                    _markChanged();
                  },
                ),
                const SizedBox(height: AppDimensions.spacing16),
                _buildDateField(),
                const SizedBox(height: AppDimensions.spacing16),
                _buildDropdownField(
                  label: 'Language',
                  icon: Icons.language_outlined,
                  value: _language,
                  items: _languageOptions,
                  onChanged: (v) {
                    setState(() => _language = v!);
                    _markChanged();
                  },
                ),
                const SizedBox(height: AppDimensions.spacing16),
                _buildTextField(
                  label: 'Emergency Contact',
                  controller: _emergencyController,
                  icon: Icons.emergency_outlined,
                  keyboardType: TextInputType.phone,
                  onChanged: (_) => _markChanged(),
                ),
                const SizedBox(height: AppDimensions.spacing16),
                _buildTextField(
                  label: 'Address',
                  controller: _addressController,
                  icon: Icons.location_on_outlined,
                  maxLines: 3,
                  onChanged: (_) => _markChanged(),
                ),
                const SizedBox(height: AppDimensions.spacing32),
                SizedBox(
                  width: double.infinity,
                  height: AppDimensions.buttonHeight,
                  child: FilledButton(
                    onPressed: _isLoading ? null : _saveProfile,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusButton,
                        ),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.white,
                            ),
                          )
                        : Text(
                            'Save Changes',
                            style: AppTextStyles.buttonLarge.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoSection() {
    final initial = _nameController.text.isNotEmpty
        ? _nameController.text[0].toUpperCase()
        : '?';
    return Center(
      child: GestureDetector(
        onTap: _showPhotoOptions,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.primaryLight,
              child: Text(
                initial,
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

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    bool readOnly = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLines,
      style: AppTextStyles.bodyMedium.copyWith(
        color: readOnly ? AppColors.textTertiary : AppColors.textPrimary,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textTertiary,
        ),
        prefixIcon: Icon(icon, color: AppColors.primary),
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing16,
          vertical: AppDimensions.spacing16,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((e) {
        return DropdownMenuItem(value: e, child: Text(e));
      }).toList(),
      onChanged: onChanged,
      style: AppTextStyles.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textTertiary,
        ),
        prefixIcon: Icon(icon, color: AppColors.primary),
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

  Widget _buildDateField() {
    return TextFormField(
      readOnly: true,
      controller: TextEditingController(text: _dateOfBirth),
      style: AppTextStyles.bodyMedium,
      onTap: _pickDate,
      decoration: InputDecoration(
        labelText: 'Date of Birth',
        labelStyle: AppTextStyles.labelMedium.copyWith(
          color: AppColors.textTertiary,
        ),
        prefixIcon: const Icon(
          Icons.calendar_month_outlined,
          color: AppColors.primary,
        ),
        suffixIcon: const Icon(
          Icons.arrow_drop_down,
          color: AppColors.textTertiary,
        ),
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
}
