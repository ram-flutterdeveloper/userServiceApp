import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/constants/app_routes.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late List<_NotificationItem> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = _mockNotifications();
  }

  List<_NotificationItem> _mockNotifications() {
    return [
      _NotificationItem(
        icon: Icons.check_circle,
        iconColor: AppColors.success,
        title: 'Booking Confirmed',
        body: 'Your AC Repair service has been confirmed for tomorrow at 10:00 AM.',
        time: '2 hours ago',
        isNew: true,
        route: AppRoutes.bookings,
      ),
      _NotificationItem(
        icon: Icons.person,
        iconColor: AppColors.primary,
        title: 'Professional Assigned',
        body: 'Rajesh Kumar has been assigned to your booking #SHB-2024-001.',
        time: '3 hours ago',
        isNew: true,
        route: AppRoutes.bookings,
      ),
      _NotificationItem(
        icon: Icons.local_offer,
        iconColor: AppColors.accent,
        title: 'Special Offer',
        body: 'Flat 25% OFF on Home Cleaning. Limited time offer!',
        time: '5 hours ago',
        isNew: true,
        route: AppRoutes.home,
      ),
      _NotificationItem(
        icon: Icons.wallet,
        iconColor: AppColors.success,
        title: 'Payment Successful',
        body: 'Your payment of ₹2,499 for Home Cleaning was successful.',
        time: '1 day ago',
        isNew: false,
        route: AppRoutes.bookings,
      ),
      _NotificationItem(
        icon: Icons.star,
        iconColor: AppColors.accent,
        title: 'Review Reminder',
        body: 'How was your Plumbing service? Share your feedback and help others.',
        time: '2 days ago',
        isNew: false,
        route: AppRoutes.bookings,
      ),
      _NotificationItem(
        icon: Icons.share,
        iconColor: AppColors.primary,
        title: 'Refer & Earn',
        body: 'Invite friends and earn ₹100 for every successful referral.',
        time: '3 days ago',
        isNew: false,
        route: AppRoutes.home,
      ),
    ];
  }

  void _markAllRead() {
    setState(() {
      for (final n in _notifications) {
        n.isNew = false;
      }
    });
  }

  void _markAsRead(int index) {
    setState(() {
      _notifications[index].isNew = false;
    });
  }

  void _dismissNotification(int index) {
    setState(() {
      _notifications.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title:  Text('Notifications', style: AppTextStyles.titleLarge),
        actions: [
          if (_notifications.any((n) => n.isNew))
            TextButton(
              onPressed: _markAllRead,
              child:  Text(
                'Mark all read',
                style: AppTextStyles.labelLarge,
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                    ),
                    child: const Icon(
                      Icons.notifications_none,
                      size: 40,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing24),
                   Text(
                    'No notifications yet',
                    style: AppTextStyles.titleLarge,
                  ),
                  const SizedBox(height: AppDimensions.spacing8),
                  Text(
                    'We\'ll notify you when something arrives.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: () async {
                await Future.delayed(const Duration(milliseconds: 800));
                setState(() {
                  _notifications = _mockNotifications();
                });
              },
              child: ListView.separated(
                padding: const EdgeInsets.all(AppDimensions.spacing16),
                itemCount: _notifications.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.spacing12),
                itemBuilder: (_, i) {
                  final notif = _notifications[i];
                  return Dismissible(
                    key: ValueKey(notif.title + notif.time),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: AppDimensions.spacing24),
                      decoration: BoxDecoration(
                        color: AppColors.error,
                        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                      ),
                      child: const Icon(Icons.delete_outline, color: AppColors.white, size: 28),
                    ),
                    onDismissed: (_) => _dismissNotification(i),
                    child: GestureDetector(
                      onTap: () {
                        _markAsRead(i);
                        context.push(notif.route);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(AppDimensions.spacing16),
                        decoration: BoxDecoration(
                          color: notif.isNew
                              ? AppColors.primaryLight.withValues(alpha: 0.3)
                              : AppColors.surface,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                          border: Border.all(
                            color: AppColors.border.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: notif.iconColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
                              ),
                              child: Icon(notif.icon, color: notif.iconColor, size: 22),
                            ),
                            const SizedBox(width: AppDimensions.spacing12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          notif.title,
                                          style: AppTextStyles.titleSmall.copyWith(
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                      if (notif.isNew)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: const Text(
                                            'NEW',
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.white,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    notif.body,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    notif.time,
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class _NotificationItem {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;
  final String time;
  bool isNew;
  final String route;

  _NotificationItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
    required this.time,
    required this.isNew,
    required this.route,
  });
}
