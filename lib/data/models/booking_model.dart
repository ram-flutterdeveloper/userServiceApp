class BookingModel {
  final String id;
  final String serviceId;
  final String serviceName;
  final String serviceImage;
  final String providerName;
  final String providerId;
  final String providerPhone;
  final String date;
  final String timeSlot;
  final String address;
  final String status;
  final double totalAmount;
  final String paymentMethod;
  final String? couponApplied;
  final String? specialInstructions;

  const BookingModel({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.serviceImage,
    required this.providerName,
    required this.providerId,
    required this.providerPhone,
    required this.date,
    required this.timeSlot,
    required this.address,
    required this.status,
    required this.totalAmount,
    required this.paymentMethod,
    this.couponApplied,
    this.specialInstructions,
  });

  BookingModel copyWith({
    String? id,
    String? serviceId,
    String? serviceName,
    String? serviceImage,
    String? providerName,
    String? providerId,
    String? providerPhone,
    String? date,
    String? timeSlot,
    String? address,
    String? status,
    double? totalAmount,
    String? paymentMethod,
    String? couponApplied,
    String? specialInstructions,
  }) =>
      BookingModel(
        id: id ?? this.id,
        serviceId: serviceId ?? this.serviceId,
        serviceName: serviceName ?? this.serviceName,
        serviceImage: serviceImage ?? this.serviceImage,
        providerName: providerName ?? this.providerName,
        providerId: providerId ?? this.providerId,
        providerPhone: providerPhone ?? this.providerPhone,
        date: date ?? this.date,
        timeSlot: timeSlot ?? this.timeSlot,
        address: address ?? this.address,
        status: status ?? this.status,
        totalAmount: totalAmount ?? this.totalAmount,
        paymentMethod: paymentMethod ?? this.paymentMethod,
        couponApplied: couponApplied ?? this.couponApplied,
        specialInstructions: specialInstructions ?? this.specialInstructions,
      );
}
