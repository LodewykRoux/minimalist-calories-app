import 'dart:convert';
import 'dart:io';

import 'package:calories_app/http/main.dart';
import 'package:calories_app/models/exception/general.dart';
import 'package:calories_app/models/exception/no_internet.dart';
import 'package:calories_app/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class HttpUserService {
  final _loginPath = '/users/login';
  final _validatePath = '/users/validate';
  final _logoutPath = '/users/logout';
  final _signUpPath = '/users/signup';

  Future<User> signUp(
    String name,
    String email,
    String password,
  ) async {
    try {
      final response =
          await HttpService.instance.httpClient.post<Map<String, Object?>>(
        _signUpPath,
        data: json.encode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode != 200) {
        throw GeneralException(
          message: '${response.data}',
        );
      }

      return compute(User.computeSingle, response.data!);
    } on SocketException {
      throw NoInternetException(message: 'No Internet connection');
    } on FormatException {
      throw GeneralException(message: 'Bad response format');
    } on DioException catch (ex) {
      if (ex.error != null && ex.error is! String) throw ex.error!;
      throw GeneralException(message: ex.message ?? 'Unexpected error');
    } catch (ex) {
      throw GeneralException(message: '$ex');
    }
  }

  Future<User> login(String email, String password) async {
    try {
      final response =
          await HttpService.instance.httpClient.post<Map<String, Object?>>(
        _loginPath,
        data: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode != 200) {
        throw GeneralException(
          message: '${response.data}',
        );
      }

      return compute(User.computeSingle, response.data!);
    } on SocketException {
      throw NoInternetException(message: 'No Internet connection');
    } on FormatException {
      throw GeneralException(message: 'Bad response format');
    } on DioException catch (ex) {
      if (ex.error != null && ex.error is! String) throw ex.error!;
      throw GeneralException(message: ex.message ?? 'Unexpected error');
    } catch (ex) {
      throw GeneralException(message: '$ex');
    }
  }

  Future<User> validate(String token) async {
    try {
      final response =
          await HttpService.instance.httpClient.get<Map<String, Object?>>(
        _validatePath,
        data: token,
      );

      if (response.statusCode != 200) {
        throw GeneralException(
          message: '${response.data}',
        );
      }

      return compute(User.computeSingle, response.data!);
    } on FormatException {
      throw GeneralException(message: 'Bad response format');
    } on DioException catch (ex) {
      if (ex.error != null && ex.error is! String) throw ex.error!;
      throw GeneralException(message: ex.message ?? 'Unexpected error');
    } on Exception {
      throw GeneralException(message: 'Unexpected error');
    }
  }

  Future<void> logout() async {
    try {
      final response = await HttpService.instance.httpClient.post<void>(
        _logoutPath,
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw GeneralException(
          message: 'Unexpected error',
        );
      }
    } on SocketException {
      throw NoInternetException(message: 'No Internet connection');
    } on FormatException {
      throw GeneralException(message: 'Bad response format');
    } on DioException catch (ex) {
      if (ex.error != null && ex.error is! String) throw ex.error!;
      throw GeneralException(message: ex.message ?? 'Unexpected error');
    } on Exception {
      throw GeneralException(message: 'Unexpected error');
    }
  }
}
