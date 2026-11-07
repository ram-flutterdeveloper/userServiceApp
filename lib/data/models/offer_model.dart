class OfferModel {
  final String id;
  final String title;
  final String description;
  final double discountPercentage;
  final double discountAmount;
  final String code;
  final String validUntil;
  final bool isExpiring;
  final int bgColor;
  final String iconName;

  const OfferModel({
    required this.id,
    required this.title,
    required this.description,
    required this.discountPercentage,
    required this.discountAmount,
    required this.code,
    required this.validUntil,
    required this.isExpiring,
    required this.bgColor,
    required this.iconName,
  });

  OfferModel copyWith({
    String? id,
    String? title,
    String? description,
    double? discountPercentage,
    double? discountAmount,
    String? code,
    String? validUntil,
    bool? isExpiring,
    int? bgColor,
    String? iconName,
  }) =>
      OfferModel(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        discountPercentage: discountPercentage ?? this.discountPercentage,
        discountAmount: discountAmount ?? this.discountAmount,
        code: code ?? this.code,
        validUntil: validUntil ?? this.validUntil,
        isExpiring: isExpiring ?? this.isExpiring,
        bgColor: bgColor ?? this.bgColor,
        iconName: iconName ?? this.iconName,
      );
}
