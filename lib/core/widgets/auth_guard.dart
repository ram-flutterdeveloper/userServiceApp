// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:user_servicehub/core/widgets/login_bottom_sheet.dart';
// import 'package:user_servicehub/data/logic/provider/auth_provider.dart';

// class AuthGuard {
//   AuthGuard._();

//   static Future<bool> requireLogin(BuildContext context) async {
//     final authProvider = context.read<AuthProvider>();

//     print("ksljfkj${authProvider.isLoggedIn}");
//     if (authProvider.isLoggedIn) {
//       return true;
//     }

//     final result = await LoginBottomSheet.show(context);
//     return result == true;
//   }
// }

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:user_servicehub/core/utils/shared_pref_utils.dart';
import 'package:user_servicehub/core/widgets/login_bottom_sheet.dart';
import 'package:user_servicehub/data/logic/provider/auth_provider.dart';

class AuthGuard {
  AuthGuard._();

  static Future<bool> requireLogin(BuildContext context) async {
    final authProvider = context.read<AuthProvider>();

    // 1. Check existing in-memory authentication
    if (authProvider.isLoggedIn) {
      return true;
    }

    // 2. Check persisted token
    final token = await SharedPrefUtils.getToken();

    if (token != null && token.isNotEmpty) {
      // Token exists, so user is already authenticated.
      return true;
    }

    // 3. No token -> show login bottom sheet
    final result = await LoginBottomSheet.show(context);

    return result == true;
  }
}
