import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';

class MainNavigationPage extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainNavigationPage({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) => navigationShell.goBranch(index),
          backgroundColor: AppColors.surface,
          indicatorColor: AppColors.primaryLight,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.home_rounded, color: AppColors.textTertiary),
              selectedIcon: Icon(Icons.home_rounded, color: AppColors.primary),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Icons.grid_view_rounded, color: AppColors.textTertiary),
              selectedIcon: Icon(Icons.grid_view_rounded, color: AppColors.primary),
              label: 'Categories',
            ),
            NavigationDestination(
              icon: Icon(Icons.receipt_long_rounded, color: AppColors.textTertiary),
              selectedIcon: Icon(Icons.receipt_long_rounded, color: AppColors.primary),
              label: 'Bookings',
            ),
            NavigationDestination(
              icon: Icon(Icons.favorite_rounded, color: AppColors.textTertiary),
              selectedIcon: Icon(Icons.favorite_rounded, color: AppColors.primary),
              label: 'Saved',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_rounded, color: AppColors.textTertiary),
              selectedIcon: Icon(Icons.person_rounded, color: AppColors.primary),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
