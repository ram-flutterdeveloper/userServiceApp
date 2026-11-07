class Validators {
  Validators._();

  /// Validates a 10-digit Indian phone number.
  /// Returns an error message string if invalid, or `null` if valid.
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final cleaned = value.trim().replaceAll(RegExp(r'[\s\-()]'), '');
    if (cleaned.length != 10) {
      return 'Phone number must be 10 digits';
    }
    if (!RegExp(r'^[6-9]\d{9}$').hasMatch(cleaned)) {
      return 'Enter a valid phone number';
    }
    return null;
  }

  /// Validates an email address.
  /// Returns an error message string if invalid, or `null` if valid.
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email address';
    }
    return null;
  }

  /// Validates a name (non-empty, at least 2 characters).
  /// Returns an error message string if invalid, or `null` if valid.
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s\-\.]+$').hasMatch(value.trim())) {
      return 'Enter a valid name';
    }
    return null;
  }

  /// Validates a 6-digit OTP.
  /// Returns an error message string if invalid, or `null` if valid.
  static String? validateOTP(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'OTP is required';
    }
    final cleaned = value.trim();
    if (cleaned.length != 6) {
      return 'OTP must be 6 digits';
    }
    if (!RegExp(r'^\d{6}$').hasMatch(cleaned)) {
      return 'OTP must contain only digits';
    }
    return null;
  }

  /// Validates that a field is not empty.
  /// Returns an error message string if invalid, or `null` if valid.
  static String? validateEmpty(String? value, [String fieldName = 'This field']) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}
