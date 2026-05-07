import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/meal_model.dart';
import 'models/food_item_model.dart';
import 'models/goal_model.dart';
import 'models/daily_nutrition_model.dart';
import 'core/theme/app_theme.dart';
import 'screens/main_screen.dart';
import 'providers/app_providers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/auth/login_screen.dart';
import 'screens/splash_screen.dart';
import 'repositories/food_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Adapters
  Hive.registerAdapter(MealModelAdapter());
  Hive.registerAdapter(FoodItemModelAdapter());
  Hive.registerAdapter(GoalModelAdapter());
  Hive.registerAdapter(DailyNutritionModelAdapter());

  // Open Boxes
  await Hive.openBox<MealModel>('meals');
  final foodBox = await Hive.openBox<FoodItemModel>('foods');
  await Hive.openBox<GoalModel>('goals');
  await Hive.openBox<DailyNutritionModel>('nutrition');
  await Hive.openBox('settings');

  // Initialize Default Foods
  final foodRepo = FoodRepository(foodBox);
  await foodRepo.initDefaultFoods();

  runApp(
    const ProviderScope(
      child: SmartMealPlannerApp(),
    ),
  );
}

class SmartMealPlannerApp extends ConsumerWidget {
  const SmartMealPlannerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Smart Meal Planner',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      home: const SplashScreen(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData && snapshot.data != null) {
            return const MainScreen();
          }
          return const LoginScreen();
        },
      );
    } catch (e) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 64),
                const SizedBox(height: 16),
                const Text('Firebase Not Configured', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                const Text('Please run `flutterfire configure` in your terminal to connect your Firebase project.', textAlign: TextAlign.center),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainScreen()));
                  },
                  child: const Text('Continue Without Auth (Demo Mode)'),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}
