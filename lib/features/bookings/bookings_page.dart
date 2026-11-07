// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:go_router/go_router.dart';
// import 'package:provider/provider.dart';
// import 'package:user_servicehub/core/constants/app_colors.dart';
// import 'package:user_servicehub/core/constants/app_dimensions.dart';
// import 'package:user_servicehub/core/constants/app_routes.dart';
// import 'package:user_servicehub/core/theme/app_text_styles.dart';
// import 'package:user_servicehub/core/widgets/app_empty_state.dart';
// import 'package:user_servicehub/data/logic/provider/my_bookings_provider.dart';
// import 'package:user_servicehub/data/models/booking_model.dart';
// import 'package:user_servicehub/features/booking/booking_details_page.dart';
// import 'package:user_servicehub/features/bookings/widgets/booking_card.dart';
// import 'package:user_servicehub/core/widgets/app_loading_indicator.dart';
// import 'package:user_servicehub/core/widgets/app_error_state.dart';
// import 'package:user_servicehub/features/chat/chat_page.dart';

// class BookingsPage extends StatefulWidget {
//   const BookingsPage({super.key});

//   @override
//   State<BookingsPage> createState() => _BookingsPageState();
// }

// class _BookingsPageState extends State<BookingsPage>
//     with SingleTickerProviderStateMixin {
//   late TabController _tabController;

//   @override
//   void initState() {
//     super.initState();
//     _tabController = TabController(length: 3, vsync: this);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       context.read<MyBookingsProvider>().fetchBookings();
//     });
//   }

//   @override
//   void dispose() {
//     _tabController.dispose();
//     super.dispose();
//   }

//   List<BookingModel> _filteredBookings(List<BookingModel> bookings, int tab) {
//     switch (tab) {
//       case 0:
//         return bookings.where((b) => b.status == 'upcoming').toList();
//       case 1:
//         return bookings.where((b) => b.status == 'completed').toList();
//       case 2:
//         return bookings.where((b) => b.status == 'cancelled').toList();
//       default:
//         return bookings;
//     }
//   }

//   Map<String, VoidCallback> _actionsForBooking(BookingModel booking) {
//     switch (booking.status) {
//       case 'upcoming':
//         return {
//           'track':
//               () => Get.to(() => BookingDetailsPage(bookingId: booking.id)),
//           //  context.push(
//           //   AppRoutes.bookingDetails.replaceFirst(':id', booking.id),
//           // ),
//           'chat': () => Get.to(() => ChatPage(providerId: booking.providerId)),

//           // context.push(
//           //   AppRoutes.chat.replaceFirst(':id', booking.providerId),
//           //),
//           'call': () => _showCallDialog(booking),
//           'cancel': () => _showCancelDialog(booking),
//           'reschedule': () => context.push(AppRoutes.booking),
//         };
//       case 'active':
//         return {
//           'track':
//               () => context.push(
//                 AppRoutes.bookingDetails.replaceFirst(':id', booking.id),
//               ),
//           'chat':
//               () => context.push(
//                 AppRoutes.chat.replaceFirst(':id', booking.providerId),
//               ),
//           'call': () => _showCallDialog(booking),
//         };
//       case 'completed':
//         return {
//           'review': () => _showReviewDialog(booking),
//           'bookAgain':
//               () => context.push(
//                 AppRoutes.serviceDetails.replaceFirst(':id', booking.serviceId),
//               ),
//           'invoice': () {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                 content: Text('Invoice downloaded'),
//                 behavior: SnackBarBehavior.floating,
//               ),
//             );
//           },
//         };
//       case 'cancelled':
//         return {
//           'bookAgain':
//               () => context.push(
//                 AppRoutes.serviceDetails.replaceFirst(':id', booking.serviceId),
//               ),
//         };
//       default:
//         return {};
//     }
//   }

//   void _showCallDialog(BookingModel booking) {
//     showDialog(
//       context: context,
//       builder:
//           (ctx) => AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
//             ),
//             title: const Text('Call Provider'),
//             content: Text(
//               'Call ${booking.providerName} at ${booking.providerPhone}?',
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(ctx).pop(),
//                 child: const Text('Cancel'),
//               ),
//               FilledButton(
//                 onPressed: () {
//                   Navigator.of(ctx).pop();
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Calling ${booking.providerName}...'),
//                       behavior: SnackBarBehavior.floating,
//                     ),
//                   );
//                 },
//                 child: const Text('Call'),
//               ),
//             ],
//           ),
//     );
//   }

//   void _showCancelDialog(BookingModel booking) {
//     showDialog(
//       context: context,
//       builder:
//           (ctx) => AlertDialog(
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
//             ),
//             title: const Text('Cancel Booking'),
//             content: Text(
//               'Are you sure you want to cancel ${booking.serviceName}?',
//             ),
//             actions: [
//               TextButton(
//                 onPressed: () => Navigator.of(ctx).pop(),
//                 child: const Text('No'),
//               ),
//               FilledButton(
//                 onPressed: () {
//                   Navigator.of(ctx).pop();
//                   context.read<MyBookingsProvider>().updateBookingStatus(
//                     booking.id,
//                     'cancelled',
//                   );
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('${booking.serviceName} cancelled'),
//                       behavior: SnackBarBehavior.floating,
//                       action: SnackBarAction(
//                         label: 'UNDO',
//                         textColor: AppColors.white,
//                         onPressed: () {
//                           context.read<MyBookingsProvider>().restoreBooking(
//                             booking,
//                           );
//                         },
//                       ),
//                     ),
//                   );
//                 },
//                 style: FilledButton.styleFrom(backgroundColor: AppColors.error),
//                 child: const Text('Yes, Cancel'),
//               ),
//             ],
//           ),
//     );
//   }

//   void _showReviewDialog(BookingModel booking) {
//     double rating = 4.0;
//     showDialog(
//       context: context,
//       builder:
//           (ctx) => StatefulBuilder(
//             builder:
//                 (ctx, setDialogState) => AlertDialog(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(
//                       AppDimensions.radiusCard,
//                     ),
//                   ),
//                   title: const Text('Rate Your Service'),
//                   content: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         'How was your experience with ${booking.providerName}?',
//                         style: AppTextStyles.bodyMedium,
//                         textAlign: TextAlign.center,
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: List.generate(5, (i) {
//                           return IconButton(
//                             icon: Icon(
//                               i < rating.round()
//                                   ? Icons.star
//                                   : Icons.star_border,
//                               color:
//                                   i < rating.round()
//                                       ? AppColors.accent
//                                       : AppColors.textTertiary,
//                               size: 36,
//                             ),
//                             onPressed: () {
//                               setDialogState(() => rating = (i + 1).toDouble());
//                             },
//                           );
//                         }),
//                       ),
//                       const SizedBox(height: 16),
//                       TextField(
//                         maxLines: 3,
//                         decoration: InputDecoration(
//                           hintText: 'Write your review...',
//                           hintStyle: AppTextStyles.bodyMedium.copyWith(
//                             color: AppColors.textTertiary,
//                           ),
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(
//                               AppDimensions.radiusInput,
//                             ),
//                           ),
//                           filled: true,
//                           fillColor: AppColors.background,
//                         ),
//                       ),
//                     ],
//                   ),
//                   actions: [
//                     TextButton(
//                       onPressed: () => Navigator.of(ctx).pop(),
//                       child: const Text('Skip'),
//                     ),
//                     FilledButton(
//                       onPressed: () {
//                         Navigator.of(ctx).pop();
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text('Review submitted!'),
//                             behavior: SnackBarBehavior.floating,
//                           ),
//                         );
//                       },
//                       child: const Text('Submit'),
//                     ),
//                   ],
//                 ),
//           ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final provider = context.watch<MyBookingsProvider>();
//     final allBookings = provider.bookings;

//     return Scaffold(
//       backgroundColor: AppColors.background,
//       appBar: AppBar(
//         backgroundColor: AppColors.surface,
//         surfaceTintColor: Colors.transparent,
//         scrolledUnderElevation: 1,
//         title: Text(
//           'My Bookings',
//           style: AppTextStyles.titleMedium.copyWith(
//             fontWeight: FontWeight.w700,
//             color: AppColors.textPrimary,
//           ),
//         ),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(48),
//           child: Container(
//             color: AppColors.surface,
//             child: TabBar(
//               controller: _tabController,
//               indicatorColor: AppColors.primary,
//               labelColor: AppColors.primary,
//               unselectedLabelColor: AppColors.textSecondary,
//               labelStyle: AppTextStyles.labelMedium.copyWith(
//                 fontWeight: FontWeight.w600,
//               ),
//               unselectedLabelStyle: AppTextStyles.labelMedium,
//               indicatorSize: TabBarIndicatorSize.tab,
//               indicator: BoxDecoration(
//                 border: Border(
//                   bottom: BorderSide(color: AppColors.primary, width: 3),
//                 ),
//               ),
//               tabs: const [
//                 Tab(text: 'Bookings'),
//                 Tab(text: 'Completed'),
//                 Tab(text: 'Cancelled'),
//               ],
//             ),
//           ),
//         ),
//       ),
//       body: _buildBody(context, provider, allBookings),
//     );
//   }

//   Widget _buildBody(
//     BuildContext context,
//     MyBookingsProvider provider,
//     List<BookingModel> allBookings,
//   ) {
//     if (provider.error != null && allBookings.isEmpty) {
//       return AppErrorState(
//         message: provider.error!,
//         onRetry: () => context.read<MyBookingsProvider>().fetchBookings(),
//       );
//     }

//     if (provider.isLoading && allBookings.isEmpty) {
//       return const AppFullScreenLoader();
//     }

//     return TabBarView(
//       controller: _tabController,
//       children: List.generate(3, (tabIndex) {
//         final filtered = _filteredBookings(allBookings, tabIndex);
//         if (filtered.isEmpty) {
//           final messages = [
//             'No upcoming bookings',
//             'No completed bookings',
//             'No cancelled bookings',
//           ];
//           final icons = [
//             Icons.event_note_outlined,
//             Icons.check_circle_outline,
//             Icons.cancel_outlined,
//           ];
//           return AppEmptyState(
//             icon: icons[tabIndex],
//             title: messages[tabIndex],
//             subtitle:
//                 'Your ${_tabLabel(tabIndex).toLowerCase()} bookings will appear here',
//             buttonLabel: 'Book a Service',
//             onButtonTap: () => context.push(AppRoutes.categories),
//           );
//         }
//         return RefreshIndicator(
//           onRefresh: () => context.read<MyBookingsProvider>().fetchBookings(),
//           child: ListView.builder(
//             padding: const EdgeInsets.all(AppDimensions.spacing16),
//             itemCount: filtered.length,
//             itemBuilder: (_, i) {
//               final booking = filtered[i];
//               final actions = _actionsForBooking(booking);
//               return BookingCard(booking: booking, onAction: actions);
//             },
//           ),
//         );
//       }),
//     );
//   }

//   String _tabLabel(int index) {
//     switch (index) {
//       case 0:
//         return 'Upcoming';
//       case 1:
//         return 'Completed';
//       case 2:
//         return 'Cancelled';
//       default:
//         return '';
//     }
//   }
// }



import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/constants/app_routes.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';
import 'package:user_servicehub/core/widgets/app_empty_state.dart';
import 'package:user_servicehub/core/widgets/app_error_state.dart';
import 'package:user_servicehub/core/widgets/app_loading_indicator.dart';

import 'package:user_servicehub/data/logic/provider/my_bookings_provider.dart';
import 'package:user_servicehub/data/models/MyBookingResponse.dart';


import 'package:user_servicehub/features/booking/booking_details_page.dart';
import 'package:user_servicehub/features/bookings/widgets/booking_card.dart';
import 'package:user_servicehub/features/chat/chat_page.dart';

class BookingsPage extends StatefulWidget {
  const BookingsPage({super.key});

  @override
  State<BookingsPage> createState() => _BookingsPageState();
}

class _BookingsPageState extends State<BookingsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  bool _isChangingTab = false;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(_onTabChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      context.read<MyBookingsProvider>().fetchBookings(
        status: 'bookings',
      );
    });
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging || _isChangingTab) return;

    final provider = context.read<MyBookingsProvider>();

    final status = switch (_tabController.index) {
      0 => 'bookings',
      1 => 'completed',
      2 => 'cancelled',
      _ => 'bookings',
    };

    if (provider.status == status) return;

    _isChangingTab = true;

    provider.fetchBookings(status: status).whenComplete(() {
      _isChangingTab = false;
    });
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  Map<String, VoidCallback> _actionsForBooking(
    BookingHistoryItem booking,
  ) {
    switch (booking.uiStatus) {
      case 'upcoming':
        return {
          'track': () {
            Get.to(
              () => BookingDetailsPage(bookingId: booking.id),
            );
          },
          if (booking.providerId != null &&
              booking.providerId!.isNotEmpty)
            'chat': () {
              Get.to(
                () => ChatPage(
                  providerId: booking.providerId!,
                ),
              );
            },
          'call': () => _showCallDialog(booking),
          'cancel': () => _showCancelDialog(booking),
          'reschedule': () => context.push(AppRoutes.booking),
        };

      case 'active':
        return {
          'track': () {
            context.push(
              AppRoutes.bookingDetails.replaceFirst(
                ':id',
                booking.id,
              ),
            );
          },
          if (booking.providerId != null &&
              booking.providerId!.isNotEmpty)
            'chat': () {
              context.push(
                AppRoutes.chat.replaceFirst(
                  ':id',
                  booking.providerId!,
                ),
              );
            },
          'call': () => _showCallDialog(booking),
        };

      case 'completed':
        return {
          'review': () => _showReviewDialog(booking),
          if (booking.serviceId.isNotEmpty)
            'bookAgain': () {
              context.push(
                AppRoutes.serviceDetails.replaceFirst(
                  ':id',
                  booking.serviceId,
                ),
              );
            },
          'invoice': () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Invoice download is not connected yet.',
                ),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
        };

      case 'cancelled':
        return {
          if (booking.serviceId.isNotEmpty)
            'bookAgain': () {
              context.push(
                AppRoutes.serviceDetails.replaceFirst(
                  ':id',
                  booking.serviceId,
                ),
              );
            },
        };

      default:
        return {};
    }
  }

  void _showCallDialog(BookingHistoryItem booking) {
    final providerName = booking.providerName;
    final providerPhone = booking.providerPhone;

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppDimensions.radiusCard,
            ),
          ),
          title: const Text('Call Provider'),
          content: Text(
            providerPhone.isEmpty
                ? 'Contact details are not available for $providerName.'
                : 'Call $providerName at $providerPhone?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Close'),
            ),
            if (providerPhone.isNotEmpty)
              FilledButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Phone calling must be connected to a calling action.',
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text('Call'),
              ),
          ],
        );
      },
    );
  }

  void _showCancelDialog(BookingHistoryItem booking) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              AppDimensions.radiusCard,
            ),
          ),
          title: const Text('Cancel Booking'),
          content: Text(
            'Are you sure you want to cancel '
            '${booking.serviceName}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('No'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.error,
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Connect your booking cancellation API to cancel this booking.',
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text('Yes, Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showReviewDialog(BookingHistoryItem booking) {
    double rating = 4.0;
    final reviewController = TextEditingController();

    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (dialogContext, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppDimensions.radiusCard,
                ),
              ),
              title: const Text('Rate Your Service'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'How was your experience with '
                      '${booking.providerName}?',
                      style: AppTextStyles.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return IconButton(
                          onPressed: () {
                            setDialogState(() {
                              rating = (index + 1).toDouble();
                            });
                          },
                          icon: Icon(
                            index < rating.round()
                                ? Icons.star
                                : Icons.star_border,
                            color: index < rating.round()
                                ? AppColors.accent
                                : AppColors.textTertiary,
                            size: 32,
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: reviewController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Write your review...',
                        hintStyle: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textTertiary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            AppDimensions.radiusInput,
                          ),
                        ),
                        filled: true,
                        fillColor: AppColors.background,
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    reviewController.dispose();
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    reviewController.dispose();
                    Navigator.of(dialogContext).pop();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Review submission API is not connected yet.',
                        ),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: const Text('Submit'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MyBookingsProvider>();
    final bookings = provider.bookings;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 1,
        title: Text(
          'My Bookings',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            color: AppColors.surface,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppColors.primary,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: AppTextStyles.labelMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: AppTextStyles.labelMedium,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.primary,
                    width: 3,
                  ),
                ),
              ),
              tabs: const [
                Tab(text: 'Bookings'),
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
            ),
          ),
        ),
      ),
      body: _buildBody(context, provider, bookings),
    );
  }

  Widget _buildBody(
    BuildContext context,
    MyBookingsProvider provider,
    List<BookingHistoryItem> bookings,
  ) {
    if (provider.error != null && bookings.isEmpty) {
      return AppErrorState(
        message: provider.error!,
        onRetry: () => provider.refresh(),
      );
    }

    if (provider.isLoading && bookings.isEmpty) {
      return const AppFullScreenLoader();
    }

    if (bookings.isEmpty) {
      final tabIndex = _tabController.index;

      final messages = [
        'No bookings found',
        'No completed bookings',
        'No cancelled bookings',
      ];

      final icons = [
        Icons.event_note_outlined,
        Icons.check_circle_outline,
        Icons.cancel_outlined,
      ];

      return AppEmptyState(
        icon: icons[tabIndex],
        title: messages[tabIndex],
        subtitle: 'Your bookings will appear here.',
        buttonLabel: 'Book a Service',
        onButtonTap: () => context.push(AppRoutes.categories),
      );
    }

    return RefreshIndicator(
      onRefresh: provider.refresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(
          AppDimensions.spacing16,
        ),
        itemCount: bookings.length +
            (provider.hasNextPage || provider.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == bookings.length) {
            if (provider.isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: OutlinedButton(
                  onPressed: provider.loadNextPage,
                  child: const Text('Load more'),
                ),
              ),
            );
          }

          final booking = bookings[index];

          return BookingCard(
            booking: booking,
            onAction: _actionsForBooking(booking),
          );
        },
      ),
    );
  }
}

/// UI-only display helpers. These do not filter booking lists.
extension BookingHistoryDisplay on BookingHistoryItem {
  String get serviceName {
    if (items.isNotEmpty && items.first.packageName.isNotEmpty) {
      return items.first.packageName;
    }
    return bookingNumber;
  }

  String get serviceId {
    if (items.isNotEmpty) {
      return items.first.serviceId;
    }
    return '';
  }

  String get providerName {
    final businessName = provider?.businessName ?? '';
    if (businessName.isNotEmpty) {
      return businessName;
    }

    final ownerName = provider?.ownerName ?? '';
    if (ownerName.isNotEmpty) {
      return ownerName;
    }

    return 'Not assigned';
  }

  String get providerPhone => provider?.phone ?? '';

  String get uiStatus {
    switch (status.toUpperCase()) {
      case 'PENDING':
      case 'CONFIRMED':
        return 'upcoming';

      case 'ONGOING':
      case 'IN_PROGRESS':
      case 'STARTED':
      case 'ON_THE_WAY':
      case 'ARRIVED':
        return 'active';

      case 'COMPLETED':
      case 'DONE':
        return 'completed';

      case 'CANCELLED':
      case 'CANCELED':
      case 'REJECTED':
      case 'PROVIDER_REJECTED':
        return 'cancelled';

      default:
        return status.toLowerCase();
    }
  }
}
