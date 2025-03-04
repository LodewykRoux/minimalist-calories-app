import 'package:calories_app/models/config/config.dart';
import 'package:calories_app/my_app.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  const myApp = AppConfig(
    baseUrl: 'http://192.168.0.104:3000',
    env: 'DEV',
    child: MyApp(),
  );

  runApp(myApp);
}
