import 'dart:async';
import 'package:flutter/material.dart';
import 'package:user_servicehub/core/network_services/service_locator.dart';
import 'package:user_servicehub/core/utils/shared_pref_utils.dart';
import 'package:user_servicehub/data/logic/repo/auth_repo.dart';
import 'package:user_servicehub/data/models/login_response.dart';

class AuthProvider with ChangeNotifier {
  final _authRepo = getIt<AuthRepo>();

  bool _isSendingOtp = false;
  bool _isVerifyingOtp = false;
  LoginResponse? _loginResponse;
  String? _error;
  String? _lastOtp;

  bool _showOtp = false;
  String _phone = '';
  int _remainingSeconds = 60;
  Timer? _timer;
  bool _canResend = false;
  final List<String> _otpDigits = List.generate(6, (_) => '');

  bool get isSendingOtp => _isSendingOtp;
  bool get isVerifyingOtp => _isVerifyingOtp;
  LoginResponse? get loginResponse => _loginResponse;
  LoginUser? get user => _loginResponse?.data?.user;
  String? get error => _error;
  String? get lastSentOtp => _lastOtp;

  bool get showOtp => _showOtp;
  String get phone => _phone;
  int get remainingSeconds => _remainingSeconds;
  bool get canResend => _canResend;
  List<String> get otpDigits => List.unmodifiable(_otpDigits);

  bool get isLoggedIn => _loginResponse?.data?.accessToken != null;

  String get maskedPhone {
    if (_phone.length < 10) return _phone;
    return '+91 XXXXXX${_phone.substring(_phone.length - 2)}';
  }

  Future<bool> sendOtp(String mobile) async {
    _isSendingOtp = true;
    _error = null;
    notifyListeners();

    final result = await _authRepo.loginWithPhone(mobile);
    final either = result;

    if (either.isLeft())
     {
      _isSendingOtp = false;
      _error = either.getLeft().toNullable()?.message ?? 'Failed to send OTP';
      notifyListeners();
      return false;
    }

    _isSendingOtp = false;
    _loginResponse = either.getRight().toNullable();
    _lastOtp = _loginResponse?.data?.otp;
    notifyListeners();
    return true;
  }

  Future<bool> verifyOtp(String mobile, String otp) async {
    _isVerifyingOtp = true;
    _error = null;
    notifyListeners();

    final result = await _authRepo.verifyOTP(mobile, otp);
    final either = result;

    if (either.isLeft()) {
      _isVerifyingOtp = false;
      _error =
          either.getLeft().toNullable()?.message ?? 'OTP verification failed';
      notifyListeners();
      return false;
    }

    _isVerifyingOtp = false;
    _loginResponse = either.getRight().toNullable();
    _lastOtp = null;
    await _persistLogin(_loginResponse);
    notifyListeners();
    return true;
  }

  Future<bool> refreshToken() async {
    final refresh = await SharedPrefUtils.getRefreshToken();
    if (refresh == null || refresh.isEmpty) return false;

    final result = await _authRepo.refreshToken(refresh);
    final either = result;

    if (either.isLeft()) {
      _error = either.getLeft().toNullable()?.message ?? 'Token refresh failed';
      notifyListeners();
      return false;
    }

    _loginResponse = either.getRight().toNullable();
    await _persistLogin(_loginResponse);
    notifyListeners();
    return true;
  }

  Future<void> _persistLogin(LoginResponse? response) async {
    final data = response?.data;
    if (data == null) return;

    final token = data.accessToken;
    if (token != null && token.isNotEmpty) {
      await SharedPrefUtils.setToken(authToken: token);
    }

    final refreshToken = data.refreshToken;
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await SharedPrefUtils.setRefreshToken(refresh_token: refreshToken);
    }

    final user = data.user;
    if (user != null) {
      await SharedPrefUtils.setUserId(id: user.id ?? '');
      await SharedPrefUtils.saveUser(user: user);
    }
  }

  void startTimer() {
    _canResend = false;
    _remainingSeconds = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds == 0) {
        _canResend = true;
        notifyListeners();
        timer.cancel();
      } else {
        _remainingSeconds--;
        notifyListeners();
      }
    });
  }

  void cancelTimer() {
    _timer?.cancel();
  }

  void setOtpDigit(int index, String value) {
    if (index >= 0 && index < 6) {
      _otpDigits[index] = value;
      notifyListeners();
    }
  }

  void clearOtp() {
    for (int i = 0; i < 6; i++) {
      _otpDigits[i] = '';
    }
    notifyListeners();
  }

  void fillOtp(String otp) {
    final digits = otp.replaceAll(RegExp(r'\D'), '');
    for (int i = 0; i < 6 && i < digits.length; i++) {
      _otpDigits[i] = digits[i];
    }
    notifyListeners();
  }

  String get joinedOtp => _otpDigits.join();

  Future<bool> sendOtpForLogin(String mobile) async {
    final success = await sendOtp(mobile);
    if (success) {
      _phone = mobile;
      _showOtp = true;
      startTimer();
      final otp = _lastOtp;
      if (otp != null && otp.isNotEmpty) {
        fillOtp(otp);
      }
    }
    return success;
  }

  void goBackToPhone() {
    _showOtp = false;
    clearOtp();
    cancelTimer();
    notifyListeners();
  }

  Future<bool> resendOtp() async {
    if (!_canResend) return false;
    clearOtp();
    final success = await sendOtp(_phone);
    if (success) {
      startTimer();
      final otp = _lastOtp;
      if (otp != null && otp.isNotEmpty) {
        fillOtp(otp);
      }
    }
    return success;
  }

  void resetLoginState() {
    _showOtp = false;
    _phone = '';
    _remainingSeconds = 60;
    _canResend = false;
    _error = null;
    clearOtp();
    cancelTimer();
    notifyListeners();
  }
}
