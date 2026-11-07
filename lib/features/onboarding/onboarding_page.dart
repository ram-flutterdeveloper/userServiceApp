import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/constants/app_routes.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';
import 'package:user_servicehub/data/logic/provider/home_provider.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingItem> _pages = const [
    _OnboardingItem(
      icon: Icons.home_repair_service,
      title: 'Book Trusted Home Services',
      description: 'Find verified professionals for all your home needs.',
    ),
    _OnboardingItem(
      icon: Icons.verified_user,
      title: 'Verified Professionals',
      description:
          'All service providers are background verified and highly rated.',
    ),
    _OnboardingItem(
      icon: Icons.speed,
      title: 'Fast & Easy Booking',
      description: 'Book appointments in seconds with real-time availability.',
    ),
    _OnboardingItem(
      icon: Icons.auto_awesome,
      title: 'AI Powered Service Assistant',
      description:
          'Describe your problem using voice or images and let AI recommend the best service.',
    ),
  ];

  int get _totalPages => _pages.length;
  bool get _isLastPage => _currentPage == _totalPages - 1;
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeProvider>().resolveCurrentLocation();
    });
    super.initState();
  }

  void _onSkip() {
    _pageController.animateToPage(
      _totalPages - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _onBack() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _onNext() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _onGetStarted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (!mounted) return;
    context.pushReplacement(AppRoutes.home);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: AppDimensions.spacing8,
                right: AppDimensions.spacing8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (!_isLastPage)
                    TextButton(
                      onPressed: _onSkip,
                      child: Text(
                        'Skip',
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    )
                  else
                    const SizedBox(width: 80),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _totalPages,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spacing24,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primaryLight,
                                AppColors.primaryLight.withValues(alpha: 0.5),
                              ],
                            ),
                          ),
                          child: Icon(
                            page.icon,
                            size: 120,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacing48),
                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.headlineMedium.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacing16),
                        Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDimensions.spacing24,
                0,
                AppDimensions.spacing24,
                AppDimensions.spacing40,
              ),
              child: Column(
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _totalPages,
                    effect: ExpandingDotsEffect(
                      activeDotColor:
                          _isLastPage ? AppColors.primary : AppColors.primary,
                      dotColor: AppColors.border,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 3,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing32),
                  if (_isLastPage)
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
                            onTap: _onGetStarted,
                            child: Center(
                              child: Text(
                                'Get Started',
                                style: AppTextStyles.buttonLarge.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentPage > 0)
                          SizedBox(
                            height: AppDimensions.buttonHeightSmall,
                            child: TextButton(
                              onPressed: _onBack,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.arrow_back_ios,
                                    size: 18,
                                    color: AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Back',
                                    style: AppTextStyles.buttonMedium.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          const SizedBox(width: 80),
                        SizedBox(
                          height: AppDimensions.buttonHeightSmall,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusButton,
                              ),
                              gradient: const LinearGradient(
                                colors: [
                                  AppColors.primary,
                                  AppColors.primaryDark,
                                ],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.3,
                                  ),
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
                                onTap: _onNext,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 28,
                                    vertical: 14,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Next',
                                        style: AppTextStyles.buttonMedium,
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 18,
                                        color: AppColors.white,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingItem {
  final IconData icon;
  final String title;
  final String description;

  const _OnboardingItem({
    required this.icon,
    required this.title,
    required this.description,
  });
}
