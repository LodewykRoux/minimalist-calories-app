import 'package:calories_app/http/main.dart';
import 'package:calories_app/models/delete.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

abstract class HttpBaseService<T> {
  @protected
  late final String _path;

  HttpBaseService({
    required String path,
  }) {
    _path = path;
  }

  String get path => _path;
  Dio get client => HttpService.instance.httpClient;

  Future<List<T>> getList();
  Future<T> save(T upsert);
  Future<Delete> delete(int id);
}
