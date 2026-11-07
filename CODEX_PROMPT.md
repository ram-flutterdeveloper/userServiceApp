# 🏗️ CODEX MASTER PROMPT — ServiceHub Flutter App

Generate a complete, production-ready Flutter mobile application called **ServiceHub** — a multi-service marketplace (Urban Company style). Follow every instruction below strictly. Generate **all files** in full.

---

## 1. PROJECT OVERVIEW

**App Name:** ServiceHub  
**Platform:** Flutter Mobile (Stable)  
**Target:** iOS + Android  
**Screen Size:** 390 × 844 (iPhone 15 Pro), mobile-first, responsive, tablet-supportive  
**Dart:** 3.x  
**UI Framework:** Material Design 3  
**Theme:** Light mode (dark mode compatible architecture)  
**Background:** #F8FAFC  
**Cards:** White  
**Primary Blue:** #2563EB  
**Secondary Green:** #10B981  
**Accent Orange:** #F59E0B  
**Text Primary:** #111827  
**Text Secondary:** #6B7280  
**Font:** Inter (Google Fonts)  
**Radius:** 16–20px  
**Shadow:** Soft, elevated  
**Grid:** 8pt spacing system  
**Style:** Premium, minimal, SaaS, Apple HIG + Google Material 3 inspired, Urban Company / Airbnb / Uber / Stripe / Linear level quality

---

## 2. DEPENDENCIES (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.6
  bloc: ^8.1.4
  get_it: ^8.0.3
  injectable: ^2.4.4
  go_router: ^14.8.1
  dio: ^5.7.0
  dartz: ^0.10.1
  equatable: ^2.0.7
  intl: ^0.19.0
  google_fonts: ^6.2.1
  cached_network_image: ^3.4.1
  carousel_slider: ^5.0.0
  flutter_rating_bar: ^4.0.1
  shimmer: ^3.0.0
  flutter_svg: ^2.0.17
  lottie: ^3.3.1
  image_picker: ^1.1.2
  json_annotation: ^4.9.0
  flutter_local_notifications: ^18.0.1
  uuid: ^4.5.1
  collection: ^1.18.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.13
  injectable_generator: ^2.6.3
  json_serializable: ^6.9.2
  bloc_test: ^9.1.7
  mocktail: ^1.0.4
  flutter_lints: ^5.0.0
```

---

## 3. FOLDER STRUCTURE (MANDATORY — Generate every file)

```
lib/
├── main.dart
├── app.dart
│
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   ├── app_text_styles.dart
│   │   ├── app_spacing.dart
│   │   ├── app_radius.dart
│   │   ├── app_icons.dart
│   │   ├── app_images.dart
│   │   ├── app_assets.dart
│   │   └── app_constants.dart
│   │
│   ├── theme/
│   │   ├── app_theme.dart
│   │   ├── app_theme_data.dart
│   │   └── app_color_scheme.dart
│   │
│   ├── widgets/
│   │   ├── app_scaffold.dart
│   │   ├── app_button.dart
│   │   ├── app_card.dart
│   │   ├── app_text_field.dart
│   │   ├── app_search_bar.dart
│   │   ├── app_bottom_nav_bar.dart
│   │   ├── app_circular_icon.dart
│   │   ├── app_section_header.dart
│   │   ├── app_rating_display.dart
│   │   ├── app_avatar.dart
│   │   ├── app_badge.dart
│   │   ├── app_price_display.dart
│   │   ├── app_loading.dart
│   │   ├── app_shimmer.dart
│   │   ├── app_empty_state.dart
│   │   ├── app_error_state.dart
│   │   ├── app_gradient_banner.dart
│   │   ├── app_glassmorphism_card.dart
│   │   ├── app_chip.dart
│   │   ├── app_icon_badge.dart
│   │   ├── app_animated_icon.dart
│   │   ├── app_vertical_spacing.dart
│   │   ├── app_horizontal_spacing.dart
│   │   └── app_divider.dart
│   │
│   ├── network/
│   │   ├── api_client.dart
│   │   ├── api_endpoints.dart
│   │   ├── api_interceptors.dart
│   │   └── network_info.dart
│   │
│   ├── services/
│   │   ├── local_storage_service.dart
│   │   ├── navigation_service.dart
│   │   └── analytics_service.dart
│   │
│   ├── errors/
│   │   ├── failures.dart
│   │   ├── exceptions.dart
│   │   └── error_handler.dart
│   │
│   ├── utils/
│   │   ├── validators.dart
│   │   ├── formatters.dart
│   │   ├── date_utils.dart
│   │   └── debouncer.dart
│   │
│   ├── extensions/
│   │   ├── context_extensions.dart
│   │   ├── string_extensions.dart
│   │   ├── num_extensions.dart
│   │   └── date_extensions.dart
│   │
│   ├── routes/
│   │   ├── app_router.dart
│   │   ├── route_names.dart
│   │   └── route_paths.dart
│   │
│   └── di/
│       ├── injection_container.dart
│       └── injection_container.config.dart
│
├── data/
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── service_model.dart
│   │   ├── category_model.dart
│   │   ├── sub_service_model.dart
│   │   ├── package_model.dart
│   │   ├── booking_model.dart
│   │   ├── payment_model.dart
│   │   ├── review_model.dart
│   │   ├── provider_model.dart
│   │   ├── address_model.dart
│   │   ├── coupon_model.dart
│   │   ├── notification_model.dart
│   │   ├── chat_message_model.dart
│   │   ├── wallet_model.dart
│   │   └── offer_model.dart
│   │
│   └── datasources/
│       ├── local/
│       │   └── dummy_data.dart
│       └── remote/
│           └── api_datasource.dart
│
├── domain/
│   ├── entities/
│   │   ├── user.dart
│   │   ├── service.dart
│   │   ├── category.dart
│   │   ├── sub_service.dart
│   │   ├── package.dart
│   │   ├── booking.dart
│   │   ├── payment.dart
│   │   ├── review.dart
│   │   ├── provider.dart
│   │   ├── address.dart
│   │   ├── coupon.dart
│   │   ├── notification.dart
│   │   ├── chat_message.dart
│   │   ├── wallet.dart
│   │   └── offer.dart
│   │
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   ├── service_repository.dart
│   │   ├── booking_repository.dart
│   │   ├── payment_repository.dart
│   │   ├── review_repository.dart
│   │   ├── user_repository.dart
│   │   ├── notification_repository.dart
│   │   ├── chat_repository.dart
│   │   └── coupon_repository.dart
│   │
│   └── usecases/
│       ├── login_usecase.dart
│       ├── verify_otp_usecase.dart
│       ├── get_services_usecase.dart
│       ├── get_categories_usecase.dart
│       ├── get_recommended_services_usecase.dart
│       ├── book_service_usecase.dart
│       ├── get_bookings_usecase.dart
│       ├── track_booking_usecase.dart
│       ├── make_payment_usecase.dart
│       ├── get_saved_services_usecase.dart
│       ├── toggle_save_service_usecase.dart
│       ├── get_reviews_usecase.dart
│       ├── submit_review_usecase.dart
│       ├── get_user_profile_usecase.dart
│       ├── update_profile_usecase.dart
│       ├── get_wallet_balance_usecase.dart
│       └── apply_coupon_usecase.dart
│
├── features/
│   ├── splash/
│   │   └── presentation/
│   │       └── pages/
│   │           └── splash_page.dart
│   │
│   ├── onboarding/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── onboarding_page.dart
│   │       └── widgets/
│   │           ├── onboarding_item.dart
│   │           └── onboarding_indicator.dart
│   │
│   ├── auth/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── auth_repository_impl.dart
│   │   ├── domain/
│   │   │   └── repositories/
│   │   │       └── auth_repository.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── auth_bloc.dart
│   │       │   ├── auth_event.dart
│   │       │   └── auth_state.dart
│   │       ├── pages/
│   │       │   ├── login_page.dart
│   │       │   ├── otp_verification_page.dart
│   │       │   └── login_success_page.dart
│   │       └── widgets/
│   │           ├── phone_input_widget.dart
│   │           └── otp_input_widget.dart
│   │
│   ├── home/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── service_repository_impl.dart
│   │   ├── domain/
│   │   │   └── repositories/
│   │   │       └── service_repository.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── home_bloc.dart
│   │       │   ├── home_event.dart
│   │       │   └── home_state.dart
│   │       ├── pages/
│   │       │   ├── home_page.dart
│   │       │   └── guest_home_page.dart
│   │       └── widgets/
│   │           ├── app_bar_widget.dart
│   │           ├── search_section.dart
│   │           ├── promo_banner.dart
│   │           ├── categories_grid.dart
│   │           ├── quick_actions.dart
│   │           ├── recommended_services.dart
│   │           ├── popular_professionals.dart
│   │           ├── offers_section.dart
│   │           ├── customer_reviews.dart
│   │           ├── service_category_card.dart
│   │           ├── service_card.dart
│   │           └── professional_card.dart
│   │
│   ├── categories/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── service_category_page.dart
│   │       └── widgets/
│   │           ├── sub_service_card.dart
│   │           └── category_header.dart
│   │
│   ├── packages/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── package_selection_page.dart
│   │       └── widgets/
│   │           ├── package_card.dart
│   │           └── package_compare.dart
│   │
│   ├── service_details/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── service_details_page.dart
│   │       └── widgets/
│   │           ├── image_gallery.dart
│   │           ├── expandable_section.dart
│   │           ├── add_ons_section.dart
│   │           ├── reviews_section.dart
│   │           ├── provider_profile_card.dart
│   │           └── book_now_bar.dart
│   │
│   ├── booking/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── booking_repository_impl.dart
│   │   ├── domain/
│   │   │   └── repositories/
│   │   │       └── booking_repository.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── booking_bloc.dart
│   │       │   ├── booking_event.dart
│   │       │   └── booking_state.dart
│   │       ├── pages/
│   │       │   └── booking_page.dart
│   │       └── widgets/
│   │           ├── address_selector.dart
│   │           ├── date_time_picker.dart
│   │           ├── professional_selector.dart
│   │           ├── coupon_section.dart
│   │           ├── price_breakdown.dart
│   │           └── special_instructions.dart
│   │
│   ├── payment/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── payment_repository_impl.dart
│   │   ├── domain/
│   │   │   └── repositories/
│   │   │       └── payment_repository.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── payment_bloc.dart
│   │       │   ├── payment_event.dart
│   │       │   └── payment_state.dart
│   │       ├── pages/
│   │       │   └── payment_page.dart
│   │       └── widgets/
│   │           ├── payment_method_card.dart
│   │           ├── price_summary.dart
│   │           └── reward_points_section.dart
│   │
│   ├── booking_success/
│   │   └── presentation/
│   │       └── pages/
│   │           └── booking_success_page.dart
│   │
│   ├── track_booking/
│   │   └── presentation/
│   │       └── pages/
│   │           └── track_booking_page.dart
│   │
│   ├── saved/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── saved_repository_impl.dart
│   │   ├── domain/
│   │   │   └── repositories/
│   │   │       └── saved_repository.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── saved_bloc.dart
│   │       │   ├── saved_event.dart
│   │       │   └── saved_state.dart
│   │       ├── pages/
│   │       │   └── saved_services_page.dart
│   │       └── widgets/
│   │           ├── saved_service_card.dart
│   │           ├── filter_chips.dart
│   │           ├── recently_viewed.dart
│   │           ├── recommended_for_you.dart
│   │           ├── book_again_section.dart
│   │           ├── special_offer_card.dart
│   │           ├── saved_empty_state.dart
│   │           └── saved_ai_assistant.dart
│   │
│   ├── profile/
│   │   ├── data/
│   │   │   └── repositories/
│   │   │       └── user_repository_impl.dart
│   │   ├── domain/
│   │   │   └── repositories/
│   │   │       └── user_repository.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── profile_bloc.dart
│   │       │   ├── profile_event.dart
│   │       │   └── profile_state.dart
│   │       ├── pages/
│   │       │   └── profile_page.dart
│   │       └── widgets/
│   │           ├── profile_header_card.dart
│   │           ├── quick_stats.dart
│   │           ├── personal_info_section.dart
│   │           ├── my_bookings_section.dart
│   │           ├── saved_services_section.dart
│   │           ├── favorite_providers.dart
│   │           ├── payment_wallet_section.dart
│   │           ├── address_section.dart
│   │           ├── notification_settings.dart
│   │           ├── support_section.dart
│   │           ├── refer_earn_card.dart
│   │           ├── settings_section.dart
│   │           ├── profile_ai_assistant.dart
│   │           ├── membership_card.dart
│   │           └── recent_activity_timeline.dart
│   │
│   ├── wallet/
│   │   └── presentation/
│   │       └── pages/
│   │           └── wallet_page.dart
│   │
│   ├── notifications/
│   │   └── presentation/
│   │       └── pages/
│   │           └── notifications_page.dart
│   │
│   ├── chat/
│   │   └── presentation/
│   │       └── pages/
│   │           ├── chat_list_page.dart
│   │           └── chat_detail_page.dart
│   │
│   ├── support/
│   │   └── presentation/
│   │       └── pages/
│   │           └── support_page.dart
│   │
│   ├── settings/
│   │   └── presentation/
│   │       └── pages/
│   │           └── settings_page.dart
│   │
│   ├── search/
│   │   └── presentation/
│   │       └── pages/
│   │           └── search_page.dart
│   │
│   ├── reviews/
│   │   └── presentation/
│   │       └── pages/
│   │           └── reviews_page.dart
│   │
│   ├── offers/
│   │   └── presentation/
│   │       └── pages/
│   │           └── offers_page.dart
│   │
│   ├── coupons/
│   │   └── presentation/
│   │       └── pages/
│   │           └── coupons_page.dart
│   │
│   ├── addresses/
│   │   └── presentation/
│   │       └── pages/
│   │           └── addresses_page.dart
│   │
│   ├── provider_profile/
│   │   └── presentation/
│   │       └── pages/
│   │           └── provider_profile_page.dart
│   │
│   └── booking_history/
│       └── presentation/
│           └── pages/
│               └── booking_history_page.dart
│
├── assets/
│   ├── images/
│   ├── icons/
│   ├── fonts/
│   └── animations/
│
└── test/
    ├── core/
    ├── data/
    ├── domain/
    └── features/
```

---

## 4. CODING RULES

- **NO comments** in any generated code (zero, none, not a single line comment)
- Every file MUST have the correct import paths relative to `lib/`
- Use `package:user_servicehub/` imports
- All classes must be fully typed (no `var`, no `dynamic` unless absolutely required by Flutter SDK)
- Use `const` constructors everywhere possible
- Every widget must be a separate file
- Follow **Clean Architecture** strictly: data/domain/presentation layers NEVER leak across boundaries
- Repositories return `Either<Failure, T>` using `dartz`
- Bloc is the ONLY state management (no setState except in trivial local UI state)
- All strings from `AppStrings`, all colors from `AppColors`, all text styles from `AppTextStyles`
- All spacing from `AppSpacing` constants
- All radius from `AppRadius` constants
- All route paths from `RoutePaths`
- All route names from `RouteNames`
- Generate complete, realistic dummy data in `dummy_data.dart` — at least 20+ services, 10+ categories, 10+ providers, 10+ reviews, 5+ packages
- Use `GoogleFonts.inter()` for ALL text
- Every `Container`, `Card`, etc. with `borderRadius` must use `AppRadius` values
- Use `EdgeInsets.symmetric(horizontal: AppSpacing.md)` for standard horizontal padding
- Responsive: use `MediaQuery` / `LayoutBuilder` for tablet adaptivity
- Every screen file contains the FULL page widget, fully built out
- Bottom navigation bar has 5 tabs: Home, Bookings, Explore, Chat, Profile
- Guest mode: user can browse without login; show popup when attempting restricted actions
- All service images use placeholder icon from Material Icons (since no real assets)
- All profile images use CircleAvatar with first letter

---

## 5. DESIGN SYSTEM CONSTANTS

### AppColors (`lib/core/constants/app_colors.dart`)
```dart
class AppColors {
  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF60A5FA);
  static const Color primaryDark = Color(0xFF1D4ED8);
  static const Color secondary = Color(0xFF10B981);
  static const Color secondaryLight = Color(0xFF34D399);
  static const Color accent = Color(0xFFF59E0B);
  static const Color accentLight = Color(0xFFFBBF24);
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF111827);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFF3F4F6);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  static const Color shadow = Color(0x1A000000);
  static const Color overlay = Color(0x80000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color shimmerBase = Color(0xFFE5E7EB);
  static const Color shimmerHighlight = Color(0xFFF3F4F6);
  static const Color ratingStar = Color(0xFFF59E0B);
  static const Color verifiedBadge = Color(0xFF2563EB);
  static const Color emergencyRed = Color(0xFFEF4444);
  static const Color whatsAppGreen = Color(0xFF25D366);
  static const Color gradientStart = Color(0xFF2563EB);
  static const Color gradientEnd = Color(0xFF1D4ED8);
}
```

### AppStrings (`lib/core/constants/app_strings.dart`)
Full strings file with ALL text used across the app organized into sections:
- `appName`, `appTagline`, `greetingMorning`, `userName`
- `searchHint`, `voiceSearch`, `aiAssistant`
- All category names, all section headers
- All login/auth/onboarding strings
- All booking/payment/success strings
- All profile/settings/saved strings
- All error/empty state strings
- All button labels throughout the app
- All AI assistant strings
- All offer/coupon strings

### AppTextStyles (`lib/core/constants/app_text_styles.dart`)
All text styles using `GoogleFonts.inter()`:
- `displayLarge` (32, bold), `displayMedium` (28, bold), `displaySmall` (24, bold)
- `headlineLarge` (22, semibold), `headlineMedium` (20, semibold), `headlineSmall` (18, semibold)
- `titleLarge` (17, semibold), `titleMedium` (16, medium), `titleSmall` (14, medium)
- `bodyLarge` (16, regular), `bodyMedium` (14, regular), `bodySmall` (12, regular)
- `labelLarge` (14, medium), `labelMedium` (12, medium), `labelSmall` (10, medium)
- `buttonLarge` (16, semibold), `buttonMedium` (14, semibold), `buttonSmall` (12, semibold)
- `priceLarge` (24, bold, primary), `priceMedium` (18, bold, primary)

### AppSpacing (`lib/core/constants/app_spacing.dart`)
`AppSpacing.xs = 4, sm = 8, md = 16, lg = 24, xl = 32, xxl = 40, xxxl = 48, section = 32`

### AppRadius (`lib/core/constants/app_radius.dart`)
`AppRadius.xs = 4, sm = 8, md = 12, lg = 16, xl = 20, xxl = 24, full = 9999`

---

## 6. ROUTES & NAVIGATION

### RoutePaths (`lib/core/routes/route_paths.dart`)
- `/` → splash
- `/onboarding` → onboarding
- `/login` → login
- `/otp-verification` → otp verification
- `/login-success` → login success
- `/home` → home shell
- `/category/:id` → service category
- `/packages/:serviceId` → package selection
- `/service-details/:serviceId` → service details
- `/booking` → booking
- `/payment` → payment
- `/booking-success` → booking success
- `/track-booking/:id` → track booking
- `/saved` → saved services
- `/profile` → profile
- `/wallet` → wallet
- `/notifications` → notifications
- `/chat` → chat list
- `/chat/:id` → chat detail
- `/support` → support
- `/settings` → settings
- `/search` → search
- `/reviews/:serviceId` → reviews
- `/offers` → offers
- `/coupons` → coupons
- `/addresses` → addresses
- `/provider-profile/:id` → provider profile
- `/booking-history` → booking history

### AppRouter (`lib/core/routes/app_router.dart`)
Use `StatefulShellRoute` for bottom navigation (Home, Bookings, Explore, Chat, Profile). All routes defined with GoRouter.

---

## 7. SCREENS — FULL UI SPECIFICATIONS

### SCREEN 1: HOME PAGE (`features/home/presentation/pages/home_page.dart`)
Build EVERY section described below in full detail. This is the most important screen.

**Structure:**
1. **App Bar** — Leading: CircleAvatar with first letter "R", greeting text "Good Morning 👋" / "Ram Prakash", trailing: notification icon with badge. Location chip below.
2. **Search Bar** — Rounded (radius 20), white card with shadow, search icon, "Search for services..." hint text, voice icon right, AI sparkle icon far right.
3. **Promo Banner** — Auto-scrolling carousel (CarouselSlider), gradient background (primary → primaryDark), overlay text "Home Services up to 40% OFF", CTA "Book Now" rounded button. 3 slides minimum.
4. **Categories Grid** — Horizontal scrollable row with 12 circular colored icon items. Each: CircleAvatar(radius: 32) with icon + label below. Icons: Electrical, Plumbing, AC, Cleaning, Painting, Carpenter, Appliance, Pest, Beauty, Salon, Car Wash, More(arrow).
5. **Quick Actions** — 4 rounded cards in 2x2 grid: Emergency(red bg), Book Again, Track Booking, Nearby Experts. Each: card with icon + label, soft shadow.
6. **Recommended Services** — Horizontal ListView with service cards. Each card: Column with large image container (cached network image placeholder using Container with icon), service name, provider name, Row with star + "4.8" rating, distance text, "From \$49" price, "Book" button.
7. **Popular Professionals** — Horizontal ListView. Each card: circular profile photo, name, verified icon, "5 years exp", "120 jobs", "⭐ 4.9", "From \$35/hr", "View Profile" outline button.
8. **Offers Section** — Horizontal coupon cards with gradient borders. "Flat 25% OFF", "Save \$10", "First Booking Discount", "Free Inspection".
9. **Customer Reviews** — Horizontal cards with avatar, name, rating stars, review text, "Service: Home Cleaning".
10. **Bottom Nav** — Home(active), Bookings, Explore, Chat, Profile. Active: primary blue with indicator.

### SCREEN 2: SERVICE CATEGORY (`features/categories/presentation/pages/service_category_page.dart`)
- Header: back arrow, "Home Cleaning" title, search icon, heart icon
- Banner: large image container, "Home Cleaning" overlay, "⭐ 4.8 (2,340 reviews)", "From \$49"
- Sub Services Grid: 2-column grid of cards. Each: icon, title, "Bathroom deep cleaning", "From \$39", arrow icon
- Sticky bottom: "Continue" primary button

### SCREEN 3: PACKAGE SELECTION(`features/packages/presentation/pages/package_selection_page.dart`)
- Header: back, title "Select Package"
- 3 package cards: Basic, Standard(recommended badge), Premium
- Each card: price, duration, professionals count, bullet list of includes, "Select" button
- Recommended highlighted with blue border
- Sticky bottom: "Continue" button
- Package features: duration, warranty, equipment, material, free inspection, cancellation

### SCREEN 4: SERVICE DETAILS(`features/service_details/presentation/pages/service_details_page.dart`)
- Image gallery: swipeable images with dots indicator
- Service title, provider name + verified badge
- Rating, completed jobs, response time, experience
- Price, discount %, estimated duration
- Expandable sections: About, Included, Not Included, How it Works, Safety, FAQ, Why Choose Us
- Add-ons section: horizontal chips
- Reviews section: 3 review cards, "Write Review" button
- Provider profile card: photo, experience, skills, languages, verified, service area, emergency
- Sticky bottom: "Book Now" price bar

### SCREEN 5: BOOKING(`features/booking/presentation/pages/booking_page.dart`)
- Address: saved addresses list, map preview, add new
- Date picker: calendar widget
- Time slots: selectable chips
- Select professional: horizontal profile cards
- Coupon: "Add Coupon" with apply
- Price breakdown: service charge, platform fee, GST, discount, total
- Special instructions: text field, upload image, voice note
- Sticky bottom: "Proceed to Payment"

### SCREEN 6: PAYMENT(`features/payment/presentation/pages/payment_page.dart`)
- Payment methods: UPI(selected), Credit Card, Debit Card, Net Banking, Wallet, Cash After Service
- Each: icon + name + radio selection
- Price summary: itemized
- Coupon applied: green text
- Reward points: toggle switch
- "Pay Now" primary button

### SCREEN 7: BOOKING SUCCESS(`features/booking_success/presentation/pages/booking_success_page.dart`)
- Animated checkmark (Lottie)
- "Booking Confirmed!" title
- Booking ID: "#SHB-2024-001"
- Provider assigned, date, time
- Action buttons: Track Booking(call to action), Call Provider, Chat, Download Invoice, Share, Return Home

### SCREEN 8: SAVED SERVICES (`features/saved/presentation/pages/saved_services_page.dart`)
- Header: back, "Saved Services", subtitle "Your favorite services in one place", notification + search icons
- Search bar: "Search saved services...", voice, filter
- Filter chips row: All, Cleaning, Electrical, Plumbing, Salon, Repair, Painting, AC Service, Most Booked, Nearby, Recent, Offers
- Saved service cards: large premium card, image, name, category, provider, verified, rating, jobs, distance, price, discount badge, availability, duration, features chips(Instant Booking, Same Day, Warranty, Verified), Book Now / Remove / Share / More buttons
- Special offer card: gradient banner "25% OFF Exclusive Offer"
- Recently viewed: horizontal scroll
- Recommended for you: AI recommendation section
- Book again: previous bookings
- Empty state: premium illustration, "No Saved Services Yet", "Explore Services" button
- AI Assistant card: "Need help choosing?" with Recommend, Compare, Find Best Provider buttons
- Bottom nav: Saved active

### SCREEN 9: PROFILE(`features/profile/presentation/pages/profile_page.dart`)
- Header: back, "Profile", notification, settings
- Profile card: large circular photo (edit overlay), "Ram Prakash", verified badge, "Gold Member", "Since 2026", wallet balance, reward points, "80% Completed" progress bar, Edit Profile button
- Quick stats: 6 mini cards (Bookings 24, Completed 18, Saved 12, Reviews 8, Providers 6, Points 450)
- Personal info section: phone, email, gender, DOB, language, emergency contact, default address, Edit
- My bookings: upcoming / completed / cancelled tabs
- Saved services: horizontal mini cards
- Favorite providers: horizontal profile cards
- Payment & wallet: balance, cards, UPI, history
- Address management: Home, Office, Other, Add New
- Notifications settings: push, SMS, email, reminders, promo toggles
- Support: Help, Live Chat, Call, FAQs, Report, Complaint
- Refer & Earn: code, earnings, share
- Settings: language, dark mode, privacy, security, biometric, permissions, delete, logout
- AI Assistant: "Hello Ram 👋", book, recommend, track, voice, upload buttons
- Membership card: premium benefits, upgrade
- Recent activity timeline: booking, payment, review, coupon events
- Bottom nav: Profile active

### SCREEN 10: AUTH FLOW
**Onboarding:** 4 pages with full-screen illustrations, headline, description, page indicator, Skip, Next, Get Started.  
**Login:** Welcome illustration, "Welcome to ServiceHub", phone input with country picker +91, Continue, OR divider, Guest Login, Skip for Now(large outlined), Google + Apple sign in, terms. Skip navigates to guest home with banner.  
**OTP:** Back, "Verify Phone Number", "6-digit OTP sent to +91 XXXXX...", 6 input boxes, auto-read, 30s timer, resend, Verify, Change Number.  
**Success:** Animated checkmark, "Verification Successful", auto-navigate after 2s.

---

## 8. DUMMY DATA (`lib/data/datasources/local/dummy_data.dart`)

Generate AT LEAST:
- 12 categories with icons
- 30+ services across categories (with realistic names, descriptions, prices)
- 8 sub-services per category
- 3 packages per sub-service (Basic/Standard/Premium)
- 10 providers with names, photos(avatar letters), experience, ratings, jobs, skills, languages
- 15 reviews with names, ratings, dates, text, service names
- 5 coupons with codes, discounts, terms
- 5 offers with banners
- 10 bookings with statuses
- User profile data
- 5 addresses (Home, Office, etc.)
- 8 notifications
- 5 wallet transactions
- 5 chat messages
- Emergency contacts
- All with realistic Indian names and context

---

## 9. THEME (`lib/core/theme/app_theme_data.dart`)

Complete Material Design 3 theme with:
- `ColorScheme.fromSeed(seedColor: AppColors.primary)` with proper brightness
- `useMaterial3: true`
- Custom `CardTheme` with elevation 1, shadow, radius 16
- Custom `AppBarTheme` with transparent background, centerTitle: false, elevation: 0
- Custom `BottomNavigationBarTheme` with selected/unselected colors, type: fixed
- Custom `ElevatedButtonTheme` with 16 radius, primary color, large padding
- Custom `OutlinedButtonTheme` with 16 radius
- Custom `TextField` with 16 radius, filled background
- Custom `ChipTheme` with 12 radius
- Custom `DividerTheme`
- Custom `IconTheme`
- Custom `ProgressIndicatorTheme`

---

## 10. REUSABLE WIDGETS — BUILD EVERY ONE

- **AppScaffold**: standard screen wrapper with optional padding, safe area, background
- **AppButton**: primary, secondary, outline, text, gradient variants; sizes: small/medium/large; loading state; fullWidth option
- **AppCard**: Container wrapper with white bg, soft shadow, 16–20 radius, default padding 16
- **AppTextField**: decorated TextField with rounded border, label, hint, prefix/suffix icons, error state
- **AppSearchBar**: specialized search input with 20 radius, shadow, voice + AI suffix icons
- **AppBottomNavBar**: 5-tab navigation with active indicator animation
- **AppCircularIcon**: CircleAvatar with icon + colored background, fixed size
- **AppSectionHeader**: title + "See All" action row
- **AppRatingDisplay**: star icons + numeric rating
- **AppAvatar**: CircleAvatar with fallback initial, optional verified badge overlay
- **AppBadge**: positioned badge with count
- **AppPriceDisplay**: formatted price with "From" prefix, optional discount strike-through
- **AppLoading**: center circular indicator
- **AppShimmer**: shimmer placeholder card matching card dimensions
- **AppEmptyState**: illustration placeholder + title + subtitle + action button
- **AppErrorState**: error icon + message + retry button
- **AppGradientBanner**: gradient container with content overlay
- **AppGlassmorphismCard**: frosted glass effect card (blur, semi-transparent) — used ONLY on promo banners
- **AppChip**: rounded choice chip with selected state
- **AppIconBadge**: icon with notification dot
- **AppAnimatedIcon**: animated heart/favorite icon
- **AppVerticalSpacing**, **AppHorizontalSpacing**: sized box helpers
- **AppDivider**: themed divider with padding

---

## 11. BLOC PATTERN (every feature with bloc)

Each feature with bloc follows this exact pattern:
```dart
// auth_bloc.dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;

  AuthBloc({required this.loginUseCase, required this.verifyOtpUseCase}) : super(AuthInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async { ... }
  Future<void> _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async { ... }
}
```

Events are sealed classes using `freezed` pattern or manual sealed classes with `equatable`.
States extend `Equatable`.

---

## 12. IMPORTANT GENERATION RULES

1. **Generate EVERY file** listed in the folder structure. No shortcuts.
2. Every page must be a complete, fully-built widget with real UI. No TODOs, no stubs.
3. All data must come from the `DummyData` class — no real APIs.
4. All navigation fully wired through GoRouter.
5. All dependency injection wired through GetIt.
6. Every const, color, string, style is referenced from the constants files — NOT hardcoded.
7. Responsive: use `MediaQuery.of(context).size.width` for breakpoints (mobile < 600, tablet >= 600).
8. Dark mode: prefix with `MediaQuery.platformBrightnessOf(context)` or use `Theme.of(context).brightness`.
9. Bottom navigation uses `StatefulShellRoute` from GoRouter for state preservation.
10. Generate `main.dart` with `MultiBlocProvider`, `GetIt` setup, and `MaterialApp.router()` with GoRouter.

---

## 13. MAIN.DART STRUCTURE

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const ServiceHubApp());
}

class ServiceHubApp extends StatelessWidget {
  const ServiceHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<HomeBloc>()..add(LoadHomeEvent())),
        BlocProvider(create: (_) => getIt<AuthBloc>()),
        BlocProvider(create: (_) => getIt<SavedBloc>()..add(LoadSavedEvent())),
        BlocProvider(create: (_) => getIt<ProfileBloc>()..add(LoadProfileEvent())),
        BlocProvider(create: (_) => getIt<BookingBloc>()),
        BlocProvider(create: (_) => getIt<PaymentBloc>()),
      ],
      child: MaterialApp.router(
        title: AppStrings.appName,
        theme: AppThemeData.lightTheme,
        darkTheme: AppThemeData.darkTheme,
        themeMode: ThemeMode.light,
        routerConfig: getIt<GoRouter>(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
```

---

## 14. DELIVERY REQUIREMENTS

- Generate ALL code now. Do not stop until every file in the folder structure exists with complete content.
- Use `package:user_servicehub/` for all internal imports.
- Ensure zero compilation errors.
- All strings visible in UI come from `AppStrings`.
- All colors from `AppColors`.
- All text styles from `AppTextStyles`.
- All spacing from `AppSpacing`.
- All radius from `AppRadius`.
- No comments anywhere.
- Production-ready quality.
- Generate the project now.
