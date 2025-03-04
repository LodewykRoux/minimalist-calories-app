import 'package:calories_app/provider/daily_entry_provider.dart';
import 'package:calories_app/provider/food_item_provider.dart';
import 'package:calories_app/provider/user_provider.dart';
import 'package:calories_app/provider/weight_provider.dart';
import 'package:calories_app/screens/auth/welcome.dart';
import 'package:calories_app/service/navigation_service.dart';
import 'package:calories_app/service/scaffold_messenger_service.dart';
import 'package:calories_app/theme/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => WeightProvider()),
        ChangeNotifierProvider(create: (_) => FoodItemProvider()),
        ChangeNotifierProvider(create: (_) => DailyEntryProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Calories',
        theme: MainTheme().mainTheme,
        home: FutureBuilder(
          future: GoogleFonts.pendingFonts(),
          builder: (futureContext, snapshot) =>
              snapshot.connectionState != ConnectionState.done
                  ? const SizedBox()
                  : const Welcome(),
        ),
        scaffoldMessengerKey:
            ScaffoldMessengerService.instance.scaffoldMessengerKey,
        navigatorKey: NavigationService.instance.navigationKey,
      ),
    );
  }
}
