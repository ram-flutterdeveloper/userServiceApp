import 'dart:developer';

import 'package:flutter/foundation.dart';

/// All the required utilities which helps in the development of the project

void debugLog(String? text) {
  if (kDebugMode) {
    log("##################\n$text\n>>>>>>>>>>>>>>>>>");
  }
}
