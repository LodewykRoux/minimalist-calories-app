import 'package:flutter/material.dart';

class AppConfig extends InheritedWidget {
  final String env;
  final String baseUrl;

  const AppConfig({
    Key? key,
    required this.env,
    required this.baseUrl,
    required Widget child,
  }) : super(
          key: key,
          child: child,
        );

  static AppConfig? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>();
  }

  static AppConfig? of(BuildContext context) {
    final AppConfig? result = maybeOf(context);
    assert(result != null, 'No appconfig in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppConfig oldWidget) => baseUrl != oldWidget.baseUrl;
}
