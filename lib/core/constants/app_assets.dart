class AppAssets {
  AppAssets._();

  // Logo & Brand
  static const String logo = 'assets/images/logo.png';
  static const String logoSvg = 'assets/images/logo.svg';
  static const String logoWhite = 'assets/images/logo_white.png';

  // Onboarding
  static const String onboarding1 = 'assets/images/onboarding_1.png';
  static const String onboarding2 = 'assets/images/onboarding_2.png';
  static const String onboarding3 = 'assets/images/onboarding_3.png';
  static const String onboarding4 = 'assets/images/onboarding_4.png';

  // Illustrations
  static const String emptyState = 'assets/images/empty_state.png';
  static const String successAnimation = 'assets/images/success_animation.png';
  static const String loginIllustration = 'assets/images/login_illustration.png';
  static const String welcomeIllustration = 'assets/images/welcome_illustration.png';
  static const String bookingIllustration = 'assets/images/booking_illustration.png';
  static const String paymentIllustration = 'assets/images/payment_illustration.png';
  static const String notificationIllustration = 'assets/images/notification_illustration.png';

  // Placeholder
  static const String placeholder = 'assets/images/placeholder.png';
  static const String userPlaceholder = 'assets/images/user_placeholder.png';
  static const String servicePlaceholder = 'assets/images/service_placeholder.png';
  static const String categoryPlaceholder = 'assets/images/category_placeholder.png';
  static const String professionalPlaceholder = 'assets/images/professional_placeholder.png';

  // Icons
  static const String iconCall = 'assets/icons/call.png';
  static const String iconChat = 'assets/icons/chat.png';
  static const String iconShare = 'assets/icons/share.png';
  static const String iconHeart = 'assets/icons/heart.png';
  static const String iconStar = 'assets/icons/star.png';
  static const String iconLocation = 'assets/icons/location.png';
  static const String iconCalendar = 'assets/icons/calendar.png';
  static const String iconClock = 'assets/icons/clock.png';
  static const String iconWallet = 'assets/icons/wallet.png';
  static const String iconCoupon = 'assets/icons/coupon.png';
  static const String iconSecurity = 'assets/icons/security.png';
  static const String iconVerified = 'assets/icons/verified.png';

  // Lottie / Animations
  static const String loadingAnimation = 'assets/animations/loading.json';
  static const String successCheckAnimation = 'assets/animations/success_check.json';
  static const String errorAnimation = 'assets/animations/error.json';
  static const String emptyAnimation = 'assets/animations/empty.json';

  // Fonts
  static const String interFont = 'assets/fonts/Inter-VariableFont_opsz,wght.ttf';

  /// Returns a placeholder asset path based on the given [type].
  static String getPlaceholder(String type) {
    switch (type) {
      case 'user':
        return userPlaceholder;
      case 'service':
        return servicePlaceholder;
      case 'category':
        return categoryPlaceholder;
      case 'professional':
        return professionalPlaceholder;
      default:
        return placeholder;
    }
  }

  /// Returns the onboarding image for the given [index] (1-based).
  static String getOnboardingImage(int index) {
    switch (index) {
      case 1:
        return onboarding1;
      case 2:
        return onboarding2;
      case 3:
        return onboarding3;
      case 4:
        return onboarding4;
      default:
        return onboarding1;
    }
  }
}
