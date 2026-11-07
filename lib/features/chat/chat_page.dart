import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';

class ChatPage extends StatefulWidget {
  final String providerId;
  const ChatPage({super.key, required this.providerId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late _ChatPartner _partner;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();

    _partner = _getPartner(widget.providerId);
    _messages.addAll(_mockMessages(widget.providerId));
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  _ChatPartner _getPartner(String id) {
    final partners = {
      '1': _ChatPartner(name: 'Rajesh Kumar', isOnline: true, avatar: 'R'),
      '2': _ChatPartner(name: 'Suresh Patel', isOnline: false, avatar: 'S'),
      '3': _ChatPartner(name: 'Amit Verma', isOnline: true, avatar: 'A'),
      '4': _ChatPartner(
        name: 'ServiceHub Support',
        isOnline: true,
        avatar: 'S',
      ),
    };
    return partners[id] ??
        _ChatPartner(name: 'Unknown', isOnline: false, avatar: '?');
  }

  List<_ChatMessage> _mockMessages(String id) {
    final now = DateTime.now();
    final messages = <_ChatMessage>[
      _ChatMessage(
        text: 'Hi! I need help with my AC repair booking.',
        time: now.subtract(const Duration(hours: 2)),
        isSentByMe: true,
      ),
      _ChatMessage(
        text: 'Hello! I\'d be happy to help. Can you share your booking ID?',
        time: now.subtract(const Duration(hours: 1, minutes: 58)),
        isSentByMe: false,
      ),
      _ChatMessage(
        text: 'Sure, it\'s SHB-2024-001.',
        time: now.subtract(const Duration(hours: 1, minutes: 55)),
        isSentByMe: true,
      ),
      _ChatMessage(
        text:
            'Let me check the details. I see your booking is scheduled for tomorrow at 10 AM.',
        time: now.subtract(const Duration(hours: 1, minutes: 50)),
        isSentByMe: false,
      ),
      _ChatMessage(
        text: 'Yes, that\'s correct. I just wanted to confirm.',
        time: now.subtract(const Duration(hours: 1, minutes: 45)),
        isSentByMe: true,
      ),
      _ChatMessage(
        text:
            'Your booking is confirmed. I will reach your location by 10 AM tomorrow.',
        time: now.subtract(const Duration(hours: 1, minutes: 40)),
        isSentByMe: false,
      ),
      _ChatMessage(
        text: 'Thank you so much! See you tomorrow.',
        time: now.subtract(const Duration(hours: 1, minutes: 35)),
        isSentByMe: true,
      ),
    ];
    if (id == '2') {
      return [
        _ChatMessage(
          text: 'Thank you for booking. See you tomorrow!',
          time: now.subtract(const Duration(hours: 3)),
          isSentByMe: false,
        ),
        _ChatMessage(
          text: 'Thanks! Looking forward to it.',
          time: now.subtract(const Duration(hours: 2, minutes: 55)),
          isSentByMe: true,
        ),
      ];
    }
    if (id == '3') {
      return [
        _ChatMessage(
          text: 'The job is completed. Please check and confirm.',
          time: now.subtract(const Duration(days: 1)),
          isSentByMe: false,
        ),
        _ChatMessage(
          text: 'Everything looks great. Thank you!',
          time: now.subtract(const Duration(days: 1, hours: -2)),
          isSentByMe: true,
        ),
      ];
    }
    if (id == '4') {
      return [
        _ChatMessage(
          text: 'Hi! How can we help you today?',
          time: now.subtract(const Duration(days: 1)),
          isSentByMe: false,
        ),
        _ChatMessage(
          text: 'I have a question about my recent booking.',
          time: now.subtract(const Duration(days: 1, hours: -1)),
          isSentByMe: true,
        ),
      ];
    }
    return messages;
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(
        _ChatMessage(text: text, time: DateTime.now(), isSentByMe: true),
      );
      _messageController.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _messages.add(
          _ChatMessage(
            text: 'Thank you for your message. I will get back to you shortly.',
            time: DateTime.now(),
            isSentByMe: false,
          ),
        );
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.primaryLight,
              child: Text(
                _partner.avatar,
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spacing12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _partner.name,
                  style: AppTextStyles.titleSmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:
                            _partner.isOnline
                                ? AppColors.success
                                : AppColors.textTertiary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _partner.isOnline ? 'Online' : 'Offline',
                      style: AppTextStyles.caption.copyWith(
                        color:
                            _partner.isOnline
                                ? AppColors.success
                                : AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_outlined, size: 22),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.videocam_outlined, size: 22),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child:
                _messages.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight.withValues(
                                alpha: 0.3,
                              ),
                              borderRadius: BorderRadius.circular(
                                AppDimensions.radiusCard,
                              ),
                            ),
                            child: const Icon(
                              Icons.chat_bubble_outline,
                              size: 32,
                              color: AppColors.textTertiary,
                            ),
                          ),
                          const SizedBox(height: AppDimensions.spacing16),
                          Text(
                            'No messages yet',
                            style: AppTextStyles.bodyLarge,
                          ),
                          const SizedBox(height: AppDimensions.spacing8),
                          Text(
                            'Start a conversation by sending a message.',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(
                        AppDimensions.spacing16,
                        AppDimensions.spacing16,
                        AppDimensions.spacing16,
                        AppDimensions.spacing16,
                      ),
                      itemCount: _messages.length,
                      itemBuilder: (_, i) {
                        final msg = _messages[i];
                        return _buildMessageBubble(msg);
                      },
                    ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(_ChatMessage msg) {
    final isMine = msg.isSentByMe;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment:
            isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMine)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  _partner.avatar,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isMine ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: Radius.circular(isMine ? 18 : 4),
                  bottomRight: Radius.circular(isMine ? 4 : 18),
                ),
                border:
                    isMine
                        ? null
                        : Border.all(
                          color: AppColors.border.withValues(alpha: 0.3),
                        ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    msg.text,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isMine ? AppColors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatTime(msg.time),
                    style: TextStyle(
                      fontSize: 10,
                      color:
                          isMine
                              ? AppColors.white.withValues(alpha: 0.7)
                              : AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border.withValues(alpha: 0.3)),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.attach_file_outlined,
              color: AppColors.textSecondary,
              size: 24,
            ),
            onPressed: () {},
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: 'Type a message...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textTertiary,
                ),
                filled: true,
                fillColor: AppColors.background,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.emoji_emotions_outlined,
              color: AppColors.textSecondary,
              size: 24,
            ),
            onPressed: () {},
          ),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send_rounded,
                color: AppColors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes} min ago';
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

class _ChatPartner {
  final String name;
  final bool isOnline;
  final String avatar;

  _ChatPartner({
    required this.name,
    required this.isOnline,
    required this.avatar,
  });
}

class _ChatMessage {
  final String text;
  final DateTime time;
  final bool isSentByMe;

  _ChatMessage({
    required this.text,
    required this.time,
    required this.isSentByMe,
  });
}
