import 'package:calories_app/models/user.dart';
import 'package:calories_app/provider/daily_entry_provider.dart';
import 'package:calories_app/provider/food_item_provider.dart';
import 'package:calories_app/provider/user_provider.dart';
import 'package:calories_app/provider/weight_provider.dart';
import 'package:calories_app/screens/auth/login.dart';
import 'package:calories_app/widget/button/custom_outlined_button.dart';
import 'package:calories_app/widget/text_field/custom_text_field.dart';
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
  late MockScaffoldMessengerService mockScaffoldMessengerService;

  final user = User(
    id: 1,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    deletedAt: DateTime.now(),
    name: 'TestUser',
    email: 'TestUser@gmail.com',
    foodItems: const [],
    dailyEntry: const [],
    token: 'token',
  );

  setUp(() {
    mockUserProvider = MockUserProvider();
    mockFoodItemProvider = MockFoodItemProvider();
    mockWeightProvider = MockWeightProvider();
    mockDailyEntryProvider = MockDailyEntryProvider();
    mockNavigationService = MockNavigationService();
    mockScaffoldMessengerService = MockScaffoldMessengerService();

    when(mockNavigationService.navigationKey)
        .thenReturn(GlobalKey<NavigatorState>());
    when(mockScaffoldMessengerService.scaffoldMessengerKey)
        .thenReturn(GlobalKey<ScaffoldMessengerState>());

    when(mockScaffoldMessengerService.displayError(any)).thenReturn(null);
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
        scaffoldMessengerKey: mockScaffoldMessengerService.scaffoldMessengerKey,
        home: const Login(),
      ),
    );
  }

  testWidgets('renders login screen correctly', (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('CALORIES'), findsOneWidget);
    expect(find.byType(CustomTextField), findsNWidgets(2));
    expect(find.byType(CustomOutlinedButton), findsOneWidget);
    expect(find.text('login'), findsOneWidget);
    expect(find.text('switch to sign up'), findsOneWidget);
  });

  testWidgets('toggles between login and sign up states',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('login'), findsOneWidget);
    expect(find.text('switch to sign up'), findsOneWidget);

    await tester.tap(find.text('switch to sign up'));
    await tester.pump();

    expect(find.text('sign up'), findsOneWidget);
    expect(find.text('switch to login'), findsOneWidget);
    expect(find.byType(CustomTextField), findsNWidgets(3));
  });

  testWidgets('calls login on button press', (WidgetTester tester) async {
    when(mockUserProvider.login('TestUser@gmail.com', 'TestPassword'))
        .thenAnswer(
      (_) async => user,
    );

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.enterText(
      find.byType(CustomTextField).at(0),
      'TestUser@gmail.com',
    );
    await tester.enterText(find.byType(CustomTextField).at(1), 'TestPassword');

    await tester.tap(find.byType(CustomOutlinedButton));
    await tester.pump();

    verify(mockUserProvider.login('TestUser@gmail.com', 'TestPassword'))
        .called(1);
  });

  testWidgets('calls register on button press in sign up mode',
      (WidgetTester tester) async {
    when(
      mockUserProvider.register(
        'TestUser',
        'TestUser@gmail.com',
        'TestPassword',
      ),
    ).thenAnswer((_) async => Future.value(user));

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.text('switch to sign up'));
    await tester.pump();

    await tester.enterText(find.byType(CustomTextField).at(0), 'Test User');
    await tester.enterText(
      find.byType(CustomTextField).at(1),
      'test@example.com',
    );
    await tester.enterText(find.byType(CustomTextField).at(2), 'password');

    await tester.tap(find.byType(CustomOutlinedButton));
    await tester.pump();

    verify(
      mockUserProvider.register(
        'Test User',
        'test@example.com',
        'password',
      ),
    ).called(1);
  });
}
