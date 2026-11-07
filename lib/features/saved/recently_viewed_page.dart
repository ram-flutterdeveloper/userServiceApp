import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/constants/app_routes.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';
import 'package:user_servicehub/core/utils/image_utils.dart';
import 'package:user_servicehub/core/widgets/app_empty_state.dart';
import 'package:user_servicehub/core/widgets/app_error_state.dart';
import 'package:user_servicehub/core/widgets/app_loading_indicator.dart';
import 'package:user_servicehub/data/logic/provider/favourite_provider.dart';
import 'package:user_servicehub/data/models/service_model.dart';
import 'package:user_servicehub/features/services/service_details_page.dart';

class RecentlyViewedPage extends StatefulWidget {
  const RecentlyViewedPage({super.key});

  @override
  State<RecentlyViewedPage> createState() => _RecentlyViewedPageState();
}

class _RecentlyViewedPageState extends State<RecentlyViewedPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<FavouriteProvider>();
      if (provider.packages.isEmpty) {
        provider.fetchPackages();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final favourites = context.watch<FavouriteProvider>();
    final packages = favourites.packages;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 1,
        title: Text(
          'Recently Viewed',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body:
          favourites.isLoadingPackages && packages.isEmpty
              ? const AppFullScreenLoader()
              : favourites.packagesError != null && packages.isEmpty
              ? AppErrorState(
                message: favourites.packagesError!,
                onRetry: () => favourites.fetchPackages(),
              )
              : packages.isEmpty
              ? const AppEmptyState(
                icon: Icons.history,
                title: 'No recently viewed packages',
                subtitle: 'Packages you view will appear here',
              )
              : RefreshIndicator(
                onRefresh: favourites.fetchPackages,
                child: ListView.builder(
                  padding: const EdgeInsets.all(AppDimensions.spacing16),
                  itemCount: packages.length,
                  itemBuilder: (_, i) => _PackageCard(package: packages[i]),
                ),
              ),
    );
  }
}

class _PackageCard extends StatelessWidget {
  final ServiceModel package;

  const _PackageCard({required this.package});

  @override
  Widget build(BuildContext context) {
    final discount = package.discountPercentage;
    final offerPrice = package.price * (1 - discount / 100);

    return GestureDetector(
      onTap: () => {Get.to(() => PackageDetailsPage(serviceId: package.id))},

      // context.push(
      //   AppRoutes.serviceDetails.replaceFirst(':id', package.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppDimensions.spacing12),
        padding: const EdgeInsets.all(AppDimensions.spacing12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryLight.withValues(alpha: 0.5),
                    const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
              ),
              child: _thumbnail(),
            ),
            const SizedBox(width: AppDimensions.spacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          package.title,
                          style: AppTextStyles.titleSmall,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (discount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              AppDimensions.radiusFull,
                            ),
                          ),
                          child: Text(
                            '${discount.round()}% OFF',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.error,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  if (package.description.isNotEmpty)
                    Text(
                      package.description,
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        '\u20B9${offerPrice.toStringAsFixed(0)}',
                        style: AppTextStyles.titleSmall.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (discount > 0) ...[
                        const SizedBox(width: 6),
                        Text(
                          '\u20B9${package.price.toStringAsFixed(0)}',
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textTertiary,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
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

  Widget _thumbnail() {
    final url = package.imageUrl;
    final isNetworkUrl = url.startsWith('http') || url.startsWith('/');
    if (url.isEmpty || !isNetworkUrl) {
      return Center(
        child: Icon(
          Icons.image_outlined,
          color: AppColors.textTertiary.withValues(alpha: 0.5),
          size: 28,
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
      child: CachedNetworkImage(
        imageUrl: ImageUtils.resolveImageUrl(url) ?? url,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorWidget:
            (_, __, ___) => Center(
              child: Icon(
                Icons.image_outlined,
                color: AppColors.textTertiary.withValues(alpha: 0.5),
                size: 28,
              ),
            ),
      ),
    );
  }
}
