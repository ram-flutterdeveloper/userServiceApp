
import 'dart:convert';

import 'package:user_servicehub/data/models/MyBookingResponse.dart';



class BookingDetailsResponse {
  final bool success;
  final String message;
  final BookingHistoryItem data;

  const BookingDetailsResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory BookingDetailsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return BookingDetailsResponse(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: BookingHistoryItem.fromJson(
        Map<String, dynamic>.from(json['data'] as Map),
      ),
    );
  }

  factory BookingDetailsResponse.fromString(String source) {
    return BookingDetailsResponse.fromJson(
      jsonDecode(source) as Map<String, dynamic>,
    );
  }
}
