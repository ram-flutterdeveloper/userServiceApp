import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:loader_overlay/loader_overlay.dart';


extension ResponsiveExt on BuildContext {

  bool get isMobile => MediaQuery.of(this).size.shortestSide < 600;
}

extension IntExt on int 
{
  String formatAsK() {
    if (this >= 1000000) {
      return this % 1000000 == 0
          ? '${(this / 1000000).toStringAsFixed(0)}M'
          : '${(this / 1000000).toStringAsFixed(1)}M';
    } else if (this >= 1000) {
      return this % 1000 == 0
          ? '${(this / 1000).toStringAsFixed(0)}K'
          : '${(this / 1000).toStringAsFixed(1)}K';
    }
    return toString();
  }
}

extension ThemeExt on BuildContext {

  TextStyle get titleStyle => GoogleFonts.nunito(
      color: appColor.blackColor, fontSize: 16.sp, fontWeight: FontWeight.w400);

  TextStyle get titleStyleRegular => GoogleFonts.nunito(
      color: appColor.blackColor, fontSize: 19.sp, fontWeight: FontWeight.w600);

  TextStyle get subTitleStyle => GoogleFonts.nunito(
        fontWeight: FontWeight.w500,
        color: appColor.blackColor,
        fontSize: 18.sp,
      );
       TextStyle get buttonTestStyle => GoogleFonts.nunito(
        fontWeight: FontWeight.w600,
        color: appColor.blackColor,
        fontSize: 14.sp,
      );

  TextStyle get subTitleTextStyle => GoogleFonts.nunito(
        fontWeight: FontWeight.w400,
        color: appColor.greyColor,
        fontSize: 16.sp,
      );
  TextStyle get subTitleTextStyleBloack => GoogleFonts.nunito(
        fontWeight: FontWeight.w500,
        color: appColor.blackColor,
        fontSize: 14.sp,
      );

  TextStyle get subTitleTxtStyleblack => GoogleFonts.nunito(
        fontWeight: FontWeight.w400,
        color: appColor.blackColor,
        fontSize: 13.sp,
      );

  TextStyle get subTitleTxtStyle => GoogleFonts.nunito(
        fontWeight: FontWeight.w400,
        color: appColor.greyColor,
        fontSize: 13.sp,
      );

  TextStyle get bodyTxtStyle => GoogleFonts.chivo(
      fontSize: 14.sp, fontWeight: FontWeight.w400, color: appColor.blackColor);

  TextStyle get bodyTxtStyleTwo => GoogleFonts.chivo(
      fontSize: 13.sp,
      fontWeight: FontWeight.w400,
      color: appColor.blackColor,
      decoration: TextDecoration.underline,
      decorationColor: appColor.primary);

  TextStyle get smallTxtStyle => GoogleFonts.chivo(
        color: appColor.blackColor,
        fontSize: 10.sp,
      );

  TextStyle get smallTxtStyleBold => GoogleFonts.chivo(
        color: appColor.blackColor,
        fontSize: 10.sp,
        fontWeight: FontWeight.w500,
      );

  TextStyle get titleTextStyle => GoogleFonts.chivo(
        color: appColor.blackColor,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
      );

  TextStyle get cardTitleStyle => GoogleFonts.chivo(
        color: appColor.blackColor,
        fontSize: 13.76.sp,
        fontWeight: FontWeight.w500,
      );

  TextStyle get cardTitleStyleWhite => GoogleFonts.chivo(
        color: appColor.whiteColor,
        fontSize: 13.76.sp,
        fontWeight: FontWeight.w500,
      );

  TextStyle get dropdownBodyTxtStyle => GoogleFonts.chivo(
        color: appColor.blackColor,
        fontSize: 14.sp,
        fontWeight: FontWeight.w500,
      );

  TextStyle get ratingTextStyle => GoogleFonts.chivo(
        color: appColor.blackColor,
        fontSize: 40.sp,
        fontWeight: FontWeight.w700,
      );

  TextStyle get noReviewYetTextStyle => GoogleFonts.chivo(
        color: appColor.blackColor,
        fontSize: 33.sp,
        fontWeight: FontWeight.w700,
      );

  TextStyle get dropdownTitleTxtStyle => GoogleFonts.chivo(
        color: appColor.blackColor,
        fontSize: 13.sp,
        fontWeight: FontWeight.w500,
      );

  TextStyle get yourTicketTextStyle => GoogleFonts.chivo(
        color: appColor.blackColor,
        fontSize: 13.5.sp,
        fontWeight: FontWeight.bold,
      );

  TextStyle get priceBodyTxtStyle => GoogleFonts.chivo(
        color: appColor.blackColor,
        fontSize: 16.sp,
        fontWeight: FontWeight.w500,
      );

  TextStyle get orderDetailsHeadingTxtStyle => GoogleFonts.chivo(
        color: appColor.blackColor,
        fontSize: 18.sp,
        fontWeight: FontWeight.w500,
      );

  TextStyle get buttonTxtStyle => GoogleFonts.chivo(
        color: appColor.whiteColor,
        fontSize: 15.59.sp,
        fontWeight: FontWeight.w500,
      );

  TextStyle get bottomNavTextStyle => GoogleFonts.chivo(
        fontSize: 9.sp,
        color: appColor.greyColor500,
        fontWeight: FontWeight.w400,
      );

  TextStyle get headingTextStyle => GoogleFonts.chivo(
        fontSize: 20.sp,
        color: appColor.blackColor,
        fontWeight: FontWeight.w500,
      );

  TextStyle get mainHeadingTextStyle => GoogleFonts.chivo(
        fontSize: 35.sp,
        color: appColor.blackColor,
        fontWeight: FontWeight.w500,
      );

  TextStyle get orderConfirmHeadingTextStyle => GoogleFonts.chivo(
        fontSize: 28.sp,
        color: appColor.blackColor,
        fontWeight: FontWeight.w600,
      );
}


extension ContextExtension on BuildContext
 {
  void to({required Widget screen}) {
    Navigator.push(this, MaterialPageRoute(builder: (context) => screen));
  }

 
  void clearAndPush({required String routePath, Object? args})
   {
    while (GoRouter.of(this).canPop()) {
      GoRouter.of(this).pop();
    }
    GoRouter.of(this).pushReplacement(routePath, extra: args);
  }

 
  ColorScheme get appColor => Theme.of(this).colorScheme;


  double get height => MediaQuery.of(this).size.height;

  
  double get width => MediaQuery.of(this).size.width;

 
  BuildContext? getSafeContext() {
    if (mounted) {
      return this;
    }
    return null;
  }

 
  void showLoader({bool show = true}) {
    if (mounted) {
      if (show) {
        loaderOverlay.show();
      } else {
        loaderOverlay.hide();
      }
    }
  }
}

extension DateTimeExtension on DateTime? {
  bool? isAfterOrEqualTo(DateTime dateTime) {
    final date = this;
    if (date != null) {
      final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
      return isAtSameMomentAs | date.isAfter(dateTime);
    }
    return null;
  }



  bool? isBeforeOrEqualTo(DateTime dateTime) {
    final date = this;
    if (date != null) {
      final isAtSameMomentAs = dateTime.isAtSameMomentAs(date);
      return isAtSameMomentAs | date.isBefore(dateTime);
    }
    return null;
  }

  bool? isBetween(DateTime fromDateTime, DateTime toDateTime) {
    final date = this;
    if (date != null) {
      final isAfter = date.isAfterOrEqualTo(fromDateTime) ?? false;
      final isBefore = date.isBeforeOrEqualTo(toDateTime) ?? false;
      return isAfter && isBefore;
    }
    return null;
  }
}




extension ColorExtension on String {
  toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF$hexColor";
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

  void showTopSnackBar2(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: MediaQuery.of(context).padding.top + 20, // below status bar
            left: 16,
            right: 16,
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(8),
              color: Colors.transparent,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  message,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
    );

    // Insert into the overlay
    overlay.insert(overlayEntry);

    // Remove after delay
    Future.delayed(Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }


extension ColorExt on ColorScheme {
  Color get blackColor =>
     const Color(0xff1A1A1A);

  Color get greyColor =>
       const Color(0xffdbdad8);

  Color get greyColor500 =>  Color(0xffbdbcba) ;

  Color get greyColor400 =>
    Colors.grey.shade400 ;

  Color get greyColor200 =>
      Colors.grey.shade200 ;

  Color get greyColor300 =>
     Colors.grey.shade300;

  Color get greyColor100 =>
     Colors.grey.shade100 ;

  Color get greyColor50 =>
    Color(0xffF8F8F8) ;

  Color get lightBlackColor =>
       Colors.black26 ;

  Color get whiteColor =>
      Colors.white ;

  Color get backgroundColor =>
     const Color(0xFF0F0E17);

  Color get transparent => Colors.transparent;

  Color get redColor => Colors.red;

  Color get primarycolor => Color(0xff1f1d2b);

  
  Color get smallTextColor => brightness == Brightness.light
      ? const Color(0xFF6A6A6A)
      : const Color(0xFF6A6A6A);
  Color get darkGreen => brightness == Brightness.light
      ? const Color(0xFF1D713E)
      : const Color(0xFF07E55E);

  Color get lightGreen => brightness == Brightness.light
      ? const Color(0xFFEDF8F1)
      : Colors.greenAccent;

  Color get yellow =>
      brightness == Brightness.light ? const Color(0xFFE9A706) : Colors.yellow;
}




// extension PhoneFormat on String {
//   String phoneFormat({String pattern = 'XXX-XXX-XXXX'}) {
//     final digits = replaceAll(RegExp(r'\D'), '');
//     String result = '';
//     int digitIndex = 0;

//     for (int i = 0; i < pattern.length && digitIndex < digits.length; i++) {
//       if (pattern[i] == 'X') {
//         result += digits[digitIndex];
//         digitIndex++;
//       } else {
//         result += pattern[i];
//       }
//     }

//     return result;
//   }
// }
