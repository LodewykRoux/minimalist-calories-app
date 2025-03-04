import 'package:calories_app/http/app_interceptor.dart';
import 'package:dio/dio.dart';

class HttpService {
  static final instance = HttpService._();
  HttpService._();

  late Dio _dio;

  Dio get httpClient => _dio;

  void init({required String baseUrl}) {
    final dio = Dio();

    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(
      seconds: 15,
    ); //15s
    dio.options.receiveTimeout = const Duration(
      seconds: 15,
    );

    dio.interceptors.add(AppInterceptor());

    _dio = dio;
  }
}
