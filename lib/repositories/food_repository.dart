import 'package:hive/hive.dart';
import '../models/food_item_model.dart';

class FoodRepository {
  final Box<FoodItemModel> _foodBox;

  FoodRepository(this._foodBox);

  Future<void> initDefaultFoods() async {
    if (_foodBox.isEmpty) {
      final defaults = [
        FoodItemModel(name: 'Rice', defaultCalories: 130, protein: 2.7, carbs: 28, fats: 0.3),
        FoodItemModel(name: 'Apple', defaultCalories: 52, protein: 0.3, carbs: 14, fats: 0.2),
        FoodItemModel(name: 'Banana', defaultCalories: 89, protein: 1.1, carbs: 23, fats: 0.3),
        FoodItemModel(name: 'Bread', defaultCalories: 265, protein: 9, carbs: 49, fats: 3.2),
        FoodItemModel(name: 'Eggs', defaultCalories: 155, protein: 13, carbs: 1.1, fats: 11),
        FoodItemModel(name: 'Chicken', defaultCalories: 165, protein: 31, carbs: 0, fats: 3.6),
        FoodItemModel(name: 'Milk', defaultCalories: 42, protein: 3.4, carbs: 5, fats: 1),
        FoodItemModel(name: 'Oats', defaultCalories: 389, protein: 16.9, carbs: 66.3, fats: 6.9),
        FoodItemModel(name: 'Paneer', defaultCalories: 296, protein: 14, carbs: 3.4, fats: 25),
        FoodItemModel(name: 'Salad', defaultCalories: 15, protein: 1, carbs: 3, fats: 0),
        FoodItemModel(name: 'Yogurt', defaultCalories: 59, protein: 10, carbs: 3.6, fats: 0.4),
        FoodItemModel(name: 'Tea', defaultCalories: 1, protein: 0, carbs: 0.2, fats: 0),
        FoodItemModel(name: 'Coffee', defaultCalories: 2, protein: 0.3, carbs: 0, fats: 0.1),
        FoodItemModel(name: 'Dal', defaultCalories: 116, protein: 9, carbs: 20, fats: 0.4),
        FoodItemModel(name: 'Roti', defaultCalories: 297, protein: 9.6, carbs: 55, fats: 3.3),
      ];
      
      for (var food in defaults) {
        await _foodBox.put(food.id, food);
      }
    }
  }

  Future<void> addCustomFood(FoodItemModel food) async {
    food.isCustom = true;
    await _foodBox.put(food.id, food);
  }

  List<FoodItemModel> getAllFoods() {
    return _foodBox.values.toList();
  }

  List<FoodItemModel> searchFoods(String query) {
    if (query.isEmpty) return getAllFoods();
    final lowerQuery = query.toLowerCase();
    return _foodBox.values
        .where((food) => food.name.toLowerCase().contains(lowerQuery))
        .toList();
  }
}
