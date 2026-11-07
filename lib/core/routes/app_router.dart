import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_servicehub/core/constants/app_routes.dart';
import 'package:user_servicehub/features/splash/splash_page.dart';
import 'package:user_servicehub/features/onboarding/onboarding_page.dart';
import 'package:user_servicehub/features/authentication/login_page.dart';
import 'package:user_servicehub/features/authentication/otp_page.dart';
import 'package:user_servicehub/features/authentication/login_success_page.dart';
import 'package:user_servicehub/features/navigation/main_navigation_page.dart';
import 'package:user_servicehub/features/home/home_page.dart';
import 'package:user_servicehub/features/categories/categories_page.dart';
import 'package:user_servicehub/features/categories/service_category_page.dart';
import 'package:user_servicehub/features/services/package_selection_page.dart';
import 'package:user_servicehub/features/services/service_details_page.dart';
import 'package:user_servicehub/features/booking/booking_page.dart';
import 'package:user_servicehub/features/payment/payment_page.dart';
import 'package:user_servicehub/features/booking/booking_success_page.dart';
import 'package:user_servicehub/features/saved/saved_services_page.dart';
import 'package:user_servicehub/features/saved/recently_viewed_page.dart';
import 'package:user_servicehub/features/profile/profile_page.dart';
import 'package:user_servicehub/features/profile/edit_profile_page.dart';
import 'package:user_servicehub/features/profile/documents_page.dart';
import 'package:user_servicehub/features/bookings/bookings_page.dart';
import 'package:user_servicehub/features/booking/booking_details_page.dart';
import 'package:user_servicehub/features/booking/track_page.dart';
import 'package:user_servicehub/features/professionals/professionals_page.dart';
import 'package:user_servicehub/features/professionals/professional_details_page.dart';
import 'package:user_servicehub/features/notifications/notifications_page.dart';
import 'package:user_servicehub/features/chat/chat_list_page.dart';
import 'package:user_servicehub/features/chat/chat_page.dart';
import 'package:user_servicehub/features/settings/settings_page.dart';
import 'package:user_servicehub/features/settings/privacy_page.dart';
import 'package:user_servicehub/features/settings/terms_page.dart';
import 'package:user_servicehub/features/support/support_page.dart';
import 'package:user_servicehub/features/support/faq_page.dart';
import 'package:user_servicehub/features/profile/widgets/add_address_page.dart';
import 'package:user_servicehub/features/profile/update_profile_page.dart';
import 'package:user_servicehub/data/models/user_model.dart';
import 'package:user_servicehub/data/models/MyBookingResponse.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class AppRouter {
  AppRouter._();

  static GoRouter router = GoRouter(
    //  navigatorKey: _rootNavigatorKey,
    // initialLocation: AppRoutes.splash,
    navigatorKey: Get.key,
    // navigatorKey: GlobalVariable.globalScaffoldKey,
    initialLocation: AppRoutes.splash,
    routes: [
      animatedGoRoute(
        path: AppRoutes.splash,
        name: AppRouteNames.splash,
        pageBuilder: (_, __) => const SplashPage(),
      ),
      animatedGoRoute(
        path: AppRoutes.onboarding,
        name: AppRouteNames.onboarding,
        pageBuilder: (_, __) => const OnboardingPage(),
      ),
      animatedGoRoute(
        path: AppRoutes.login,
        name: AppRouteNames.login,
        pageBuilder: (_, __) => const LoginPage(),
      ),
      animatedGoRoute(
        path: AppRoutes.otp,
        name: AppRouteNames.otp,
        pageBuilder: (_, state) => OtpPage(key: state.pageKey),
      ),
      animatedGoRoute(
        path: AppRoutes.loginSuccess,
        name: AppRouteNames.loginSuccess,
        pageBuilder: (_, __) => const LoginSuccessPage(),
      ),
      StatefulShellRoute.indexedStack(
        pageBuilder: (_, __, navigationShell) {
          return NoTransitionPage(
            child: MainNavigationPage(navigationShell: navigationShell),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              animatedGoRoute(
                path: AppRoutes.home,
                name: AppRouteNames.home,
                pageBuilder: (_, __) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              animatedGoRoute(
                path: AppRoutes.categories,
                name: AppRouteNames.categories,
                pageBuilder: (_, __) => const CategoriesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              animatedGoRoute(
                path: AppRoutes.bookings,
                name: AppRouteNames.bookings,
                pageBuilder: (_, __) => const BookingsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              animatedGoRoute(
                path: AppRoutes.saved,
                name: AppRouteNames.saved,
                pageBuilder: (_, __) => const SavedServicesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              animatedGoRoute(
                path: AppRoutes.profile,
                name: AppRouteNames.profile,
                pageBuilder: (_, __) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),

      animatedGoRoute(
        path: AppRoutes.category,
        name: AppRouteNames.category,

        pageBuilder:
            (_, state) => ServiceCategoryPage(
              categoryId: state.pathParameters['id'] ?? '',
            ),
      ),
      animatedGoRoute(
        path: AppRoutes.packageSelection,
        name: AppRouteNames.packageSelection,

        pageBuilder:
            (_, state) => PackageSelectionPage(
              serviceId: state.pathParameters['id'] ?? '',
              serviceName: state.uri.queryParameters['name'] ?? '',
            ),
      ),
     
      animatedGoRoute(
        path: AppRoutes.booking,
        name: AppRouteNames.booking,

        pageBuilder: (_, __) => const BookingPage(),
      ),
      animatedGoRoute(
        path: AppRoutes.payment,
        name: AppRouteNames.payment,

        pageBuilder: (_, __) => const PaymentPage(),
      ),
      animatedGoRoute(
        path: AppRoutes.bookingSuccess,
        name: AppRouteNames.bookingSuccess,

        pageBuilder: (_, __) => const BookingSuccessPage(),
      ),
    
      animatedGoRoute(
        path: AppRoutes.bookingTrack,
        name: AppRouteNames.bookingTrack,

        pageBuilder:
            (_, state) => TrackPage(booking: state.extra as BookingHistoryItem),
      ),
      animatedGoRoute(
        path: AppRoutes.professionals,
        name: AppRouteNames.professionals,

        pageBuilder: (_, __) => const ProfessionalsPage(),
      ),
      animatedGoRoute(
        path: AppRoutes.professional,
        name: AppRouteNames.professional,

        pageBuilder:
            (_, state) => ProfessionalDetailsPage(
              professionalId: state.pathParameters['id'] ?? '',
            ),
      ),
      animatedGoRoute(
        path: AppRoutes.editProfile,
        name: AppRouteNames.editProfile,

        pageBuilder:
            (_, state) => EditProfilePage(user: state.extra as UserModel),
      ),
      animatedGoRoute(
        path: AppRoutes.documents,
        name: AppRouteNames.documents,

        pageBuilder: (_, __) => const DocumentsPage(),
      ),
      animatedGoRoute(
        path: AppRoutes.notifications,
        name: AppRouteNames.notifications,

        pageBuilder: (_, __) => const NotificationsPage(),
      ),
      animatedGoRoute(
        path: AppRoutes.chatList,
        name: AppRouteNames.chatList,

        pageBuilder: (_, __) => const ChatListPage(),
      ),
     
      animatedGoRoute(
        path: AppRoutes.settings,
        name: AppRouteNames.settings,

        pageBuilder: (_, __) => const SettingsPage(),
      ),
      animatedGoRoute(
        path: AppRoutes.support,
        name: AppRouteNames.support,

        pageBuilder: (_, __) => const SupportPage(),
      ),
      animatedGoRoute(
        path: AppRoutes.faq,
        name: AppRouteNames.faq,

        pageBuilder: (_, __) => const FaqPage(),
      ),
      animatedGoRoute(
        path: AppRoutes.privacy,
        name: AppRouteNames.privacy,

        pageBuilder: (_, __) => const PrivacyPage(),
      ),
      animatedGoRoute(
        path: AppRoutes.terms,
        name: AppRouteNames.terms,

        pageBuilder: (_, __) => const TermsPage(),
      ),
      animatedGoRoute(
        path: AppRoutes.addAddress,
        name: AppRouteNames.addAddress,

        pageBuilder: (_, __) => const AddAddressPage(),
      ),
      animatedGoRoute(
        path: AppRoutes.updateProfile,
        name: AppRouteNames.updateProfile,

        pageBuilder: (_, __) => const UpdateProfilePage(),
      ),
      animatedGoRoute(
        path: AppRoutes.recentlyViewed,
        name: AppRouteNames.recentlyViewed,

        pageBuilder: (_, __) => const RecentlyViewedPage(),
      ),
    ],
  );
}

GoRoute animatedGoRoute({
  required String path,
  required String name,
  ExitCallback? onExitPage,
  required Widget Function(BuildContext, GoRouterState) pageBuilder,
}) {
  return GoRoute(
    path: path,
    name: name,
    onExit: onExitPage,
    pageBuilder: (context, state) {
      return CustomTransitionPage<void>(
        key: state.pageKey,
        transitionDuration: const Duration(milliseconds: 100),
        child: pageBuilder(context, state),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0); // Right to left
          const end = Offset.zero;
          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: Curves.easeInOut));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );
    },
  );
}
