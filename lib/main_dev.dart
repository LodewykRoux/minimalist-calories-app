import 'package:calories_app/models/config/config.dart';
import 'package:calories_app/my_app.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  const myApp = AppConfig(
    baseUrl: 'http://139.84.233.6:3000',
    env: 'QA',
    child: MyApp(),
  );

  runApp(myApp);
}
