import 'dart:collection';

import 'package:calories_app/models/user.dart';
import 'package:calories_app/provider/daily_entry_provider.dart';
import 'package:calories_app/provider/food_item_provider.dart';
import 'package:calories_app/provider/user_provider.dart';
import 'package:calories_app/provider/weight_provider.dart';
import 'package:calories_app/screens/daily_entry/daily_entry_screen.dart';
import 'package:calories_app/screens/food_item/food_item_screen.dart';
import 'package:calories_app/screens/main/home.dart';
import 'package:calories_app/screens/weight/weight_screen.dart';
import 'package:calories_app/widget/bottom_app_bar/custom_bottom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

import '../../provider.mocks.dart';

void main() {
  late MockUserProvider mockUserProvider;
  late MockDailyEntryProvider mockDailyEntryProvider;
  late MockFoodItemProvider mockFoodItemProvider;
  late MockWeightProvider mockWeightProvider;
  late MockNavigationService mockNavigationService;

  setUp(() {
    mockUserProvider = MockUserProvider();
    mockDailyEntryProvider = MockDailyEntryProvider();
    mockFoodItemProvider = MockFoodItemProvider();
    mockWeightProvider = MockWeightProvider();
    mockNavigationService = MockNavigationService();

    when(mockUserProvider.user).thenReturn(
      User(
        id: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        deletedAt: null,
        name: 'TestUser',
        email: 'test@example.com',
        foodItems: const [],
        dailyEntry: const [],
        token: 'token',
      ),
    );

    when(mockDailyEntryProvider.getAll()).thenAnswer((_) async {});
    when(mockFoodItemProvider.getAll()).thenAnswer((_) async {});
    when(mockWeightProvider.getAll()).thenAnswer((_) async {});

    when(mockNavigationService.navigationKey)
        .thenReturn(GlobalKey<NavigatorState>());
    when(mockDailyEntryProvider.entries).thenReturn(UnmodifiableListView([]));
    when(mockFoodItemProvider.items).thenReturn(UnmodifiableListView([]));
    when(mockWeightProvider.weights).thenReturn(UnmodifiableListView([]));
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
        ChangeNotifierProvider<DailyEntryProvider>.value(
          value: mockDailyEntryProvider,
        ),
        ChangeNotifierProvider<FoodItemProvider>.value(
          value: mockFoodItemProvider,
        ),
        ChangeNotifierProvider<WeightProvider>.value(value: mockWeightProvider),
      ],
      child: MaterialApp(
        navigatorKey: mockNavigationService.navigationKey,
        home: const Home(),
      ),
    );
  }

  testWidgets('renders Home screen correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle(); // Ensure all async operations finish

    expect(find.text('Welcome, TestUser'), findsOneWidget);
    expect(find.byType(CustomBottomAppBar), findsOneWidget);
    expect(find.byType(DailyEntryScreen), findsOneWidget);
  });

  testWidgets('calls getAll() on init for providers',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    verify(mockDailyEntryProvider.getAll()).called(1);
    verify(mockFoodItemProvider.getAll()).called(1);
    verify(mockWeightProvider.getAll()).called(1);
  });

  testWidgets('switches between tabs', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.byType(DailyEntryScreen), findsOneWidget);

    await tester.tap(find.byIcon(Icons.kitchen_outlined));
    await tester.pumpAndSettle();
    expect(find.byType(FoodItemScreen), findsOneWidget);

    await tester.tap(find.byIcon(Icons.scale_outlined));
    await tester.pumpAndSettle();
    expect(find.byType(WeightScreen), findsOneWidget);
  });

  testWidgets('logs out and navigates to login screen',
      (WidgetTester tester) async {
    when(mockUserProvider.logout()).thenAnswer((_) async {});

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    await tester.tap(find.text('logout'));
    await tester.pumpAndSettle();

    verify(mockUserProvider.logout()).called(1);
  });
}
