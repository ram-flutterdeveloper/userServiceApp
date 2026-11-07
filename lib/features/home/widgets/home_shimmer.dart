import 'package:flutter/material.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/widgets/skeleton_box.dart';

class HomeShimmer extends StatelessWidget {
  const HomeShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppDimensions.spacing16),
      child: Column(
        children: [
          Row(
            children: [
              const SkeletonBox(width: 48, height: 48, borderRadius: AppDimensions.radiusFull),
              const SizedBox(width: AppDimensions.spacing12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(width: 100, height: 12),
                    SizedBox(height: AppDimensions.spacing8),
                    SkeletonBox(width: 140, height: 16),
                  ],
                ),
              ),
              const SkeletonBox(width: 48, height: 48, borderRadius: AppDimensions.radiusSmall),
              const SizedBox(width: AppDimensions.spacing8),
              const SkeletonBox(width: 80, height: 32, borderRadius: AppDimensions.radiusFull),
            ],
          ),
          const SizedBox(height: AppDimensions.spacing20),
          const SkeletonBox(height: 54, borderRadius: AppDimensions.radiusBanner),
          const SizedBox(height: AppDimensions.spacing24),
          const SkeletonBox(height: 170, borderRadius: AppDimensions.radiusBanner),
          const SizedBox(height: AppDimensions.spacing24),
          const SkeletonBox(width: 120, height: 18),
          const SizedBox(height: AppDimensions.spacing12),
          SizedBox(
            height: 84,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 6,
              separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.spacing16),
              itemBuilder: (_, __) => const Column(
                children: [
                  SkeletonBox(width: 56, height: 56, borderRadius: AppDimensions.radiusMedium),
                  SizedBox(height: AppDimensions.spacing8),
                  SkeletonBox(width: 48, height: 10),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacing24),
          const SkeletonBox(width: 120, height: 18),
          const SizedBox(height: AppDimensions.spacing12),
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 4,
              separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.spacing12),
              itemBuilder: (_, __) => const SkeletonBox(width: 160, height: 100, borderRadius: AppDimensions.radiusCard),
            ),
          ),
          const SizedBox(height: AppDimensions.spacing24),
          const SkeletonBox(height: 120, borderRadius: AppDimensions.radiusCard),
          const SizedBox(height: AppDimensions.spacing24),
          const SkeletonBox(width: 160, height: 18),
          const SizedBox(height: AppDimensions.spacing12),
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.spacing12),
              itemBuilder: (_, __) => const SizedBox(
                width: 180,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(height: 100, borderRadius: AppDimensions.radiusCard),
                    SizedBox(height: AppDimensions.spacing8),
                    SkeletonBox(width: 140, height: 14),
                    SizedBox(height: AppDimensions.spacing4),
                    SkeletonBox(width: 100, height: 12),
                    SizedBox(height: AppDimensions.spacing4),
                    SkeletonBox(width: 80, height: 12),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacing24),
          const SkeletonBox(width: 160, height: 18),
          const SizedBox(height: AppDimensions.spacing12),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              separatorBuilder: (_, __) => const SizedBox(width: AppDimensions.spacing12),
              itemBuilder: (_, __) => const SkeletonBox(width: 200, height: 120, borderRadius: AppDimensions.radiusCard),
            ),
          ),
        ],
      ),
    );
  }
}
