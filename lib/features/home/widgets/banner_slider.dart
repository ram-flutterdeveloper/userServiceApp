import 'dart:async';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';

class PromoBanner {
  final String title;
  final String subtitle;
  final Color gradientStart;
  final Color gradientEnd;
  final String image;

  const PromoBanner({
    required this.title,
    required this.subtitle,
    required this.gradientStart,
    required this.gradientEnd,
    required this.image,
  });
}

class BannerSlider extends StatefulWidget {
  final List<PromoBanner> banners;

  const BannerSlider({super.key, required this.banners});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  late PageController _controller;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (widget.banners.isEmpty) return;
      final nextPage = (_currentPage + 1) % widget.banners.length;
      _controller.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.banners.length,
            onPageChanged: (page) => setState(() => _currentPage = page),
            itemBuilder: (_, i) {
              final b = widget.banners[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Image.asset(b.image, fit: BoxFit.fill),
                // Container(
                //   decoration: BoxDecoration(
                //     gradient: LinearGradient(
                //       colors: [b.gradientStart, b.gradientEnd],
                //       begin: Alignment.topLeft,
                //       end: Alignment.bottomRight,
                //     ),
                //     borderRadius: BorderRadius.circular(
                //       AppDimensions.radiusBanner,
                //     ),
                //     boxShadow: [
                //       BoxShadow(
                //         color: b.gradientStart.withValues(alpha: 0.3),
                //         blurRadius: 12,
                //         offset: const Offset(0, 4),
                //       ),
                //     ],
                //   ),
                //   padding: const EdgeInsets.all(AppDimensions.spacing20),
                //   child:

                //   Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Text(
                //         b.title,
                //         style: const TextStyle(
                //           color: AppColors.white,
                //           fontSize: 22,
                //           fontWeight: FontWeight.w700,
                //           height: 1.2,
                //         ),
                //       ),
                //       const SizedBox(height: 6),
                //       Text(
                //         b.subtitle,
                //         style: TextStyle(
                //           color: AppColors.white.withValues(alpha: 0.9),
                //           fontSize: 14,
                //           fontWeight: FontWeight.w500,
                //         ),
                //       ),
                //       const Spacer(),
                //       Container(
                //         padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                //         decoration: BoxDecoration(
                //           color: AppColors.white.withValues(alpha: 0.2),
                //           borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                //           border: Border.all(color: AppColors.white.withValues(alpha: 0.3)),
                //         ),
                //         child: const Text(
                //           'Book Now',
                //           style: TextStyle(color: AppColors.white, fontWeight: FontWeight.w600, fontSize: 12),
                //         ),
                //       ),
                //     ],
                //   ),

                // ),
              );
            },
          ),
        ),
        const SizedBox(height: AppDimensions.spacing12),
        SmoothPageIndicator(
          controller: _controller,
          count: widget.banners.length,
          effect: ExpandingDotsEffect(
            dotHeight: 6,
            dotWidth: 6,
            activeDotColor: AppColors.primary,
            dotColor: AppColors.border,
            expansionFactor: 3,
          ),
        ),
      ],
    );
  }
}
