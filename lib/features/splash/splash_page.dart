import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_strings.dart';
import 'package:user_servicehub/core/constants/app_durations.dart';
import 'package:user_servicehub/core/constants/app_routes.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.ms1500,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
    _controller.forward();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(AppDurations.ms2000);
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
    if (!mounted) return;
    if (onboardingCompleted) {
      context.pushReplacement(AppRoutes.home);
    } else {
      context.pushReplacement(AppRoutes.onboarding);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2563EB),
              Color(0xFF1D4ED8),
              Color(0xFF1E3A8A),
            ],
          ),
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.white.withValues(alpha: 0.15),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.white.withValues(alpha: 0.1),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ShaderMask(
                  blendMode: BlendMode.srcIn,
                  shaderCallback: (bounds) => const LinearGradient(
                    colors: [AppColors.white, Color(0xFF93C5FD)],
                  ).createShader(bounds),
                  child: const Icon(
                    Icons.build_circle,
                    size: 70,
                    color: AppColors.white,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                AppStrings.appName,
                style: AppTextStyles.displayLarge.copyWith(
                  color: AppColors.white,
                  fontSize: 42,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                AppStrings.appTagline,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.white.withValues(alpha: 0.85),
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              const Padding(
                padding: EdgeInsets.only(bottom: 48),
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
