import 'package:flutter/material.dart';
import 'package:user_servicehub/core/constants/app_colors.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/theme/app_text_styles.dart';

class FaqPage extends StatefulWidget {
  const FaqPage({super.key});

  @override
  State<FaqPage> createState() => _FaqPageState();
}

class _FaqPageState extends State<FaqPage> {
  int? _expandedIndex;
  final TextEditingController _searchController = TextEditingController();
  final List<_FaqItem> _allFaqs = [
    _FaqItem(
      question: 'How do I book a service?',
      answer: 'Simply browse through our service categories, select the service you need, choose your preferred package (Basic, Standard, or Premium), select a date and time slot, and proceed to payment. Once confirmed, a professional will be assigned and will arrive at your location at the scheduled time. You can track your booking status in the "My Bookings" section.',
    ),
    _FaqItem(
      question: 'Can I reschedule my booking?',
      answer: 'Yes, you can reschedule your booking up to 2 hours before the scheduled time. To reschedule, go to "My Bookings", select the booking you wish to modify, and tap on "Reschedule". You can choose a new date and time based on availability. Rescheduling is free of charge for all bookings.',
    ),
    _FaqItem(
      question: 'What if I need to cancel?',
      answer: 'Free cancellation is available up to 24 hours before the scheduled service time. If you cancel between 2 to 24 hours before the appointment, a nominal cancellation fee of 10% of the booking amount will be charged. Cancellations made less than 2 hours before the scheduled time may incur a 25% fee. Refunds are processed within 5-7 business days.',
    ),
    _FaqItem(
      question: 'Are the professionals verified?',
      answer: 'Absolutely! All ServiceHub professionals undergo a thorough verification process that includes identity verification, background checks, skill assessments, and in-person interviews. We also review their work history and customer ratings before onboarding. Only professionals who meet our high standards are allowed to offer services on our platform.',
    ),
    _FaqItem(
      question: 'What payment methods are accepted?',
      answer: 'We accept a wide range of payment methods including UPI (Google Pay, PhonePe, Paytm), Credit Cards (Visa, Mastercard, RuPay), Debit Cards, Net Banking (all major banks), ServiceHub Wallet, and Cash After Service. All payments are processed through secure, encrypted gateways to ensure your financial information is protected.',
    ),
    _FaqItem(
      question: 'Is there a satisfaction guarantee?',
      answer: 'Yes, we stand behind the quality of our services. If you are not satisfied with the work done, we offer a free re-service or a full refund within 48 hours of service completion. Simply contact our support team with your booking details and we will make it right. Our goal is your complete satisfaction.',
    ),
    _FaqItem(
      question: 'How are pricing determined?',
      answer: 'Pricing is based on several factors including the type of service, the package selected (Basic, Standard, Premium), the duration of the service, and any additional add-ons or materials required. All prices are displayed transparently before you confirm your booking. There are no hidden charges or surprise fees.',
    ),
    _FaqItem(
      question: 'Can I request a specific professional?',
      answer: 'Yes, you can select your preferred professional during the booking process. You can view professional profiles including their ratings, reviews, experience, and specialization. If your preferred professional is available, they will be assigned to your booking. You can also mark professionals as favorites for quicker booking in the future.',
    ),
  ];

  List<_FaqItem> get _filteredFaqs {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return _allFaqs;
    return _allFaqs.where((faq) =>
      faq.question.toLowerCase().contains(query) ||
      faq.answer.toLowerCase().contains(query),
    ).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title:  Text('FAQs', style: AppTextStyles.titleLarge),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppDimensions.spacing16,
              AppDimensions.spacing16,
              AppDimensions.spacing16,
              0,
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search FAQs...',
                hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textTertiary),
                prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary, size: 22),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.close, color: AppColors.textTertiary, size: 20),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
                  borderSide: BorderSide(color: AppColors.border.withValues(alpha: 0.3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
                  borderSide: BorderSide(color: AppColors.border.withValues(alpha: 0.3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusInput),
                  borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppDimensions.spacing16),
          Expanded(
            child: _filteredFaqs.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                          ),
                          child: const Icon(
                            Icons.search_off,
                            size: 32,
                            color: AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(height: AppDimensions.spacing16),
                         Text(
                          'No FAQs found',
                          style: AppTextStyles.bodyLarge,
                        ),
                        const SizedBox(height: AppDimensions.spacing8),
                        Text(
                          'Try searching with different keywords.',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(
                      AppDimensions.spacing16,
                      0,
                      AppDimensions.spacing16,
                      AppDimensions.spacing16,
                    ),
                    itemCount: _filteredFaqs.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppDimensions.spacing8),
                    itemBuilder: (_, i) {
                      final faq = _filteredFaqs[i];
                      final isExpanded = _expandedIndex == i;
                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                          border: Border.all(
                            color: AppColors.border.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _expandedIndex = isExpanded ? null : i;
                                });
                              },
                              borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
                              child: Padding(
                                padding: const EdgeInsets.all(AppDimensions.spacing16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        faq.question,
                                        style: AppTextStyles.titleSmall.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: AppDimensions.spacing8),
                                    AnimatedRotation(
                                      turns: isExpanded ? 0.5 : 0,
                                      duration: const Duration(milliseconds: 200),
                                      child: Icon(
                                        Icons.expand_more,
                                        color: AppColors.textTertiary,
                                        size: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            AnimatedCrossFade(
                              firstChild: const SizedBox.shrink(),
                              secondChild: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  AppDimensions.spacing16,
                                  0,
                                  AppDimensions.spacing16,
                                  AppDimensions.spacing16,
                                ),
                                child: Text(
                                  faq.answer,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                    height: 1.6,
                                  ),
                                ),
                              ),
                              crossFadeState: isExpanded
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              duration: const Duration(milliseconds: 300),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FaqItem {
  final String question;
  final String answer;

  _FaqItem({required this.question, required this.answer});
}
