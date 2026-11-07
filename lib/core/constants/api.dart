class APIURL {
  static const IMAGE_URL = "http://localhost:5000";
  static const BASE_URL = "http://localhost:5000/api";
  static const String loginWithPhone = "$BASE_URL/v1/auth/send-otp";
  static const String verifyPhoneOTP = "$BASE_URL/v1/auth/verify-otp";
  static const String refreshToken = "$BASE_URL/v1/auth/refresh-token";
  static const String homeData = "$BASE_URL/v1/discovery/home";
  static String packagesByService(String serviceId) =>
      "$BASE_URL/v1/packages/services/$serviceId";
  static String packageDetails(String packageId) =>
      "$BASE_URL/v1/packages/$packageId/details";
  // Address module
  static const String cities = "$BASE_URL/v1/cities";
  static String areasByCity(String cityId) => "$BASE_URL/v1/areas/city/$cityId";
  static const String profileAddresses = "$BASE_URL/v1/profile/addresses";
  static String profileAddressById(String addressId) =>
      "$BASE_URL/v1/profile/addresses/$addressId";
  static const String timeSlot = "$BASE_URL/v1/time-slots";
  static const String packages = "$BASE_URL/v1/packages";
  static const String summary = "$BASE_URL/bookings/summary";
  static const String creatBookings = "$BASE_URL/v1/bookings";
  static String bookingById(String id) => "$BASE_URL/v1/bookings/$id";
  static String cancelBookingById(String id) => "$BASE_URL/v1/bookings/$id/cancel";
  // Reviews module
  static String reviewsByPackage(String packageId) =>
      "$BASE_URL/v1/reviews/package/$packageId";
  // Favourites module
  static const String favourites = "$BASE_URL/v1/favourites";
  static String favouriteByPackageId(String packageId) =>
      "$BASE_URL/v1/favourites/$packageId";
  // Profile module
  static const String profile = "$BASE_URL/v1/profile";
}
