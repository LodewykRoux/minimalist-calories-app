import 'dart:collection';
import 'package:calories_app/http/food_item_http.dart';
import 'package:calories_app/models/food_item.dart';
import 'package:calories_app/service/scaffold_messenger_service.dart';
import 'package:flutter/foundation.dart';

class FoodItemProvider extends ChangeNotifier {
  final List<FoodItem> _list = [];
  bool _isLoading = false;

  UnmodifiableListView<FoodItem> get items => UnmodifiableListView(_list);
  bool get isLoading => _isLoading;

  /// Sets isLoading to true.
  void startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  /// Sets isLoading to false.
  void stopLoading() {
    _isLoading = false;
    notifyListeners();
  }

  /// Adds [FoodItem] to List.
  Future<bool> save(FoodItem item) async {
    try {
      startLoading();
      final upsert = await HttpFoodItemService().save(item);
      if (upsert.createdAt == null) return false;
      _list.removeWhere((f) => f.id == item.id);
      _list.add(upsert);
      return true;
    } finally {
      stopLoading();
    }
  }

  /// Removes [FoodItem] from list.
  Future<bool> remove(FoodItem item) async {
    try {
      startLoading();
      final upsert = await HttpFoodItemService().delete(item.id);
      if (upsert.success == false) {
        ScaffoldMessengerService.instance
            .displayError('error deleting daily entry');
        return false;
      }
      _list.removeWhere((f) => f.id == item.id);
      return true;
    } finally {
      stopLoading();
    }
  }

  /// Gets all food items.
  Future<void> getAll() async {
    try {
      startLoading();
      final weights = await HttpFoodItemService().getList();
      _list.clear();
      _list.addAll(weights);
    } finally {
      stopLoading();
    }
  }
}
