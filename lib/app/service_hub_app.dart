import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/provider.dart';
import 'package:user_servicehub/core/routes/app_router.dart';
import 'package:user_servicehub/core/theme/app_theme.dart';
import 'package:user_servicehub/data/logic/provider/address_provider.dart';
import 'package:user_servicehub/data/logic/provider/auth_provider.dart';
import 'package:user_servicehub/data/logic/provider/booking_provider.dart';
import 'package:user_servicehub/data/logic/provider/booking_details_provider.dart';
import 'package:user_servicehub/data/logic/provider/favourite_provider.dart';
import 'package:user_servicehub/data/logic/provider/home_provider.dart';
import 'package:user_servicehub/data/logic/provider/my_bookings_provider.dart';
import 'package:user_servicehub/data/logic/provider/package_provider.dart';
import 'package:user_servicehub/data/logic/provider/package_details_provider.dart';
import 'package:user_servicehub/data/logic/provider/package_reviews_provider.dart';
import 'package:user_servicehub/data/logic/provider/profile_provider.dart';

class ServiceHubApp extends StatelessWidget {
  const ServiceHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(393, 874),
      minTextAdapt: true,
      splitScreenMode: true,
      child: GlobalLoaderOverlay(
        useDefaultLoading: true,
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => HomeProvider()),
            ChangeNotifierProvider(create: (_) => FavouriteProvider()),
            ChangeNotifierProvider(create: (_) => PackageProvider()),
            ChangeNotifierProvider(create: (_) => PackageDetailsProvider()),
            ChangeNotifierProvider(create: (_) => AddressProvider()),
            ChangeNotifierProvider(create: (_) => BookingProvider()),
            ChangeNotifierProvider(create: (_) => MyBookingsProvider()),
            ChangeNotifierProvider(create: (_) => BookingDetailsProvider()),
            ChangeNotifierProvider(create: (_) => PackageReviewsProvider()),
            ChangeNotifierProvider(create: (_) => ProfileProvider()),
          ],
          child: GetMaterialApp.router(
            debugShowCheckedModeBanner: false,

            title: 'ServiceHub',
            theme: ThemeData(
              scaffoldBackgroundColor: Colors.white,
              fontFamily: 'GoogleSans',
              primarySwatch: Colors.blue,
            ),
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.system,
            routerDelegate: AppRouter.router.routerDelegate,
            routeInformationParser: AppRouter.router.routeInformationParser,
            routeInformationProvider: AppRouter.router.routeInformationProvider,
          ),
        ),
      ),
    );
  }
}
