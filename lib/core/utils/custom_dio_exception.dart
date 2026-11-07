


import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:user_servicehub/core/utils/response_type_def.dart';

class CustomDioExceptions implements Exception {
  late String message;

  CustomDioExceptions.fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.cancel:
        message = "Request to API server was cancelled";
        break;
      case DioExceptionType.connectionTimeout:
        message = "Connection timeout with API server";
        break;
      case DioExceptionType.receiveTimeout:
        message = "Receive timeout in connection with API server";
        break;
      case DioExceptionType.badResponse:
        message = _handleStatusError(
          dioException.response?.statusCode,
          dioException.response?.data,
        );
        break;
      case DioExceptionType.sendTimeout:
        message = "Send timeout in connection with API server";
        break;
      case DioExceptionType.unknown:
        message = "Unexpected error occurred";
        break;
      default:
        message = "Something went wrong";
        break;
    }
  }

  String _handleStatusError(int? statusCode, dynamic error) {
    // First, try to extract the actual error message from the response
    if (error != null && error is Map<String, dynamic>) {
      final errorMessage = error["message"];
      
      // Handle direct string message: {"message": "User doesn't exist"}
      if (errorMessage is String && errorMessage.isNotEmpty) {
        return errorMessage;
      }
      
      // Handle nested message: {"message": {"message": "actual error"}}
      if (errorMessage is Map<String, dynamic>) {
        final nestedMessage = errorMessage["message"];
        if (nestedMessage is String && nestedMessage.isNotEmpty) {
          return nestedMessage;
        }
      }
      
      // Try other common error fields
      if (error["error"] is String) {
        return error["error"];
      }
      
      if (error["detail"] is String) {
        return error["detail"];
      }
    }

    // Fallback to status code based messages only if no message found in response
    switch (statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized access';
      case 403:
        return 'Forbidden';
      case 404:
        return 'Resource not found';
      case 422:
        return 'Cannot proceed with the data provided';
      case 406:
        return 'Input mismatched';
      case 500:
        return 'Internal server error';
      case 502:
        return 'Bad gateway';
      default:
        return 'Oops something went wrong';
    }
  }

  static CustomError handleError(DioException e) {
    final customException = CustomDioExceptions.fromDioException(e);
    final errorMessage = customException.message;
    
    // Only log in debug mode
    if (kDebugMode) {
      debugPrint("API Error - Status: ${e.response?.statusCode}, Message: $errorMessage");
    }
    
    return CustomError(
      statusCode: e.response?.statusCode ?? 0,
      message: errorMessage,
      error: e.message,
    );
  }

  @override
  String toString() => message;
}
