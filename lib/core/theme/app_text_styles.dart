// import 'package:flutter/material.dart';

// class AppTextStyles {
//   AppTextStyles._();

//   static const String _fontFamily = 'RobotoMono';

//   // Display
//   static const TextStyle displayLarge = TextStyle(
//     fontFamily: _fontFamily,
//     fontSize: 34,
//     fontWeight: FontWeight.w700,
//     letterSpacing: -0.5,
//   );

//   static const TextStyle displayMedium = TextStyle(
//     fontFamily: _fontFamily,
//     fontSize: 28,
//     fontWeight: FontWeight.w700,
//     letterSpacing: -0.5,
//   );

//   // Headlines
//   static const TextStyle headlineLarge = TextStyle(
//     fontFamily: _fontFamily,
//     fontSize: 26,
//     fontWeight: FontWeight.w600,
//     letterSpacing: -0.5,
//   );

//   static const TextStyle headlineMedium = TextStyle(
//     fontFamily: _fontFamily,
//     fontSize: 24,
//     fontWeight: FontWeight.w600,
//     letterSpacing: -0.5,
//   );

//   static const TextStyle headlineSmall = TextStyle(
//     fontFamily: _fontFamily,
//     fontSize: 22,
//     fontWeight: FontWeight.w600,
//     letterSpacing: -0.5,
//   );

//   // Titles
//   static const TextStyle titleLarge = TextStyle(
//     fontFamily: _fontFamily,
//     fontSize: 20,
//     fontWeight: FontWeight.w600,
//     letterSpacing: -0.5,
//   );

//   static const TextStyle titleMedium = TextStyle(
//     fontFamily: _fontFamily,
//     fontSize: 18,
//     fontWeight: FontWeight.w600,
//     letterSpacing: -0.5,
//   );

//   static const TextStyle titleSmall = TextStyle(
//     fontFamily: _fontFamily,
//     fontSize: 16,
//     fontWeight: FontWeight.w600,
//     letterSpacing: -0.5,
//   );

//   // Body
//   static const TextStyle bodyLarge = TextStyle(
//     fontFamily: _fontFamily,
//     fontSize: 16,
//     fontWeight: FontWeight.w400,
//     letterSpacing: 0,
//   );

//   static const TextStyle bodyMedium = TextStyle(
//     fontFamily: _fontFamily,
//     fontSize: 14,
//     fontWeight: FontWeight.w400,
//     letterSpacing: 0,
//   );

//   static const TextStyle bodySmall = TextStyle(
//     fontFamily: _fontFamily,
//     fontSize: 12,
//     fontWeight: FontWeight.w400,
//     letterSpacing: 0,
//   );

//   // Labels
//   static const TextStyle labelLarge = TextStyle(
//     fontFamily: _fontFamily,
//     fontSize: 14,
//     fontWeight: FontWeight.w500,
//     letterSpacing: 0.5,
//   );

//   static const TextStyle labelMedium = TextStyle(
//     fontFamily: _fontFamily,
//     fontSize: 12,
//     fontWeight: FontWeight.w500,
//     letterSpacing: 0.5,
//   );

//   static const TextStyle labelSmall = TextStyle(
//     fontFamily: _fontFamily,
//     fontSize: 10,
//     fontWeight: FontWeight.w500,
//     letterSpacing: 0.5,
//   );

//   // Buttons
//   static const TextStyle buttonLarge = TextStyle(
//     fontFamily: _fontFamily,
//     fontSize: 16,
//     fontWeight: FontWeight.w600,
//     letterSpacing: 0,
//   );

//   static const TextStyle buttonMedium = TextStyle(
//     fontFamily: _fontFamily,
//     fontSize: 14,
//     fontWeight: FontWeight.w600,
//     letterSpacing: 0,
//   );

//   // Caption
//   static const TextStyle caption = TextStyle(
//     fontFamily: _fontFamily,
//     fontSize: 11,
//     fontWeight: FontWeight.w400,
//     letterSpacing: 0,
//   );

//   /// Returns a [TextTheme] built from these styles.
//   static TextTheme get textTheme => const TextTheme(
//     displayLarge: displayLarge,
//     displayMedium: displayMedium,
//     headlineLarge: headlineLarge,
//     headlineMedium: headlineMedium,
//     headlineSmall: headlineSmall,
//     titleLarge: titleLarge,
//     titleMedium: titleMedium,
//     titleSmall: titleSmall,
//     bodyLarge: bodyLarge,
//     bodyMedium: bodyMedium,
//     bodySmall: bodySmall,
//     labelLarge: labelLarge,
//     labelMedium: labelMedium,
//     labelSmall: labelSmall,
//   );
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle _font({
    required double fontSize,
    required FontWeight fontWeight,
    double letterSpacing = 0,
  }) {
    return GoogleFonts.robotoMono(
      fontSize: fontSize,
      fontWeight: fontWeight,
      letterSpacing: letterSpacing,
    );
  }

  // Display
  static TextStyle get displayLarge => _font(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      );

  static TextStyle get displayMedium => _font(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      );

  // Headlines
  static TextStyle get headlineLarge => _font(
        fontSize: 26,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      );

  static TextStyle get headlineMedium => _font(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      );

  static TextStyle get headlineSmall => _font(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      );

  // Titles
  static TextStyle get titleLarge => _font(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      );

  static TextStyle get titleMedium => _font(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      );

  static TextStyle get titleSmall => _font(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: -0.5,
      );

  // Body
  static TextStyle get bodyLarge => _font(
        fontSize: 16,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get bodyMedium => _font(
        fontSize: 14,
        fontWeight: FontWeight.w400,
      );

  static TextStyle get bodySmall => _font(
        fontSize: 12,
        fontWeight: FontWeight.w400,
      );

  // Labels
  static TextStyle get labelLarge => _font(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      );

  static TextStyle get labelMedium => _font(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      );

  static TextStyle get labelSmall => _font(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
      );

  // Buttons
  static TextStyle get buttonLarge => _font(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      );

  static TextStyle get buttonMedium => _font(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      );

  // Caption
  static TextStyle get caption => _font(
        fontSize: 11,
        fontWeight: FontWeight.w400,
      );

  static TextTheme get textTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );
}