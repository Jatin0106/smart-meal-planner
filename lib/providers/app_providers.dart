import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/meal_model.dart';
import '../models/food_item_model.dart';
import '../models/goal_model.dart';
import '../models/daily_nutrition_model.dart';
import '../repositories/meal_repository.dart';
import '../repositories/food_repository.dart';
import '../repositories/goal_repository.dart';
import '../services/connectivity_service.dart';
import '../services/sync_service.dart';
import 'package:flutter/material.dart';

// Boxes
final mealBoxProvider = Provider<Box<MealModel>>((ref) => Hive.box<MealModel>('meals'));
final foodBoxProvider = Provider<Box<FoodItemModel>>((ref) => Hive.box<FoodItemModel>('foods'));
final goalBoxProvider = Provider<Box<GoalModel>>((ref) => Hive.box<GoalModel>('goals'));
final nutritionBoxProvider = Provider<Box<DailyNutritionModel>>((ref) => Hive.box<DailyNutritionModel>('nutrition'));

// Repositories
final mealRepositoryProvider = Provider<MealRepository>((ref) {
  return MealRepository(ref.watch(mealBoxProvider), ref.watch(nutritionBoxProvider));
});

final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  return FoodRepository(ref.watch(foodBoxProvider));
});

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  return GoalRepository(ref.watch(goalBoxProvider));
});

// Current Date State
final currentDateProvider = NotifierProvider<CurrentDateNotifier, DateTime>(CurrentDateNotifier.new);

class CurrentDateNotifier extends Notifier<DateTime> {
  @override
  DateTime build() => DateTime.now();

  void updateDate(DateTime date) {
    state = date;
  }
}

// Dark Mode State
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    final box = Hive.box('settings');
    final isDark = box.get('isDark', defaultValue: false);
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    final isDark = state == ThemeMode.dark;
    Hive.box('settings').put('isDark', !isDark);
    state = !isDark ? ThemeMode.dark : ThemeMode.light;
  }
}

// Meal Provider
final mealsProvider = NotifierProvider<MealNotifier, List<MealModel>>(MealNotifier.new);

class MealNotifier extends Notifier<List<MealModel>> {
  @override
  List<MealModel> build() {
    final repo = ref.watch(mealRepositoryProvider);
    final date = ref.watch(currentDateProvider);
    return repo.getMealsForDate(date);
  }

  Future<void> addMeal(MealModel meal) async {
    final repo = ref.read(mealRepositoryProvider);
    await repo.addMeal(meal);
    state = repo.getMealsForDate(ref.read(currentDateProvider));
  }

  Future<void> deleteMeal(String id) async {
    final repo = ref.read(mealRepositoryProvider);
    await repo.deleteMeal(id);
    state = repo.getMealsForDate(ref.read(currentDateProvider));
  }
  
  void loadMeals() {
    final repo = ref.read(mealRepositoryProvider);
    state = repo.getMealsForDate(ref.read(currentDateProvider));
  }
}

// Food Search State
final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';

  void updateQuery(String query) {
    state = query;
  }
}

final searchFoodProvider = Provider<List<FoodItemModel>>((ref) {
  final query = ref.watch(searchQueryProvider);
  final repo = ref.watch(foodRepositoryProvider);
  return repo.searchFoods(query);
});

// Daily Nutrition Provider
final dailyNutritionProvider = Provider<DailyNutritionModel>((ref) {
  ref.watch(mealsProvider); // Rebuild when meals change
  final date = ref.watch(currentDateProvider);
  final repo = ref.watch(mealRepositoryProvider);
  return repo.getDailyNutrition(date);
});

// Goal Provider
final userGoalProvider = NotifierProvider<GoalNotifier, GoalModel>(GoalNotifier.new);

class GoalNotifier extends Notifier<GoalModel> {
  @override
  GoalModel build() {
    return ref.watch(goalRepositoryProvider).getGoal();
  }

  Future<void> updateGoal(GoalModel goal) async {
    await ref.read(goalRepositoryProvider).saveGoal(goal);
    state = goal;
  }
}

// Analytics Provider
final weeklyNutritionProvider = Provider<List<DailyNutritionModel>>((ref) {
  ref.watch(mealsProvider);
  final repo = ref.watch(mealRepositoryProvider);
  return repo.getLast7DaysNutrition();
});
