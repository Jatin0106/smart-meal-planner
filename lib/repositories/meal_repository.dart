import 'package:hive/hive.dart';
import '../models/meal_model.dart';
import '../models/daily_nutrition_model.dart';
import 'package:intl/intl.dart';

class MealRepository {
  final Box<MealModel> _mealBox;
  final Box<DailyNutritionModel> _nutritionBox;

  MealRepository(this._mealBox, this._nutritionBox);

  Future<void> addMeal(MealModel meal) async {
    await _mealBox.put(meal.id, meal);
    await _updateDailyNutrition(meal.dateTime);
  }

  Future<void> updateMeal(MealModel meal) async {
    await _mealBox.put(meal.id, meal);
    await _updateDailyNutrition(meal.dateTime);
  }

  Future<void> deleteMeal(String id) async {
    final meal = _mealBox.get(id);
    if (meal != null) {
      final date = meal.dateTime;
      await _mealBox.delete(id);
      await _updateDailyNutrition(date);
    }
  }

  List<MealModel> getMealsForDate(DateTime date) {
    return _mealBox.values.where((meal) {
      return meal.dateTime.year == date.year &&
          meal.dateTime.month == date.month &&
          meal.dateTime.day == date.day;
    }).toList();
  }

  List<MealModel> getAllMeals() {
    return _mealBox.values.toList();
  }
  
  List<MealModel> getUnsyncedMeals() {
    return _mealBox.values.where((meal) => !meal.isSynced).toList();
  }
  
  Future<void> markAsSynced(List<String> ids) async {
    for (var id in ids) {
      final meal = _mealBox.get(id);
      if (meal != null) {
        meal.isSynced = true;
        await meal.save();
      }
    }
  }

  Future<void> _updateDailyNutrition(DateTime date) async {
    final dateString = DateFormat('yyyy-MM-dd').format(date);
    final meals = getMealsForDate(date);
    
    double calories = 0, protein = 0, carbs = 0, fats = 0;
    
    for (var meal in meals) {
      calories += meal.calories;
      protein += meal.protein;
      carbs += meal.carbs;
      fats += meal.fats;
    }
    
    final nutrition = DailyNutritionModel(
      date: dateString,
      totalCalories: calories,
      totalProtein: protein,
      totalCarbs: carbs,
      totalFats: fats,
    );
    
    await _nutritionBox.put(dateString, nutrition);
  }
  
  DailyNutritionModel getDailyNutrition(DateTime date) {
    final dateString = DateFormat('yyyy-MM-dd').format(date);
    return _nutritionBox.get(dateString) ?? DailyNutritionModel(date: dateString);
  }
  
  List<DailyNutritionModel> getLast7DaysNutrition() {
    final today = DateTime.now();
    List<DailyNutritionModel> list = [];
    for (int i = 6; i >= 0; i--) {
      final d = today.subtract(Duration(days: i));
      list.add(getDailyNutrition(d));
    }
    return list;
  }
}
