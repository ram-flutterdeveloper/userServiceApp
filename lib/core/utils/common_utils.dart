import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user_servicehub/core/utils/extensions.dart';
import 'package:user_servicehub/core/utils/globle_variable.dart';


enum SnackType { success, alert, error }

void hideKeyBoard() {
  FocusManager.instance.primaryFocus?.unfocus();
}


Future<void> openMailApp() async {
  final uri = Uri(
    scheme: 'mailto',
    path: 'mepego.com@gmail.com',
    queryParameters: {'subject': 'Support', 'body': 'Hello'},
  );

  final launched = await launchUrl(uri);

  if (!launched) {
    debugPrint("No email app available.");
  }
}

Future<void> saveSilentMode(bool value) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('silentMode', value);
}

Future<bool> loadSilentMode() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('silentMode') ?? false; // default false
}

void showSnackBar({
  BuildContext? context,
  required String message,
  SnackType snackType = SnackType.success,
  bool canDismiss = true,
  bool sticky = false,
  SnackBarBehavior behaviour = SnackBarBehavior.floating,
}) {
  ScaffoldMessenger.of(
    context ?? GlobalVariable.globalScaffoldKey.currentContext!,
  ).clearSnackBars();

  final snackBar = SnackBar(
    behavior: behaviour,
    padding: EdgeInsets.zero,
    elevation: 0,
    content: Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              snackType == SnackType.success
                  ? const [Color(0xFF61B15A), Color(0xFF6ABE8B)]
                  : snackType == SnackType.alert
                  ? const [Color(0xFFFF8906), Color(0xFFFFA745)]
                  : const [Colors.red, Colors.redAccent],
        ),
      ),
      child: Text(
        message,
        style: (context ?? GlobalVariable.globalScaffoldKey.currentContext!)
            .titleStyle
            .copyWith(fontSize: 16.sp, color: Colors.white),
        textAlign: TextAlign.center,
      ),
    ),
    duration: sticky ? const Duration(days: 365) : const Duration(seconds: 3),
    dismissDirection:
        canDismiss ? DismissDirection.down : DismissDirection.none,
  );

  // Find the ScaffoldMessenger in the widget tree
  // and use it to show a SnackBar.
  ScaffoldMessenger.of(
    context ?? GlobalVariable.globalScaffoldKey.currentContext!,
  ).showSnackBar(snackBar);
}

// Format File Size
String getFileSizeString({required int bytes, int decimals = 0}) {
  if (bytes <= 0) {
    return "0";
  }
  const suffixes = ["b", "kb", "mb", "gb", "tb"];
  var i = (math.log(bytes) / math.log(1024)).floor();
  return ((bytes / math.pow(1024, i)).toStringAsFixed(decimals)) + suffixes[i];
}
