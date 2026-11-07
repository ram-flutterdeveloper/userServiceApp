import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/constants/app_routes.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';
import 'package:user_servicehub/data/logic/provider/auth_provider.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (_) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _remainingSeconds = 60;
  Timer? _timer;
  bool _canResend = false;
  bool _isVerifying = false;
  bool _popupShown = false;
  String _phone = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final extra = GoRouterState.of(context).extra;
    if (extra is String && _phone.isEmpty) {
      _phone = extra;
      _showOtpDialogIfAvailable();
    }
  }

  void _startTimer() {
    _canResend = false;
    _remainingSeconds = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        setState(() => _canResend = true);
        timer.cancel();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  void _showOtpDialogIfAvailable() {
    if (_popupShown) return;
    final otp = context.read<AuthProvider>().lastSentOtp;
    if (otp == null || otp.isEmpty) return;
    _popupShown = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _showOtpDialog(otp);
    });
  }

  void _showOtpDialog(String otp) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder:
          (dialogContext) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
            ),
            title: Text(
              'OTP Sent',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Your OTP is',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing12),
                Text(
                  otp,
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.primary,
                    letterSpacing: 8,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppDimensions.spacing12),
                Text(
                  'Use this OTP to verify your number.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  _fillOtp(otp);
                },
                child: Text(
                  'Use this OTP',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
    );
  }

  void _fillOtp(String otp) {
    final digits = otp.replaceAll(RegExp(r'\D'), '');
    for (int i = 0; i < 6 && i < digits.length; i++) {
      _controllers[i].text = digits[i];
    }
    _focusNodes[5].requestFocus();
    setState(() {});
  }

  Future<void> _onResend() async {
    if (!_canResend) return;
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.sendOtp(_phone);
    if (!mounted) return;
    if (success) {
      _startTimer();
      final newOtp = authProvider.lastSentOtp;
      if (newOtp != null && newOtp.isNotEmpty) {
        _showOtpDialog(newOtp);
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

  void _onOtpChange(int index, String value) {
    if (value.length > 1) {
      _handlePaste(value);
      return;
    }
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
    if (index == 5 && value.isNotEmpty) {
      _focusNodes[index].unfocus();
      _verifyOtp();
    }
  }

  void _handlePaste(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    for (int i = 0; i < 6 && i < digits.length; i++) {
      _controllers[i].text = digits[i];
      if (i < 5) {
        _focusNodes[i + 1].requestFocus();
      }
    }
    if (digits.length == 6) {
      _focusNodes[5].unfocus();
      _verifyOtp();
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _controllers.map((c) => c.text).join();
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
      context.pushReplacement(AppRoutes.loginSuccess);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.error ?? 'OTP verification failed'),
        ),
      );
    }
  }

  String _getMaskedPhone() {
    if (_phone.length < 10) return _phone;
    return '+91 XXXXXX${_phone.substring(_phone.length - 2)}';
  }

  Future<void> _onSkipLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('guest_mode', true);
    if (!mounted) return;
    context.pushReplacement(AppRoutes.home);
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _focusNodes) {
      n.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.background,
          ),
          child: IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 20,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacing24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppDimensions.spacing8),
            Text(
              'Verify Phone Number',
              style: AppTextStyles.headlineMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing12),
            Text(
              'Enter the OTP sent to ${_getMaskedPhone()}',
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: AppDimensions.spacing48),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                6,
                (index) => TweenAnimationBuilder<double>(
                  tween: Tween(begin: 1.0, end: 1.0),
                  duration: const Duration(milliseconds: 200),
                  builder: (context, value, child) {
                    return Container(
                      width: 52,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMedium,
                        ),
                        color:
                            _controllers[index].text.isNotEmpty
                                ? AppColors.primaryLight
                                : AppColors.background,
                        border: Border.all(
                          color:
                              _focusNodes[index].hasFocus
                                  ? AppColors.primary
                                  : AppColors.border,
                          width: _focusNodes[index].hasFocus ? 1.5 : 1.0,
                        ),
                      ),
                      child: TextField(
                        controller: _controllers[index],
                        focusNode: _focusNodes[index],
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
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
                  },
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacing32),
            Center(
              child: Column(
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
                          _canResend
                              ? AppColors.primary
                              : AppColors.textTertiary,
                    ),
                    child: Text(
                      'Resend Code',
                      style: AppTextStyles.labelLarge.copyWith(
                        color:
                            _canResend
                                ? AppColors.primary
                                : AppColors.textTertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppDimensions.spacing24),
            SizedBox(
              width: double.infinity,
              height: AppDimensions.buttonHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusButton,
                  ),
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
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusButton,
                    ),
                    onTap: _isVerifying ? null : _verifyOtp,
                    child: Center(
                      child:
                          _isVerifying
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
            ),
            const SizedBox(height: AppDimensions.spacing20),
            Center(
              child: TextButton(
                onPressed: () => context.pop(),
                child: Text(
                  'Change phone number?',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: _onSkipLogin,
                child: Text(
                  'Skip for now',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppDimensions.spacing8),
          ],
        ),
      ),
    );
  }
}
