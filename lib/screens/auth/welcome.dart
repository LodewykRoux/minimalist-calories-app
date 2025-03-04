import 'package:calories_app/http/main.dart';
import 'package:calories_app/models/config/config.dart';
import 'package:calories_app/provider/user_provider.dart';
import 'package:calories_app/screens/main/home.dart';
import 'package:calories_app/screens/auth/login.dart';
import 'package:calories_app/service/navigation_service.dart';
import 'package:calories_app/service/scaffold_messenger_service.dart';
import 'package:calories_app/service/secure_storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  void initState() {
    super.initState();

    init();
  }

  Future<void> init() async {
    try {
      final token = await SecureStorageService.instance.accessToken;

      if (token == null) {
        NavigationService.instance.pushAndReplaceAll(const Login());
      } else {
        final user = await Provider.of<UserProvider>(context, listen: false)
            .validate(token);

        if (user == null) {
          NavigationService.instance.pushAndReplaceAll(const Login());
        } else {
          NavigationService.instance.pushAndReplaceAll(const Home());
        }
      }
    } catch (ex) {
      await SecureStorageService.instance.setAccessToken(null);
      NavigationService.instance.pushAndReplaceAll(const Login());
      ScaffoldMessengerService.instance.displayError('$ex');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Builder(
        builder: (context) {
          final config = AppConfig.of(context);
          if (config != null) {
            HttpService.instance.init(
              baseUrl: config.baseUrl,
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
