import 'package:flutter_test/flutter_test.dart';
import 'package:user_servicehub/core/constants/app_strings.dart';
import 'package:user_servicehub/core/constants/app_dimensions.dart';
import 'package:user_servicehub/core/utils/currency_formatter.dart';
import 'package:user_servicehub/core/utils/validators.dart';

void main() {
  test('AppStrings should have appName', () {
    expect(AppStrings.appName, 'ServiceHub');
  });

  test('CurrencyFormatter formats correctly', () {
    expect(CurrencyFormatter.formatIndianRupees(499), '₹499');
    expect(CurrencyFormatter.formatIndianRupees(1299), '₹1,299');
  });

  test('Validators validate phone correctly', () {
    expect(Validators.validatePhone('9876543210'), isNull);
    expect(Validators.validatePhone('12345'), isNotNull);
  });

  test('AppDimensions spacing should follow 8pt grid', () {
    expect(AppDimensions.spacing8, 8);
    expect(AppDimensions.spacing16, 16);
  });
}
