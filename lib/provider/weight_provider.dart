import 'package:calories_app/http/weight_http.dart';
import 'package:calories_app/models/weight.dart';
import 'package:calories_app/service/scaffold_messenger_service.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

class WeightProvider extends ChangeNotifier {
  final List<Weight> _list = [];
  bool _isLoading = false;

  UnmodifiableListView<Weight> get weights => UnmodifiableListView(_list);
  bool get isLoading => _isLoading;

  double get averageWeight => _list.isEmpty
      ? 0
      : _list.map((e) => e.weight).toList().sum / _list.length;

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

  /// Adds [Weight] to List.
  Future<bool> save(Weight weight) async {
    try {
      startLoading();
      final upsert = await HttpWeightService().save(weight);
      if (upsert.createdAt == null) return false;
      _list.removeWhere((w) => w.id == weight.id);
      _list.add(upsert);
      return true;
    } finally {
      stopLoading();
    }
  }

  /// Removes [Weight] from list.
  Future<bool> remove(Weight weight) async {
    try {
      startLoading();
      final upsert = await HttpWeightService().delete(weight.id);
      if (upsert.success == false) {
        ScaffoldMessengerService.instance.displayError('error deleting weight');
        return false;
      }
      _list.removeWhere((w) => w.id == weight.id);
      return upsert.success;
    } finally {
      stopLoading();
    }
  }

  /// Gets all weights.
  Future<void> getAll() async {
    try {
      startLoading();
      final weights = await HttpWeightService().getList();
      _list.clear();
      _list.addAll(weights);
    } finally {
      stopLoading();
    }
  }
}
