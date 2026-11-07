import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/utils/currency_formatter.dart';
import 'package:user_servicehub/core/widgets/login_required_sheet.dart';
import 'package:user_servicehub/data/logic/provider/address_provider.dart';
import 'package:user_servicehub/data/logic/provider/booking_provider.dart';
import 'package:user_servicehub/data/logic/provider/package_provider.dart';
import 'package:user_servicehub/data/models/offer_model.dart';
import 'package:user_servicehub/data/mock/mock_professionals.dart';
import 'package:user_servicehub/data/mock/mock_offers.dart';
import 'package:user_servicehub/features/booking/widgets/date_selector.dart';
import 'package:user_servicehub/features/booking/widgets/time_slot_grid.dart';
import 'package:user_servicehub/features/booking/widgets/address_selector.dart';
import 'package:user_servicehub/features/payment/payment_page.dart';
import 'package:user_servicehub/features/profile/widgets/add_address_page.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({
    super.key,
    this.packageId,
    this.packageName,
    this.packagePrice,
  });

  final String? packageId;
  final String? packageName;
  final String? packagePrice;

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _couponController = TextEditingController();
  final _instructionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _checkGuestMode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.packageId != null) {
        context.read<BookingProvider>().setPackage(
          id: widget.packageId!,
          name: widget.packageName,
          price: widget.packagePrice,
        );
      }
      context.read<AddressProvider>().fetchAddresses();
      context.read<BookingProvider>().fetchTimeSlot(context);
    });
  }

  @override
  void dispose() {
    _couponController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _checkGuestMode() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('guest_mode') == true && mounted) {
      LoginRequiredSheet.show(context);
    }
  }

  void _showAvailableCoupons() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppDimensions.radiusBottomSheet),
          topRight: Radius.circular(AppDimensions.radiusBottomSheet),
        ),
      ),
      builder:
          (ctx) => SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    'Available Coupons',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...mockOffers.map((offer) => _offerCard(offer)),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
    );
  }

  Widget _offerCard(OfferModel offer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Color(offer.bgColor).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: Color(offer.bgColor).withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Color(offer.bgColor).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            child: Icon(
              Icons.local_offer_rounded,
              color: Color(offer.bgColor),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  offer.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(offer.bgColor),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  offer.description,
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Color(offer.bgColor).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'CODE: ${offer.code}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(offer.bgColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (offer.isExpiring)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Expiring',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: AppColors.error,
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _proceedToPayment() {
    final booking = context.read<BookingProvider>();

    if (!booking.validateSelections()) {
      if (booking.selectedAddressId == null) {
        _showError('Please select an address');
      } else if (booking.selectedDateIndex == null) {
        _showError('Please select a date');
      } else if (booking.selectedTimeSlot == null) {
        _showError('Please select a time slot');
      } else if (!booking.autoAssignProfessional &&
          booking.selectedProfessionalId == null) {
        _showError('Please select a professional');
      }
      return;
    }

    final addresses = context.read<AddressProvider>().addresses;
    final selectedAddress = addresses.firstWhere(
      (a) => a.id == booking.selectedAddressId,
      orElse: () => addresses.first,
    );

    final now = DateTime.now();
    final selectedDate = DateTime(
      now.year,
      now.month,
      now.day + (booking.selectedDateIndex ?? 0),
    );

    final formatter = DateFormat('dd MMM yyyy');
    final professional =
        booking.autoAssignProfessional
            ? null
            : mockProfessionals.firstWhere(
              (p) => p.id == booking.selectedProfessionalId,
              orElse: () => mockProfessionals.first,
            );

    final bookingData = <String, dynamic>{
      'packageId': booking.packageId,
      'serviceCharge': BookingProvider.serviceCharge,
      'platformFee': BookingProvider.platformFee,
      'gst': booking.gst,
      'discount': booking.discount,
      'total': booking.total.floor(),
      'date': formatter.format(selectedDate),
      'timeSlot': booking.selectedTimeSlot,
      'address': '${selectedAddress.addressLine}, ${selectedAddress.houseNo}',
      'providerName': professional?.name ?? 'Best Available Professional',
      'providerId': professional?.id ?? 'auto',
      'notes': _instructionsController.text,
      'specialInstructions':
          _instructionsController.text.isNotEmpty
              ? _instructionsController.text
              : null,
      'couponApplied': booking.isCouponApplied ? 'SAVE20' : null,
    };
    Get.to(() => PaymentPage(bookingData: bookingData));

    // context.push('/payment', extra: bookingData);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Book Service',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Consumer<BookingProvider>(
        builder: (context, booking, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('Select Address'),
                const SizedBox(height: 12),
                AddressSelector(
                  addresses: context.watch<AddressProvider>().addresses,
                  selectedId: booking.selectedAddressId,
                  onSelected: (id) => booking.setSelectedAddress(id),
                  onAddNew: () => Get.to(() => AddAddressPage()),
                  // context.push('/add-address'),
                ),
                // const SizedBox(height: 12),
                // _buildMapPreview(),
                const SizedBox(height: 24),
                _buildSectionHeader('Select Date'),
                const SizedBox(height: 12),
                DateSelector(
                  selectedDate: booking.selectedDateIndex,
                  onDateSelected: (index) => booking.setSelectedDate(index),
                ),
                const SizedBox(height: 24),
                _buildSectionHeader('Select Time Slot'),
                const SizedBox(height: 12),
                TimeSlotGrid(
                  selectedSlot: booking.selectedTimeSlot,
                  onSlotSelected:
                      (slot) => booking.setSelectedTimeSlot(
                        slot.bookingTime,
                        slotId: slot.id,
                      ),
                  unavailableSlots: booking.unavailableSlots,
                  timeSlotlist: context.read<BookingProvider>().timeSlotlist,
                ),
                const SizedBox(height: 24),
                _buildSectionHeader('Professional'),
                const SizedBox(height: 12),
                _buildProfessionalSection(booking),
                // const SizedBox(height: 24),
                // _buildCouponSection(booking),
                const SizedBox(height: 24),
                _buildSectionHeader('Special Instructions'),
                const SizedBox(height: 12),
                _buildInstructionsSection(),
                const SizedBox(height: 24),
                _buildPriceBreakdown(booking),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Consumer<BookingProvider>(
        builder: (context, booking, _) {
          return Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            decoration: BoxDecoration(
              color: AppColors.surface,
              boxShadow: [
                BoxShadow(
                  color: AppColors.border,
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton.icon(
                  onPressed: _proceedToPayment,
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  label: Text(
                    'Proceed to Payment - ${CurrencyFormatter.formatIndianRupees(booking.total)}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusButton,
                      ),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildMapPreview() {
    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        gradient: const LinearGradient(
          colors: [Color(0xFFE8F0FE), Color(0xFFD6E4FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.4)),
      ),
      child: Stack(
        children: [
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusFull,
                    ),
                  ),
                  child: const Icon(
                    Icons.map_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Map Preview',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
                border: Border.all(
                  color: AppColors.border.withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_outlined, size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(
                    'Change',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
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

  Widget _buildProfessionalSection(BookingProvider booking) {
    return Column(
      children: [
        GestureDetector(
          onTap:
              () => booking.setAutoAssignProfessional(
                !booking.autoAssignProfessional,
              ),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color:
                  booking.autoAssignProfessional
                      ? AppColors.primaryLight
                      : AppColors.surface,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
              border: Border.all(
                color:
                    booking.autoAssignProfessional
                        ? AppColors.primary
                        : AppColors.border.withValues(alpha: 0.4),
                width: booking.autoAssignProfessional ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color:
                        booking.autoAssignProfessional
                            ? AppColors.primary.withValues(alpha: 0.12)
                            : AppColors.border.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(
                      AppDimensions.radiusSmall,
                    ),
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color:
                        booking.autoAssignProfessional
                            ? AppColors.primary
                            : AppColors.textTertiary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Auto-assign best professional',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color:
                              booking.autoAssignProfessional
                                  ? AppColors.primary
                                  : AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'We\'ll assign the highest rated available expert',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Radio<bool>(
                  value: true,
                  groupValue: booking.autoAssignProfessional,
                  onChanged: (v) {
                    if (v != null) booking.setAutoAssignProfessional(v);
                  },
                  activeColor: AppColors.primary,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
          ),
        ),

        // ...mockProfessionals.map((pro) {
        //   final isSelected =
        //       booking.selectedProfessionalId == pro.id &&
        //       !booking.autoAssignProfessional;
        //   return Padding(
        //     padding: const EdgeInsets.only(bottom: 10),
        //     child: GestureDetector(
        //       onTap: () => booking.selectProfessional(pro.id),
        //       child: AnimatedContainer(
        //         duration: const Duration(milliseconds: 200),
        //         padding: const EdgeInsets.all(14),
        //         decoration: BoxDecoration(
        //           color: AppColors.surface,
        //           borderRadius: BorderRadius.circular(
        //             AppDimensions.radiusMedium,
        //           ),
        //           border: Border.all(
        //             color:
        //                 isSelected
        //                     ? AppColors.primary
        //                     : AppColors.border.withValues(alpha: 0.4),
        //             width: isSelected ? 1.5 : 1,
        //           ),
        //         ),
        //         child: Row(
        //           children: [
        //             CircleAvatar(
        //               radius: 22,
        //               backgroundColor: AppColors.border.withValues(alpha: 0.5),
        //               child: Icon(
        //                 Icons.person_rounded,
        //                 color: AppColors.textTertiary,
        //                 size: 22,
        //               ),
        //             ),
        //             const SizedBox(width: 14),
        //             Expanded(
        //               child: Column(
        //                 crossAxisAlignment: CrossAxisAlignment.start,
        //                 children: [
        //                   Row(
        //                     children: [
        //                       Text(
        //                         pro.name,
        //                         style: TextStyle(
        //                           fontSize: 14,
        //                           fontWeight: FontWeight.w700,
        //                           color: AppColors.textPrimary,
        //                         ),
        //                       ),
        //                       if (pro.isVerified) ...[
        //                         const SizedBox(width: 6),
        //                         Icon(
        //                           Icons.verified_rounded,
        //                           size: 14,
        //                           color: AppColors.primary,
        //                         ),
        //                       ],
        //                     ],
        //                   ),
        //                   const SizedBox(height: 4),
        //                   Row(
        //                     children: [
        //                       Icon(
        //                         Icons.star_rounded,
        //                         color: AppColors.accent,
        //                         size: 14,
        //                       ),
        //                       const SizedBox(width: 2),
        //                       Text(
        //                         pro.rating.toString(),
        //                         style: TextStyle(
        //                           fontSize: 12,
        //                           fontWeight: FontWeight.w600,
        //                           color: AppColors.textPrimary,
        //                         ),
        //                       ),
        //                       const SizedBox(width: 8),
        //                       Container(
        //                         width: 1,
        //                         height: 10,
        //                         color: AppColors.border,
        //                       ),
        //                       const SizedBox(width: 8),
        //                       Text(
        //                         '${pro.experience} yrs',
        //                         style: TextStyle(
        //                           fontSize: 11,
        //                           color: AppColors.textSecondary,
        //                         ),
        //                       ),
        //                       const SizedBox(width: 8),
        //                       Container(
        //                         width: 1,
        //                         height: 10,
        //                         color: AppColors.border,
        //                       ),
        //                       const SizedBox(width: 8),
        //                       Text(
        //                         '${pro.jobsCompleted} jobs',
        //                         style: TextStyle(
        //                           fontSize: 11,
        //                           color: AppColors.textSecondary,
        //                         ),
        //                       ),
        //                     ],
        //                   ),
        //                 ],
        //               ),
        //             ),
        //             Text(
        //               CurrencyFormatter.formatIndianRupees(pro.basePrice),
        //               style: TextStyle(
        //                 fontSize: 14,
        //                 fontWeight: FontWeight.w700,
        //                 color: AppColors.primary,
        //               ),
        //             ),
        //             Radio<String>(
        //               value: pro.id,
        //               groupValue:
        //                   booking.autoAssignProfessional
        //                       ? null
        //                       : booking.selectedProfessionalId,
        //               onChanged: (v) {
        //                 if (v != null) booking.selectProfessional(v);
        //               },
        //               activeColor: AppColors.primary,
        //               materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        //             ),
        //           ],
        //         ),
        //       ),
        //     ),
        //   );
        // }),
      ],
    );
  }

  Widget _buildCouponSection(BookingProvider booking) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.accentLight,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusSmall,
                  ),
                ),
                child: const Icon(
                  Icons.discount_rounded,
                  color: AppColors.accent,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Add Coupon',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _showAvailableCoupons,
                child: Text(
                  'Available Coupons',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.chevron_right, size: 16, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 12),
          if (booking.isCouponApplied)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.secondaryLight.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                border: Border.all(color: AppColors.secondaryLight),
              ),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Coupon Applied - SAVE20',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.secondary,
                          ),
                        ),
                        Text(
                          '20% discount applied',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      booking.removeCoupon();
                      _couponController.clear();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryLight,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusSmall,
                        ),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: AppColors.secondary,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.border.withValues(alpha: 0.4),
                      ),
                      borderRadius: BorderRadius.circular(
                        AppDimensions.radiusSmall,
                      ),
                    ),
                    child: TextField(
                      controller: _couponController,
                      decoration: InputDecoration(
                        hintText: 'Enter coupon code',
                        hintStyle: TextStyle(
                          fontSize: 13,
                          color: AppColors.textTertiary.withValues(alpha: 0.6),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                        ),
                        border: InputBorder.none,
                      ),
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                      ),
                      textCapitalization: TextCapitalization.characters,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 46,
                  child: FilledButton(
                    onPressed: () {
                      final code = _couponController.text.trim().toUpperCase();
                      if (code.isNotEmpty) {
                        booking.applyCoupon(code);
                        if (!booking.isCouponApplied) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Invalid coupon code'),
                            ),
                          );
                        }
                      }
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusSmall,
                        ),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    child: const Text(
                      'Apply',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildInstructionsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.border.withValues(alpha: 0.4),
              ),
              borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
            ),
            child: TextField(
              controller: _instructionsController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Add any special instructions...',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: AppColors.textTertiary.withValues(alpha: 0.6),
                ),
                contentPadding: const EdgeInsets.all(14),
                border: InputBorder.none,
              ),
              style: TextStyle(fontSize: 13, color: AppColors.textPrimary),
            ),
          ),
          const SizedBox(height: 12),

          // Row(
          //   children: [
          //     Expanded(
          //       child: OutlinedButton.icon(
          //         onPressed: () {
          //           ScaffoldMessenger.of(context).showSnackBar(
          //             const SnackBar(
          //               content: Text('Image upload feature coming soon'),
          //             ),
          //           );
          //         },
          //         icon: const Icon(Icons.image_outlined, size: 18),
          //         label: const Text('Upload Image'),
          //         style: OutlinedButton.styleFrom(
          //           foregroundColor: AppColors.textSecondary,
          //           side: BorderSide(
          //             color: AppColors.border.withValues(alpha: 0.4),
          //           ),
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(
          //               AppDimensions.radiusSmall,
          //             ),
          //           ),
          //           padding: const EdgeInsets.symmetric(vertical: 12),
          //         ),
          //       ),
          //     ),
          //     const SizedBox(width: 10),
          //     Expanded(
          //       child: OutlinedButton.icon(
          //         onPressed: () {
          //           ScaffoldMessenger.of(context).showSnackBar(
          //             const SnackBar(
          //               content: Text('Voice note feature coming soon'),
          //             ),
          //           );
          //         },
          //         icon: const Icon(Icons.mic_rounded, size: 18),
          //         label: const Text('Add Voice Note'),
          //         style: OutlinedButton.styleFrom(
          //           foregroundColor: AppColors.textSecondary,
          //           side: BorderSide(
          //             color: AppColors.border.withValues(alpha: 0.4),
          //           ),
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(
          //               AppDimensions.radiusSmall,
          //             ),
          //           ),
          //           padding: const EdgeInsets.symmetric(vertical: 12),
          //         ),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildPriceBreakdown(BookingProvider booking) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusSmall,
                  ),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: AppColors.primary,
                  size: 16,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Price Breakdown',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _priceRow(
            'Service Charge',
            CurrencyFormatter.formatIndianRupees(BookingProvider.serviceCharge),
          ),
          const SizedBox(height: 8),
          _priceRow(
            'Platform Fee',
            CurrencyFormatter.formatIndianRupees(BookingProvider.platformFee),
          ),
          const SizedBox(height: 8),
          _priceRow(
            'GST (18%)',
            CurrencyFormatter.formatIndianRupees(booking.gst),
          ),
          if (booking.discount > 0) ...[
            const SizedBox(height: 8),
            _priceRow(
              'Discount (20%)',
              '-${CurrencyFormatter.formatIndianRupees(booking.discount)}',
              color: AppColors.success,
            ),
          ],
          const SizedBox(height: 12),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                CurrencyFormatter.formatIndianRupees(booking.total),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String amount, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        Text(
          amount,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: color ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
