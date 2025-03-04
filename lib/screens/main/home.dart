import 'package:calories_app/provider/daily_entry_provider.dart';
import 'package:calories_app/provider/food_item_provider.dart';
import 'package:calories_app/provider/user_provider.dart';
import 'package:calories_app/provider/weight_provider.dart';
import 'package:calories_app/screens/auth/login.dart';
import 'package:calories_app/screens/daily_entry/daily_entry_screen.dart';
import 'package:calories_app/screens/food_item/food_item_screen.dart';
import 'package:calories_app/screens/weight/weight_screen.dart';
import 'package:calories_app/service/navigation_service.dart';
import 'package:calories_app/theme/text_styles.dart';
import 'package:calories_app/widget/bottom_app_bar/custom_bottom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<WeightProvider>(context, listen: false).getAll();
      Provider.of<FoodItemProvider>(context, listen: false).getAll();
      Provider.of<DailyEntryProvider>(context, listen: false).getAll();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, value, child) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Welcome, ${value.user?.name}',
            style: TextStyles.white20Bold,
            overflow: TextOverflow.fade,
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await Provider.of<UserProvider>(context, listen: false)
                    .logout();
                NavigationService.instance.pushAndReplaceAll(const Login());
              },
              child: const Text(
                'logout',
                style: TextStyles.white15Medium,
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomAppBar(
          onTap: _onItemTapped,
          selectedIndex: _selectedIndex,
        ),
        body: [
          const DailyEntryScreen(),
          const FoodItemScreen(),
          const WeightScreen(),
        ][_selectedIndex],
      ),
    );
  }
}
