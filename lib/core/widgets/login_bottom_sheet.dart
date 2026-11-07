import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';
import 'package:user_servicehub/core/utils/validators.dart';
import 'package:user_servicehub/core/widgets/app_button.dart';
import 'package:user_servicehub/data/logic/provider/auth_provider.dart';

class LoginBottomSheet extends StatefulWidget {
  const LoginBottomSheet({super.key});

  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusBottomSheet),
          topRight: Radius.circular(AppDimensions.radiusBottomSheet),
        ),
      ),
      builder: (_) => const LoginBottomSheet(),
    );
  }

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _phoneFormKey = GlobalKey<FormState>();
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _otpFocusNodes = List.generate(6, (_) => FocusNode());

  bool _showOtp = false;
  String _phone = '';
  int _remainingSeconds = 60;
  Timer? _timer;
  bool _canResend = false;
  bool _isVerifying = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _otpFocusNodes[0].requestFocus();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final n in _otpFocusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _canResend = false;
    _remainingSeconds = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_remainingSeconds == 0) {
        setState(() => _canResend = true);
        timer.cancel();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  String _getMaskedPhone() {
    if (_phone.length < 10) return _phone;
    return '+91 XXXXXX${_phone.substring(_phone.length - 2)}';
  }

  Future<void> _onSendOtp() async {
    if (!(_phoneFormKey.currentState?.validate() ?? false)) return;
    final phone = _phoneController.text.trim();
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.sendOtp(phone);
    if (!mounted) return;
    if (success) {
      setState(() {
        _phone = phone;
        _showOtp = true;
      });
      _startTimer();
      WidgetsBinding.instance.addPostFrameCallback((_) 
      {
        if (mounted) _otpFocusNodes[0].requestFocus();
      });
      final otp = authProvider.lastSentOtp;
      if (otp != null && otp.isNotEmpty) 
      {
        _fillOtp(otp);
      }
    } else 
    {
      if (mounted) 
      {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authProvider.error ?? 'Failed to send OTP')),
        );
      }
    }
  }

  void _fillOtp(String otp) {
    final digits = otp.replaceAll(RegExp(r'\D'), '');
    for (int i = 0; i < 6 && i < digits.length; i++) {
      _otpControllers[i].text = digits[i];
    }
    if (digits.length == 6 && mounted) {
      _otpFocusNodes[5].unfocus();
      _verifyOtp();
    } else if (mounted) {
      _otpFocusNodes[digits.length.clamp(0, 5)].requestFocus();
    }
    setState(() {});
  }

  Future<void> _verifyOtp() async {
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter complete OTP')),
      );
      return;
    }
    setState(() => _isVerifying = true);
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.verifyOtp(_phone, otp);
    if (!mounted) return;
    setState(() => _isVerifying = false);
    if (success) {
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'OTP verification failed'),
        ),
      );
    }
  }

  void _onOtpChange(int index, String value) {
    if (value.length > 1) {
      _handlePaste(value);
      return;
    }
    if (value.isNotEmpty && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    }
    if (index == 5 && value.isNotEmpty) {
      _otpFocusNodes[index].unfocus();
      _verifyOtp();
    }
  }

  void _handlePaste(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    for (int i = 0; i < 6 && i < digits.length; i++) {
      _otpControllers[i].text = digits[i];
      if (i < 5) {
        _otpFocusNodes[i + 1].requestFocus();
      }
    }
    if (digits.length == 6) {
      _otpFocusNodes[5].unfocus();
      _verifyOtp();
    }
  }

  Future<void> _onResend() async {
    if (!_canResend) return;
    for (final c in _otpControllers) {
      c.clear();
    }
    _otpFocusNodes[0].requestFocus();
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.sendOtp(_phone);
    if (!mounted) return;
    if (success) {
      _startTimer();
      final otp = authProvider.lastSentOtp;
      if (otp != null && otp.isNotEmpty) {
        _fillOtp(otp);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP resent successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(authProvider.error ?? 'Failed to resend OTP')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDimensions.spacing24,
            AppDimensions.spacing8,
            AppDimensions.spacing24,
            AppDimensions.spacing24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDragHandle(),
                const SizedBox(height: AppDimensions.spacing16),
                if (_showOtp) ...[
                  _buildOtpView(authProvider),
                ] else ...[
                  _buildPhoneView(authProvider),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildPhoneView(AuthProvider authProvider) {
    return Form(
      key: _phoneFormKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            ),
            child: const Icon(
              Icons.phone_rounded,
              size: 32,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing20),
          Text(
            'Login to continue',
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing8),
          Text(
            'Enter your phone number to get started',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppDimensions.spacing24),
          _buildPhoneInputField(),
          const SizedBox(height: AppDimensions.spacing20),
          AppButton(
            label: 'Send OTP',
            onPressed: authProvider.isSendingOtp ? null : _onSendOtp,
            isLoading: authProvider.isSendingOtp,
            fullWidth: true,
          ),
          const SizedBox(height: AppDimensions.spacing20),
          Text(
            'By continuing you agree to our Terms & Conditions and Privacy Policy',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textTertiary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneInputField() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
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
          // Container(
          //   padding: const EdgeInsets.symmetric(
          //     horizontal: AppDimensions.spacing16,
          //     vertical: AppDimensions.spacing16,
          //   ),
          //   decoration: const BoxDecoration(
          //     color: AppColors.background,
          //     borderRadius: BorderRadius.only(
          //       topLeft: Radius.circular(AppDimensions.radiusCard),
          //       bottomLeft: Radius.circular(AppDimensions.radiusCard),
          //     ),
          //   ),
          //   // child: Row(
          //   //   children: [
          //   //     Text(
          //   //       '+91',
          //   //       style: AppTextStyles.titleMedium.copyWith(
          //   //         color: AppColors.textPrimary,
          //   //       ),
          //   //     ),
          //   //     const SizedBox(width: 4),
          //   //     const Icon(
          //   //       Icons.keyboard_arrow_down,
          //   //       size: 20,
          //   //       color: AppColors.textSecondary,
          //   //     ),
          //   //   ],
          //   // ),
          // ),
          Expanded(
            child: TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              validator: Validators.validatePhone,
              decoration: const InputDecoration(
                hintText: '+91 Phone number',
                counterText: '',
                filled: true,
                fillColor: AppColors.background,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(AppDimensions.radiusCard),
                    bottomRight: Radius.circular(AppDimensions.radiusCard),
                  ),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(AppDimensions.radiusCard),
                    bottomRight: Radius.circular(AppDimensions.radiusCard),
                  ),
                  borderSide: BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
              style: AppTextStyles.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpView(AuthProvider authProvider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            onPressed: () {
              _timer?.cancel();
              setState(() {
                _showOtp = false;
                for (final c in _otpControllers) {
                  c.clear();
                }
              });
            },
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Text(
          'Verify Phone Number',
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing8),
        Text(
          'Enter the OTP sent to ${_getMaskedPhone()}',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing32),
        _buildOtpFields(),
        const SizedBox(height: AppDimensions.spacing24),
        _buildResendSection(),
        const SizedBox(height: AppDimensions.spacing24),
        _buildVerifyButton(authProvider),
      ],
    );
  }

  Widget _buildOtpFields() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(6, (index) {
        return Container(
          width: 48,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            color:
                _otpControllers[index].text.isNotEmpty
                    ? AppColors.primaryLight
                    : AppColors.background,
            border: Border.all(
              color:
                  _otpFocusNodes[index].hasFocus
                      ? AppColors.primary
                      : AppColors.border,
              width: _otpFocusNodes[index].hasFocus ? 1.5 : 1.0,
            ),
          ),
          child: TextField(
            controller: _otpControllers[index],
            focusNode: _otpFocusNodes[index],
            textAlign: TextAlign.center,
            maxLength: 1,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
            ),
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.textPrimary,
            ),
            onChanged: (value) => _onOtpChange(index, value),
          ),
        );
      }),
    );
  }

  Widget _buildResendSection() {
    return Column(
      children: [
        Text(
          _canResend
              ? "Didn't receive the code?"
              : 'Resend OTP in $_remainingSeconds s',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppDimensions.spacing4),
        TextButton(
          onPressed: _canResend ? _onResend : null,
          style: TextButton.styleFrom(
            foregroundColor:
                _canResend ? AppColors.primary : AppColors.textTertiary,
          ),
          child: Text(
            'Resend Code',
            style: AppTextStyles.labelLarge.copyWith(
              color: _canResend ? AppColors.primary : AppColors.textTertiary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerifyButton(AuthProvider authProvider) {
    final isLoading = _isVerifying || authProvider.isVerifyingOtp;
    return SizedBox(
      width: double.infinity,
      height: AppDimensions.buttonHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryDark],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppDimensions.radiusButton),
            onTap: isLoading ? null : _verifyOtp,
            child: Center(
              child:
                  isLoading
                      ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                      : Text(
                        'Verify',
                        style: AppTextStyles.buttonLarge.copyWith(
                          color: AppColors.white,
                        ),
                      ),
            ),
          ),
        ),
      ),
    );
  }
}
