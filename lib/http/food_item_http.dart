import 'dart:convert';

import 'package:calories_app/http/base.dart';
import 'package:calories_app/models/delete.dart';
import 'package:calories_app/models/exception/general.dart';
import 'package:calories_app/models/food_item.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class HttpFoodItemService extends HttpBaseService<FoodItem> {
  HttpFoodItemService({
    super.path = '/food/',
  });

  @override
  Future<List<FoodItem>> getList([CancelToken? cancelToken]) async {
    try {
      final response = await client.get<List<Object?>>(
        '${path}getList',
        cancelToken: cancelToken,
      );

      if (response.statusCode != 200) {
        throw GeneralException(
          message: '${response.data}',
        );
      }

      return compute(FoodItem.computeMultiple, response.data!);
    } on FormatException {
      throw GeneralException(message: 'Bad response format');
    } on DioException catch (ex) {
      if (ex.error != null && ex.error is! String) throw ex.error!;
      throw GeneralException(message: ex.message ?? 'Unexpected error');
    } on Exception {
      throw GeneralException(message: 'Unexpected error');
    }
  }

  @override
  Future<FoodItem> save(FoodItem upsert) async {
    try {
      final save = upsert.toJson();
      final response = await client.post<Map<String, Object?>>(
        '${path}save',
        data: save,
      );

      if (response.statusCode != 200) {
        throw GeneralException(
          message: '${response.data}',
        );
      }

      return compute(FoodItem.computeSingle, response.data!);
    } on FormatException {
      throw GeneralException(message: 'Bad response format');
    } on DioException catch (ex) {
      if (ex.error != null && ex.error is! String) throw ex.error!;
      throw GeneralException(message: ex.message ?? 'Unexpected error');
    } on Exception {
      throw GeneralException(message: 'Unexpected error');
    }
  }

  @override
  Future<Delete> delete(int id) async {
    try {
      final response = await client.delete<Map<String, Object?>>(
        '${path}delete',
        data: jsonEncode({'id': id}),
      );

      if (response.statusCode != 200) {
        throw GeneralException(
          message: '${response.data}',
        );
      }

      return compute(Delete.computeSingle, response.data!);
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
