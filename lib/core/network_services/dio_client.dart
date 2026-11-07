import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:user_servicehub/core/constants/api.dart';
import 'package:user_servicehub/core/network_services/dev_utils.dart';
import 'package:user_servicehub/core/utils/common_utils.dart';
import 'package:user_servicehub/core/utils/shared_pref_utils.dart';

/// Dio class wrapper for sending api request to the network
class DioClient {
  final Dio _dio;

  DioClient(this._dio) {
    _dio
      ..options.baseUrl = APIURL.BASE_URL
      ..options.connectTimeout = const Duration(seconds: 30)
      ..options.receiveTimeout = const Duration(seconds: 30)
      ..options.responseType = ResponseType.json
      ..options.contentType = Headers.jsonContentType
      ..interceptors.add(
        PrettyDioLogger(requestBody: true, compact: true, request: true),
      )
      ..interceptors.add(_tokenRefreshInterceptor());
    (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (
      HttpClient client,
    ) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };
  }

  /// Automatically refreshes the access token on 401 and retries the request.
  InterceptorsWrapper _tokenRefreshInterceptor() {
    return InterceptorsWrapper(
      onError: (error, handler) async {
        final statusCode = error.response?.statusCode;
        final path = error.requestOptions.path;
        if (statusCode != 401 || path.contains('refresh-token')) {
          handler.next(error);
          return;
        }

        final refreshToken = await SharedPrefUtils.getRefreshToken();
        if (refreshToken == null || refreshToken.isEmpty) {
          handler.next(error);
          return;
        }

        try {
          final res = await _dio.post(
            APIURL.refreshToken,
            data: jsonEncode({"refreshToken": refreshToken}),
            options: Options(contentType: Headers.jsonContentType),
          );
          final data =
              (res.data as Map<String, dynamic>)['data']
                  as Map<String, dynamic>?;
          final newToken = data?['accessToken'] as String?;
          if (newToken == null || newToken.isEmpty) {
            handler.next(error);
            return;
          }

          await SharedPrefUtils.setToken(authToken: newToken);
          final newRefresh = data!['refreshToken'] as String?;
          if (newRefresh != null && newRefresh.isNotEmpty) {
            await SharedPrefUtils.setRefreshToken(refresh_token: newRefresh);
          }

          final requestOptions = error.requestOptions;
          requestOptions.headers['authorization'] = 'Bearer $newToken';
          final response = await _dio.fetch(requestOptions);
          return handler.resolve(response);
        } catch (_) {
          handler.next(error);
        }
      },
    );
  }

  /// Send GET request
  Future<Response> get(
    String url, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    bool hideSoftKeyboard = true,
    required data,
  }) async {
    if (hideSoftKeyboard) {
      // hideKeyBoard();
    }

    print("post request Bearer token: ${await SharedPrefUtils.getToken()}");

    try {
      final Response response = await _dio.get(
        url,
        queryParameters: queryParameters,
        options:
            options ??
            Options(
              headers: {
                "authorization": "Bearer ${await SharedPrefUtils.getToken()}",
              },
            ),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Send POST request
  Future<Response> post(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool hideSoftKeyboard = true,
  }) async {
    if (hideSoftKeyboard) {
      hideKeyBoard();
    }

    print("kjhdfgkjhgdfkhkdfgjh  ${url}");
    debugLog(" post request Bearer token: ${await SharedPrefUtils.getToken()}");
    try {
      final Response response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options:
            options ??
            Options(
              headers: {
                "authorization": "Bearer ${await SharedPrefUtils.getToken()}",
              },
            ),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Send PUT request
  Future<Response> put(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool hideSoftKeyboard = true,
  }) async {
    if (hideSoftKeyboard) {
      hideKeyBoard();
    }
    debugLog("Put Bearer token: ${await SharedPrefUtils.getToken()}");
    try {
      final Response response = await _dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options:
            options ??
            Options(
              headers: {
                "authorization": "Bearer ${await SharedPrefUtils.getToken()}",
              },
            ),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Send PATCH request
  Future<Response> patch(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool hideSoftKeyboard = true,
  }) async {
    if (hideSoftKeyboard) {
      hideKeyBoard();
    }
    debugLog("Put Bearer token: ${await SharedPrefUtils.getToken()}");
    try {
      final Response response = await _dio.patch(
        url,
        data: data,
        queryParameters: queryParameters,
        options:
            options ??
            Options(
              headers: {
                "authorization": "Bearer ${await SharedPrefUtils.getToken()}",
              },
            ),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Send DELETE request
  Future<dynamic> delete(
    String url, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool hideSoftKeyboard = true,
  }) async {
    if (hideSoftKeyboard) {
      hideKeyBoard();
    }
    debugLog("delete Bearer token: ${await SharedPrefUtils.getToken()}");
    try {
      final Response response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options:
            options ??
            Options(
              headers: {
                "authorization": "Bearer ${await SharedPrefUtils.getToken()}",
              },
            ),
        cancelToken: cancelToken,
      );
      return response;

      /// return response.data
    } catch (e) {
      rethrow;
    }
  }

  //Download:--------------------------------------------------------------------
  Future<dynamic> download(
    String url,
    dynamic savePath, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    hideKeyBoard();
    debugLog("Bearer ${await SharedPrefUtils.getToken()}");
    try {
      final Response response = await _dio.download(
        url,
        savePath,
        queryParameters: queryParameters,
        options:
            options ??
            Options(
              headers: {"authorization": await SharedPrefUtils.getToken()},
            ),
        cancelToken: cancelToken,
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> uploadImage(
    String url,
    File imageFile, {
    Map<String, dynamic>? additionalFields,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    bool hideSoftKeyboard = true,
  }) async {
    if (hideSoftKeyboard) {
      hideKeyBoard();
    }

    debugLog("UPLOAD IMAGE Bearer token: ${await SharedPrefUtils.getToken()}");

    try {
      String fileName = imageFile.path.split('/').last;
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
        ...?additionalFields,
      });

      final Response response = await _dio.post(
        url,
        data: formData,
        options:
            options ??
            Options(
              headers: {
                "authorization": "Bearer ${await SharedPrefUtils.getToken()}",
              },
            ),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
