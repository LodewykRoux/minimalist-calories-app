import 'dart:collection';
import 'package:calories_app/http/daily_entry_http.dart';
import 'package:calories_app/models/daily_entry.dart';
import 'package:calories_app/service/scaffold_messenger_service.dart';
import 'package:flutter/foundation.dart';

class DailyEntryProvider extends ChangeNotifier {
  final List<DailyEntry> _list = [];
  bool _isLoading = false;

  UnmodifiableListView<DailyEntry> get entries => UnmodifiableListView(_list);
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

  /// Adds [DailyEntry] to List.
  Future<bool> save(DailyEntry entry) async {
    try {
      startLoading();
      final upsert = await HttpDailyEntryService().save(entry);
      if (upsert.createdAt == null) return false;
      _list.removeWhere((w) => w.id == entry.id);
      _list.add(upsert);
      return true;
    } finally {
      stopLoading();
    }
  }

  /// Removes [DailyEntry] from list.
  Future<bool> remove(DailyEntry entry) async {
    try {
      startLoading();
      final upsert = await HttpDailyEntryService().delete(entry.id);
      if (upsert.success == false) {
        ScaffoldMessengerService.instance
            .displayError('error deleting daily entry');
        return false;
      }
      _list.removeWhere((d) => d.id == entry.id);
      return true;
    } finally {
      stopLoading();
    }
  }

  /// Gets all daily entries.
  Future<void> getAll() async {
    try {
      startLoading();
      final weights = await HttpDailyEntryService().getList();
      _list.clear();
      _list.addAll(weights);
    } finally {
      stopLoading();
    }
  }
}
