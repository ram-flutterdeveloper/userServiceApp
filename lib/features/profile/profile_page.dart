import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:user_servicehub/core/constants/api.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/constants/app_routes.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';
import 'package:user_servicehub/core/widgets/app_error_state.dart';
import 'package:user_servicehub/core/widgets/app_icon_button.dart';
import 'package:user_servicehub/core/widgets/app_loading_indicator.dart';
import 'package:user_servicehub/data/logic/provider/favourite_provider.dart';
import 'package:user_servicehub/data/logic/provider/my_bookings_provider.dart';
import 'package:user_servicehub/data/logic/provider/profile_provider.dart';
import 'package:user_servicehub/data/models/profile_response_model.dart';
import 'package:user_servicehub/data/models/user_model.dart';
import 'package:user_servicehub/data/mock/mock_users.dart';
import 'package:user_servicehub/features/bookings/bookings_page.dart';
import 'package:user_servicehub/features/categories/categories_page.dart';
import 'package:user_servicehub/features/profile/widgets/profile_stat_card.dart';
import 'package:user_servicehub/features/profile/widgets/menu_tile.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserModel _user;

  @override
  void initState() {
    super.initState();
    _user = mockUser;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileProvider>().fetchProfile();
      context.read<MyBookingsProvider>().fetchBookings();
      context.read<FavouriteProvider>().fetchFavourites();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProfileProvider>();
    final profile = provider.profile;

    if (provider.isLoading && profile == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(),
        body: const AppFullScreenLoader(message: 'Loading profile...'),
      );
    }

    if (provider.error != null && profile == null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: _buildAppBar(),
        body: AppErrorState(
          message: provider.error!,
          onRetry: () => provider.fetchProfile(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileCard(profile),
            const SizedBox(height: AppDimensions.spacing16),
            _buildWalletPointsRow(),
            const SizedBox(height: AppDimensions.spacing16),
            _buildProfileProgress(profile),
            const SizedBox(height: AppDimensions.spacing20),
            _buildQuickStats(),
            const SizedBox(height: AppDimensions.spacing20),
            _buildPersonalInfo(profile),
            const SizedBox(height: AppDimensions.spacing20),
            _buildMenuSection(),
            const SizedBox(height: AppDimensions.spacing20),
            _buildAICard(profile),
            // const SizedBox(height: AppDimensions.spacing20),
            // _buildMembershipBanner(),
            const SizedBox(height: AppDimensions.spacing20),
            _buildRecentActivity(),
            const SizedBox(height: AppDimensions.spacing40),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Text('Profile', style: AppTextStyles.titleLarge),
      actions: [
        AppIconButton(
          icon: Icons.notifications_outlined,
          onPressed: () => context.push(AppRoutes.notifications),
          iconColor: AppColors.textPrimary,
        ),
        AppIconButton(
          icon: Icons.settings_outlined,
          onPressed: () => context.push(AppRoutes.settings),
          iconColor: AppColors.textPrimary,
        ),
      ],
    );
  }

  void _openUpdateProfile() async {
    await context.push(AppRoutes.updateProfile);
    if (mounted) {
      context.read<ProfileProvider>().fetchProfile();
    }
  }

  String _genderLabel(String? gender) {
    switch ((gender ?? '').toUpperCase()) {
      case 'FEMALE':
        return 'Female';
      case 'OTHER':
        return 'Other';
      case 'MALE':
        return 'Male';
      default:
        return 'Not set';
    }
  }

  String _displayDob(String? dob) {
    if (dob == null || dob.isEmpty) return 'Not set';
    return dob.split('T').first;
  }

  String _displayPhone(ProfileData? profile) {
    if (profile == null || profile.mobile == null) return 'Not set';
    return '${profile.countryCode ?? '+91'} ${profile.mobile}';
  }

  String _memberSince(ProfileData? profile) {
    final createdAt = profile?.createdAt;
    if (createdAt == null || createdAt.isEmpty) return 'Member';
    final date = DateTime.tryParse(createdAt);
    if (date == null) return 'Member';
    return 'Member Since ${date.year}';
  }

  Widget _buildProfileCard(ProfileData? profile) {
    final fullName = profile?.fullName ?? 'Profile';
    final initial = fullName.isNotEmpty ? fullName[0].toUpperCase() : '?';
    final hasImage = profile?.profileImage?.isNotEmpty == true;
    final isVerified = profile?.isMobileVerified == true;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusBanner),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.spacing20),
            decoration: BoxDecoration(
              color: AppColors.surface.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(AppDimensions.radiusBanner),
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.3),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: AppColors.primaryLight,
                          backgroundImage:
                              hasImage
                                  ? CachedNetworkImageProvider(
                                    APIURL.IMAGE_URL + profile!.profileImage!,
                                  )
                                  : null,
                          child:
                              hasImage
                                  ? null
                                  : Text(
                                    initial,
                                    style: AppTextStyles.displayMedium.copyWith(
                                      color: AppColors.primary,
                                    ),
                                  ),
                        ),
                        // Positioned(
                        //   bottom: 0,
                        //   right: 0,
                        //   child: GestureDetector(
                        //     onTap: _openUpdateProfile,
                        //     child: Container(
                        //       padding: const EdgeInsets.all(5),
                        //       decoration: const BoxDecoration(
                        //         color: AppColors.primary,
                        //         shape: BoxShape.circle,
                        //       ),
                        //       child: const Icon(
                        //         Icons.camera_alt,
                        //         size: 14,
                        //         color: AppColors.white,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    const SizedBox(width: AppDimensions.spacing16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  fullName,
                                  style: AppTextStyles.titleLarge,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (isVerified) ...[
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.verified,
                                  size: 18,
                                  color: AppColors.primary,
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.phone_outlined,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  _displayPhone(profile),
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _memberSince(profile),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWalletPointsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing20),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.spacing16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF1D4ED8)],
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.account_balance_wallet_outlined,
                    color: AppColors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Wallet Balance',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '\u20B9${_user.walletBalance.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(AppDimensions.spacing16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.monetization_on_outlined,
                    color: AppColors.white,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Reward Points',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${_user.rewardPoints} pts',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileProgress(ProfileData? profile) {
    final completed = profile?.isProfileCompleted == true;
    final progressValue = completed ? 1.0 : 0.8;
    final progressLabel = completed ? '100%' : '80%';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing20),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Profile Completed:', style: AppTextStyles.titleSmall),
                Text(
                  progressLabel,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              child: LinearProgressIndicator(
                value: progressValue,
                minHeight: 8,
                backgroundColor: AppColors.border,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _openUpdateProfile,
              child: Text(
                completed
                    ? 'Tap to update your profile'
                    : 'Complete your profile',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStats() {
    final bookingsProvider = context.watch<MyBookingsProvider>();
    final bookings = bookingsProvider.bookings;
    final totalBookings = bookings.length;
    final completedBookings =
        bookings.where((b) => b.status == 'completed').length;
    final cancelledBookings =
        bookings.where((b) => b.status == 'cancelled').length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacing12),
            child: Text('Quick Stats', style: AppTextStyles.titleMedium),
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              SizedBox(
                width: (MediaQuery.of(context).size.width - 60) / 3,
                child: ProfileStatCard(
                  icon: Icons.calendar_today_outlined,
                  value: '$totalBookings',
                  label: 'Bookings',
                  color: AppColors.primary,
                ),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width - 60) / 3,
                child: ProfileStatCard(
                  icon: Icons.check_circle_outline,
                  value: '$completedBookings',
                  label: 'Completed',
                  color: AppColors.success,
                ),
              ),
              SizedBox(
                width: (MediaQuery.of(context).size.width - 60) / 3,
                child: ProfileStatCard(
                  icon: Icons.cancel_outlined,
                  value: '$cancelledBookings',
                  label: 'Cancelled',
                  color: AppColors.error,
                ),
              ),

              // SizedBox(
              //   width: (MediaQuery.of(context).size.width - 60) / 3,
              //   child: ProfileStatCard(
              //     icon: Icons.star_outline,
              //     value: '12',
              //     label: 'Reviews',
              //     color: const Color(0xFF8B5CF6),
              //   ),
              // ),
              // SizedBox(
              //   width: (MediaQuery.of(context).size.width - 60) / 3,
              //   child: ProfileStatCard(
              //     icon: Icons.favorite_outline,
              //     value: '${_user.favoriteProviderIds.length}',
              //     label: 'Favorites',
              //     color: const Color(0xFF2563EB),
              //   ),
              // ),
              // SizedBox(
              //   width: (MediaQuery.of(context).size.width - 60) / 3,
              //   child: ProfileStatCard(
              //     icon: Icons.monetization_on_outlined,
              //     value: '${_user.rewardPoints}',
              //     label: 'Points',
              //     color: const Color(0xFF06B6D4),
              //   ),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfo(ProfileData? profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing20),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacing16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusBanner),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Personal Information', style: AppTextStyles.titleMedium),
                GestureDetector(
                  onTap: _openUpdateProfile,
                  child: Text(
                    'Edit',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppDimensions.spacing16),
            _infoRow(Icons.phone_outlined, 'Phone', _displayPhone(profile)),
            _infoDivider(),
            _infoRow(Icons.email_outlined, 'Email', profile?.email ?? ''),
            _infoDivider(),
            _infoRow(
              Icons.person_outline,
              'Gender',
              _genderLabel(profile?.gender),
            ),
            _infoDivider(),
            _infoRow(
              Icons.calendar_month_outlined,
              'Date of Birth',
              _displayDob(profile?.dob),
            ),
            _infoDivider(),
            _infoRow(
              Icons.workspace_premium_outlined,
              'Role',
              profile?.role ?? 'Not set',
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primaryLight,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            ),
            child: Icon(icon, color: AppColors.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              const SizedBox(height: 2),
              SizedBox(
                width: MediaQuery.of(context).size.width - 160,
                child: Text(
                  value.isNotEmpty ? value : 'Not set',
                  style: AppTextStyles.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoDivider() {
    return const Divider(height: 1, color: AppColors.border);
  }

  Widget _buildMenuSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing20),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusBanner),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            MenuTile(
              icon: Icons.calendar_today_outlined,
              title: 'My Bookings',
              onTap: () => context.push(AppRoutes.bookings),
            ),
            _menuDivider(),
            MenuTile(
              icon: Icons.bookmark_outline,
              title: 'Saved Services',
              onTap: () => context.push(AppRoutes.saved),
            ),
            _menuDivider(),
            MenuTile(
              icon: Icons.favorite_outline,
              title: 'Favorite Providers',
              onTap: () {},
            ),
            _menuDivider(),
            MenuTile(
              icon: Icons.account_balance_wallet_outlined,
              title: 'Payment & Wallet',
              onTap: () => context.push(AppRoutes.payment),
            ),
            _menuDivider(),
            MenuTile(
              icon: Icons.location_on_outlined,
              title: 'Address Management',
              onTap: () {},
            ),
            _menuDivider(),
            MenuTile(
              icon: Icons.notifications_outlined,
              title: 'Notifications',
              onTap: () => context.push(AppRoutes.notifications),
            ),
            _menuDivider(),
            MenuTile(
              icon: Icons.support_outlined,
              title: 'Support',
              onTap: () => context.push(AppRoutes.support),
            ),
            _menuDivider(),
            MenuTile(
              icon: Icons.share_outlined,
              title: 'Refer & Earn',
              onTap: () {},
            ),
            _menuDivider(),
            MenuTile(
              icon: Icons.settings_outlined,
              title: 'Settings',
              onTap: () => context.push(AppRoutes.settings),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 60, right: AppDimensions.spacing16),
      child: const Divider(height: 1, color: AppColors.border),
    );
  }

  Widget _buildAICard(ProfileData? profile) {
    final firstName = (profile?.firstName ?? '').trim();
    final greetingName = firstName.isNotEmpty ? firstName : 'Friend';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing20),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.spacing20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF06B6D4), Color(0xFF2563EB)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppDimensions.radiusBanner),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusMedium,
                    ),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: AppColors.white,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Hello $greetingName \u{1F44B}',
                  style: AppTextStyles.titleLarge.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Need help today?',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.white.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: AppDimensions.spacing16),
            Row(
              children: [
                _aiChip(
                  'Book',
                  onTap: () {
                    Get.to(() => CategoriesPage());
                    // context.push(AppRoutes.bookings);
                  },
                ),

                const SizedBox(width: 10),
                _aiChip(
                  'Recommend',
                  onTap: () {
                    Get.to(() => CategoriesPage());
                  },
                ),
                const SizedBox(width: 10),
                _aiChip(
                  'Track',
                  onTap: () {
                    Get.to(() => BookingsPage());
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _aiChip(String label, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelMedium.copyWith(color: AppColors.white),
        ),
      ),
    );
  }

  Widget _buildMembershipBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppDimensions.radiusBanner),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.spacing20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xB22563EB), Color(0xB28B5CF6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusBanner),
              border: Border.all(color: AppColors.white.withValues(alpha: 0.2)),
            ),
            child: Stack(
              children: [
                Positioned(
                  right: -20,
                  top: -20,
                  child: Icon(
                    Icons.workspace_premium,
                    size: 100,
                    color: AppColors.white.withValues(alpha: 0.15),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.workspace_premium,
                          color: AppColors.white,
                          size: 28,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Upgrade to Premium',
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Get priority service, extra discounts & more',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.white.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.spacing16),
                    Row(
                      children: [
                        _benefitChip('Priority'),
                        const SizedBox(width: 8),
                        _benefitChip('15% Off'),
                        const SizedBox(width: 8),
                        _benefitChip('Free Inspec.'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _benefitChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(color: AppColors.white),
      ),
    );
  }

  Widget _buildRecentActivity() {
    final bookings = context.watch<MyBookingsProvider>().bookings;
    final savedServices = context.watch<FavouriteProvider>().savedServices;

    final List<Map<String, dynamic>> activities = [];

    String serviceName(dynamic booking) {
      if (booking.items.isNotEmpty &&
          booking.items.first.packageName.isNotEmpty) {
        return booking.items.first.packageName;
      }
      return booking.bookingNumber;
    }

    String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }

    // Find the most recent booking that has not been cancelled.
    final activeBookings =
        bookings.where((booking) {
            final status = booking.status.toUpperCase();

            return status != 'CANCELLED' &&
                status != 'CANCELED' &&
                status != 'REJECTED' &&
                status != 'PROVIDER_REJECTED' &&
                booking.bookingDate != null;
          }).toList()
          ..sort((a, b) => b.bookingDate!.compareTo(a.bookingDate!));

    if (activeBookings.isNotEmpty) {
      final booking = activeBookings.first;

      activities.add({
        'text':
            'Booked ${serviceName(booking)} - '
            '${_formatDate(booking.bookingDate)}',
        'icon': Icons.calendar_today_outlined,
        'color': AppColors.primary,
      });
    }

    // Find the most recently completed booking.
    final completedBookings =
        bookings.where((booking) {
            final status = booking.status.toUpperCase();

            return (status == 'COMPLETED' || status == 'DONE') &&
                booking.bookingDate != null;
          }).toList()
          ..sort((a, b) => b.bookingDate!.compareTo(a.bookingDate!));

    if (completedBookings.isNotEmpty) {
      final booking = completedBookings.first;

      activities.add({
        'text':
            'Completed ${serviceName(booking)} - '
            '${_formatDate(booking.bookingDate)}',
        'icon': Icons.check_circle_outline,
        'color': AppColors.success,
      });
    }

    // Show the most recently saved favourite.
    if (savedServices.isNotEmpty) {
      final favourite = savedServices.last;

      activities.add({
        'text': 'Added ${favourite.title} to favourites',
        'icon': Icons.favorite_outline,
        'color': AppColors.error,
      });
    }

    if (activities.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spacing20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppDimensions.spacing12),
            child: Text('Recent Activity', style: AppTextStyles.titleMedium),
          ),
          Container(
            padding: const EdgeInsets.all(AppDimensions.spacing16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: List.generate(activities.length, (index) {
                final item = activities[index];
                final color = item['color'] as Color;

                return Padding(
                  padding: EdgeInsets.only(
                    bottom:
                        index < activities.length - 1
                            ? AppDimensions.spacing12
                            : 0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusSmall,
                          ),
                        ),
                        child: Icon(
                          item['icon'] as IconData,
                          size: 16,
                          color: color,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          item['text'] as String,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
