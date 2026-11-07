import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/constants/app_routes.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final List<_ChatThread> _threads = [
    _ChatThread(
      id: '1',
      name: 'Rajesh Kumar',
      lastMessage: 'Sure, I will reach your location by 10 AM.',
      time: '10:32 AM',
      unreadCount: 2,
    ),
    _ChatThread(
      id: '2',
      name: 'Suresh Patel',
      lastMessage: 'Thank you for booking. See you tomorrow!',
      time: '9:15 AM',
      unreadCount: 1,
    ),
    _ChatThread(
      id: '3',
      name: 'Amit Verma',
      lastMessage: 'The job is completed. Please check and confirm.',
      time: 'Yesterday',
      unreadCount: 0,
    ),
    _ChatThread(
      id: '4',
      name: 'ServiceHub Support',
      lastMessage: 'Hi! How can we help you today?',
      time: 'Yesterday',
      unreadCount: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title:  Text('Chat', style: AppTextStyles.titleLarge),
      ),
      body: _threads.isEmpty
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
                      Icons.chat_bubble_outline,
                      size: 40,
                      color: AppColors.textTertiary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.spacing24),
                   Text(
                    'No conversations yet',
                    style: AppTextStyles.titleLarge,
                  ),
                  const SizedBox(height: AppDimensions.spacing8),
                  Text(
                    'Start a chat with a professional or our support team.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(AppDimensions.spacing16),
              itemCount: _threads.length,
              separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.spacing12),
              itemBuilder: (_, i) {
                final thread = _threads[i];
                return GestureDetector(
                  onTap: () => context.push(AppRoutes.chat.replaceAll(':id', thread.id)),
                  child: Container(
                    padding: const EdgeInsets.all(AppDimensions.spacing16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                      border: Border.all(
                        color: AppColors.border.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundColor: AppColors.primaryLight,
                          child: Text(
                            thread.name[0],
                            style: AppTextStyles.titleMedium.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
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
                                      thread.name,
                                      style: AppTextStyles.titleSmall.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    thread.time,
                                    style: AppTextStyles.caption.copyWith(
                                      color: AppColors.textTertiary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                thread.lastMessage,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        if (thread.unreadCount > 0) ...[
                          const SizedBox(width: AppDimensions.spacing8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '${thread.unreadCount}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _ChatThread {
  final String id;
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;

  _ChatThread({
    required this.id,
    required this.name,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
  });
}
