import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/app_providers.dart';
import '../models/food_item_model.dart';
import '../models/meal_model.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/custom_text_field.dart';
import '../core/widgets/animated_button.dart';

class FoodEntryScreen extends ConsumerStatefulWidget {
  const FoodEntryScreen({super.key});

  @override
  ConsumerState<FoodEntryScreen> createState() => _FoodEntryScreenState();
}

class _FoodEntryScreenState extends ConsumerState<FoodEntryScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final searchResults = ref.watch(searchFoodProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Food'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomTextField(
              controller: _searchController,
              hintText: 'Search foods...',
              prefixIcon: Icons.search,
              onChanged: (val) {
                ref.read(searchQueryProvider.notifier).updateQuery(val);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: searchResults.length,
              itemBuilder: (context, index) {
                final food = searchResults[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    title: Text(food.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('${food.defaultCalories} kcal • P:${food.protein}g C:${food.carbs}g F:${food.fats}g'),
                    trailing: const Icon(Icons.add_circle, color: AppColors.primary),
                    onTap: () => _showAddMealModal(context, food),
                  ),
                ).animate().fadeIn(delay: Duration(milliseconds: 50 * index)).slideX();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCustomFoodModal(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddMealModal(BuildContext context, FoodItemModel food) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: AddMealForm(food: food),
      ),
    );
  }

  void _showAddCustomFoodModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: const AddCustomFoodForm(),
      ),
    );
  }
}

class AddMealForm extends ConsumerStatefulWidget {
  final FoodItemModel food;

  const AddMealForm({super.key, required this.food});

  @override
  ConsumerState<AddMealForm> createState() => _AddMealFormState();
}

class _AddMealFormState extends ConsumerState<AddMealForm> {
  final _quantityController = TextEditingController(text: '1');
  String _selectedMealType = 'Breakfast';
  double _quantity = 1.0;

  @override
  Widget build(BuildContext context) {
    final calories = widget.food.defaultCalories * _quantity;
    final protein = widget.food.protein * _quantity;
    final carbs = widget.food.carbs * _quantity;
    final fats = widget.food.fats * _quantity;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add ${widget.food.name}', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedMealType,
            decoration: InputDecoration(
              labelText: 'Meal Type',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            items: ['Breakfast', 'Lunch', 'Dinner', 'Snacks']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedMealType = val);
            },
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: _quantityController,
            hintText: 'Quantity (Servings/100g)',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (val) {
              setState(() {
                _quantity = double.tryParse(val) ?? 0;
              });
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNutrientText('Calories', calories.toStringAsFixed(0), AppColors.primary),
              _buildNutrientText('Protein', '${protein.toStringAsFixed(1)}g', AppColors.protein),
              _buildNutrientText('Carbs', '${carbs.toStringAsFixed(1)}g', AppColors.carbs),
              _buildNutrientText('Fats', '${fats.toStringAsFixed(1)}g', AppColors.fats),
            ],
          ),
          const SizedBox(height: 24),
          AnimatedButton(
            text: 'Save Meal',
            onPressed: () async {
              if (_quantity <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Quantity must be > 0')));
                return;
              }
              final meal = MealModel(
                mealType: _selectedMealType,
                foodName: widget.food.name,
                quantity: _quantity,
                calories: calories,
                protein: protein,
                carbs: carbs,
                fats: fats,
                dateTime: ref.read(currentDateProvider),
              );
              await ref.read(mealsProvider.notifier).addMeal(meal);
              if (mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved Offline')));
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNutrientText(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class AddCustomFoodForm extends ConsumerStatefulWidget {
  const AddCustomFoodForm({super.key});

  @override
  ConsumerState<AddCustomFoodForm> createState() => _AddCustomFoodFormState();
}

class _AddCustomFoodFormState extends ConsumerState<AddCustomFoodForm> {
  final _nameController = TextEditingController();
  final _calController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Create Custom Food', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          CustomTextField(controller: _nameController, hintText: 'Food Name'),
          const SizedBox(height: 12),
          CustomTextField(controller: _calController, hintText: 'Calories per serving', keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: CustomTextField(controller: _proteinController, hintText: 'Protein (g)', keyboardType: TextInputType.number)),
              const SizedBox(width: 8),
              Expanded(child: CustomTextField(controller: _carbsController, hintText: 'Carbs (g)', keyboardType: TextInputType.number)),
              const SizedBox(width: 8),
              Expanded(child: CustomTextField(controller: _fatsController, hintText: 'Fats (g)', keyboardType: TextInputType.number)),
            ],
          ),
          const SizedBox(height: 24),
          AnimatedButton(
            text: 'Create Food',
            onPressed: () async {
              if (_nameController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Name required')));
                return;
              }
              final food = FoodItemModel(
                name: _nameController.text,
                defaultCalories: double.tryParse(_calController.text) ?? 0,
                protein: double.tryParse(_proteinController.text) ?? 0,
                carbs: double.tryParse(_carbsController.text) ?? 0,
                fats: double.tryParse(_fatsController.text) ?? 0,
              );
              await ref.read(foodRepositoryProvider).addCustomFood(food);
              // Trigger a refresh of search results
              ref.read(searchQueryProvider.notifier).updateQuery('');
              if (mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
