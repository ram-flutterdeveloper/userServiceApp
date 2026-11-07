


import 'package:fpdart/fpdart.dart';

typedef FutureResult<T> = Future<Either<CustomError, T>>;
typedef VoidResult<Void> = Future<Either<CustomError, Void>>;

class CustomError {
  final int statusCode;
  final String message;
  final String? error;

  CustomError({
    required this.statusCode,
    required this.message,
    this.error,
  });

  factory CustomError.fromJson(Map<String, dynamic> json) {
    return CustomError(
      statusCode: json['statusCode'] ?? 0,
      message: json['message'] is Map
          ? json['message']['message'] ?? "Unknown error"
          : json['message']?.toString() ?? "Unknown error",
      error: json['message'] is Map ? json['message']['error'] : null,
    );
  }

  @override
  String toString() => message; // Return just the message for display
}
