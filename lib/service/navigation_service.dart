import 'package:flutter/material.dart';

class NavigationService {
  static final instance = NavigationService._();

  NavigationService._();

  final _navigationKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get navigationKey => _navigationKey;

  Future<T?>? pushReplacement<T extends Object, TO extends Object>(
    Widget widget,
  ) =>
      _navigationKey.currentState?.pushReplacement<T, TO>(
        MaterialPageRoute<T>(
          builder: (context) => widget,
        ),
      );

  Future<T?>? push<T extends Object>(Widget widget) =>
      _navigationKey.currentState?.push<T>(
        MaterialPageRoute<T>(
          builder: (context) => widget,
        ),
      );

  Future<T?>? pushFullscreenDialog<T extends Object>(Widget widget) =>
      _navigationKey.currentState?.push<T>(
        MaterialPageRoute<T>(
          builder: (context) => widget,
          fullscreenDialog: true,
        ),
      );

  Future<T?>? pushAndReplaceAll<T extends Object>(Widget widget) =>
      _navigationKey.currentState?.pushAndRemoveUntil<T>(
        MaterialPageRoute<T>(
          builder: (context) => widget,
        ),
        (route) => false,
      );

  void pop<T extends Object>([T? result]) =>
      _navigationKey.currentState?.pop(result);
}
