import 'package:calories_app/models/exception/bad_request.dart';
import 'package:calories_app/models/exception/cancel_request.dart';
import 'package:calories_app/models/exception/general.dart';
import 'package:calories_app/models/exception/no_internet.dart';
import 'package:calories_app/models/exception/unauthorized.dart';
import 'package:calories_app/service/secure_storage_service.dart';
import 'package:dio/dio.dart';

class AppInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SecureStorageService.instance.accessToken;

    if (token?.isNotEmpty == true) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Remove null values from params, http does not handle it correctly.
    options.queryParameters.removeWhere((key, value) {
      if (value is List) return value.contains('null');

      return false;
    });

    return super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    if (response.statusCode == 401) {
      return handler.reject(
        DioException(
          error: UnauthorisedException(
            message: 'Unauthorised',
          ),
          requestOptions: response.requestOptions,
          response: response,
        ),
      );
    }

    return super.onResponse(response, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if ([
      DioExceptionType.connectionTimeout,
      DioExceptionType.connectionError,
    ].contains(err.type)) {
      return handler.reject(
        DioException(
          error: NoInternetException(message: 'No Internet'),
          requestOptions: err.requestOptions,
          response: err.response,
        ),
      );
    }

    if (err.response?.statusCode == 500) {
      return handler.reject(
        DioException(
          error: GeneralException(message: 'Internal Server Error'),
          requestOptions: err.requestOptions,
          response: err.response,
        ),
      );
    }

    if (err.type == DioExceptionType.cancel) {
      return handler.reject(
        DioException(
          error: CancelRequestException(message: ''),
          requestOptions: err.requestOptions,
          response: err.response,
        ),
      );
    }

    if (err.response?.statusCode == 400) {
      return handler.reject(
        DioException(
          error: BadRequestException(message: err.response?.data),
          requestOptions: err.requestOptions,
          response: err.response,
        ),
      );
    }

    if (err.response?.statusCode == 401) {
      return handler.reject(
        DioException(
          error: UnauthorisedException(message: err.response?.data),
          requestOptions: err.requestOptions,
          response: err.response,
        ),
      );
    }

    return super.onError(err, handler);
  }
}
