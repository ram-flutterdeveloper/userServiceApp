class PaymentMethodModel {
  final String id;
  final String type;
  final String name;
  final String lastFour;
  final bool isDefault;
  final String iconName;
  final String? upiId;

  const PaymentMethodModel({
    required this.id,
    required this.type,
    required this.name,
    required this.lastFour,
    required this.isDefault,
    required this.iconName,
    this.upiId,
  });

  PaymentMethodModel copyWith({
    String? id,
    String? type,
    String? name,
    String? lastFour,
    bool? isDefault,
    String? iconName,
    String? upiId,
  }) =>
      PaymentMethodModel(
        id: id ?? this.id,
        type: type ?? this.type,
        name: name ?? this.name,
        lastFour: lastFour ?? this.lastFour,
        isDefault: isDefault ?? this.isDefault,
        iconName: iconName ?? this.iconName,
        upiId: upiId ?? this.upiId,
      );
}
