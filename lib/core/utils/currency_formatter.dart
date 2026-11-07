class CurrencyFormatter {
  CurrencyFormatter._();

  /// Formats the given [amount] into Indian Rupee format.
  ///
  /// Accepts [int], [double], or [String] and returns a string like
  /// "₹499", "₹1,299", "₹2,49,999".
  static String formatIndianRupees(dynamic amount) {
    if (amount == null) return '₹0';

    double value;
    if (amount is int) {
      value = amount.toDouble();
    } else if (amount is double) {
      value = amount;
    } else if (amount is String) {
      value = double.tryParse(amount) ?? 0.0;
    } else {
      return '₹0';
    }

    if (value.isNaN || value.isInfinite) return '₹0';

    final wholePart = value.floor();
    final hasDecimal = (value - wholePart) > 0.01;
    final decimalStr = hasDecimal
        ? ((value - wholePart) * 100).round().toString().padLeft(2, '0')
        : null;

    final wholeStr = _formatIndianNumber(wholePart);

    if (decimalStr != null) {
      return '₹$wholeStr.$decimalStr';
    }
    return '₹$wholeStr';
  }

  /// Formats a number using the Indian numbering system (lakhs, crores).
  static String _formatIndianNumber(int number) {
    if (number < 0) {
      return '-${_formatIndianNumber(-number)}';
    }

    final numStr = number.toString();
    if (numStr.length <= 3) return numStr;

    // Split: last 3 digits form the rightmost group
    final lastThree = numStr.substring(numStr.length - 3);
    final rest = numStr.substring(0, numStr.length - 3);

    // Remaining digits in groups of 2
    final buffer = StringBuffer();
    buffer.write(rest[0]);
    for (int i = 1; i < rest.length; i++) {
      if ((rest.length - i) % 2 == 0) {
        buffer.write(',');
      }
      buffer.write(rest[i]);
    }
    buffer.write(',');
    buffer.write(lastThree);
    return buffer.toString();
  }
}
