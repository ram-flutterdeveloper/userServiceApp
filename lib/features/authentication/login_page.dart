import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_strings.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/constants/app_routes.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';
import 'package:user_servicehub/core/widgets/app_button.dart';
import 'package:user_servicehub/data/logic/provider/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final phone = _phoneController.text.trim();
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.sendOtp(phone);
    if (!mounted) return;
    if (success) {
      context.push(AppRoutes.otp, extra: phone);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.error ?? 'Failed to send OTP')),
      );
    }
  }

  void _onGoogleLogin() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Google login coming soon')));
  }

  void _onAppleLogin() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Apple login coming soon')));
  }

  Future<void> _onContinueWithoutLogin() async {
    final proceed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            ),
            title: Text(
              'Guest Mode',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            content: Text(
              AppStrings.guestModeMessage,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(
                  'Cancel',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(
                  'Continue as Guest',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
    );
    if (proceed != true) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('guest_mode', true);
    if (!mounted) return;
    context.pushReplacement(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.spacing24,
                    AppDimensions.spacing48,
                    AppDimensions.spacing24,
                    AppDimensions.spacing40,
                  ),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary,
                        AppColors.primaryDark,
                        Color(0xFF1E3A8A),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(AppDimensions.radiusBanner),
                      bottomRight: Radius.circular(AppDimensions.radiusBanner),
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white.withValues(alpha: 0.15),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.white.withValues(alpha: 0.1),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.build_circle,
                          size: 48,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacing24),
                      Text(
                        'Welcome to ServiceHub',
                        style: AppTextStyles.headlineMedium.copyWith(
                          color: AppColors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppDimensions.spacing8),
                      Text(
                        AppStrings.appTagline,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.white.withValues(alpha: 0.85),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppDimensions.spacing24,
                    AppDimensions.spacing32,
                    AppDimensions.spacing24,
                    AppDimensions.spacing24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter your phone number to continue',
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacing16),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusCard,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.spacing16,
                                vertical: AppDimensions.spacing16,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(
                                    AppDimensions.radiusCard,
                                  ),
                                  bottomLeft: Radius.circular(
                                    AppDimensions.radiusCard,
                                  ),
                                ),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    '+91',
                                    style: AppTextStyles.titleMedium.copyWith(
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 20,
                                    color: AppColors.textSecondary,
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Phone number is required';
                                  }
                                  final cleaned = value.trim().replaceAll(
                                    RegExp(r'[\s\-()]'),
                                    '',
                                  );
                                  if (cleaned.length != 10) {
                                    return 'Enter a valid 10-digit phone number';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  hintText: 'Phone number',
                                  counterText: '',
                                  filled: true,
                                  fillColor: AppColors.background,
                                  border: OutlineInputBorder(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(
                                        AppDimensions.radiusCard,
                                      ),
                                      bottomRight: Radius.circular(
                                        AppDimensions.radiusCard,
                                      ),
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(
                                        AppDimensions.radiusCard,
                                      ),
                                      bottomRight: Radius.circular(
                                        AppDimensions.radiusCard,
                                      ),
                                    ),
                                    borderSide: const BorderSide(
                                      color: AppColors.primary,
                                      width: 1.5,
                                    ),
                                  ),
                                ),
                                style: AppTextStyles.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacing24),
                      AppButton(
                        label: AppStrings.continueText,
                        onPressed: _onContinue,
                        fullWidth: true,
                        isLoading: context.watch<AuthProvider>().isSendingOtp,
                      ),
                      const SizedBox(height: AppDimensions.spacing24),
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              color: AppColors.border,
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.spacing16,
                            ),
                            child: Text(
                              'or',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              color: AppColors.border,
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppDimensions.spacing24),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: _onGoogleLogin,
                          icon: const Icon(Icons.g_mobiledata, size: 28),
                          label: Text(
                            'Continue with Google',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            backgroundColor: AppColors.white,
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusCard,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacing12),
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: OutlinedButton.icon(
                          onPressed: _onAppleLogin,
                          icon: const Icon(Icons.apple, size: 24),
                          label: Text(
                            'Continue with Apple',
                            style: AppTextStyles.labelLarge.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            backgroundColor: AppColors.white,
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusCard,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacing20),
                      TextButton(
                        onPressed: _onContinueWithoutLogin,
                        child: Text(
                          'Continue without Login',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacing32),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: AppTextStyles.bodySmall,
                          children: [
                            TextSpan(
                              text: 'By continuing you agree to our ',
                              style: TextStyle(color: AppColors.textTertiary),
                            ),
                            TextSpan(
                              text: 'Terms & Conditions',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: ' & ',
                              style: TextStyle(color: AppColors.textTertiary),
                            ),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppDimensions.spacing24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
