import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/app_providers.dart';
import '../core/widgets/meal_card.dart';
import '../core/theme/app_colors.dart';
import 'settings_screen.dart';

class MealPlannerScreen extends ConsumerWidget {
  const MealPlannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = ref.watch(currentDateProvider);
    final meals = ref.watch(mealsProvider);
    
    // Group meals
    final breakfast = meals.where((m) => m.mealType == 'Breakfast').toList();
    final lunch = meals.where((m) => m.mealType == 'Lunch').toList();
    final dinner = meals.where((m) => m.mealType == 'Dinner').toList();
    final snacks = meals.where((m) => m.mealType == 'Snacks').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
            },
          )
        ],
      ),
      body: Column(
        children: [
          _buildDateSelector(context, ref, date),
          Expanded(
            child: meals.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.restaurant_menu, size: 64, color: AppColors.textLightSecondary.withOpacity(0.5)),
                        const SizedBox(height: 16),
                        Text(
                          'No meals planned for today',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.textLightSecondary),
                        ),
                      ],
                    ).animate().fadeIn(),
                  )
                : ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      if (breakfast.isNotEmpty) _buildMealSection(context, ref, 'Breakfast', breakfast),
                      if (lunch.isNotEmpty) _buildMealSection(context, ref, 'Lunch', lunch),
                      if (dinner.isNotEmpty) _buildMealSection(context, ref, 'Dinner', dinner),
                      if (snacks.isNotEmpty) _buildMealSection(context, ref, 'Snacks', snacks),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context, WidgetRef ref, DateTime date) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: () {
              ref.read(currentDateProvider.notifier).updateDate(date.subtract(const Duration(days: 1)));
            },
          ),
          Text(
            DateFormat('EEEE, MMM d').format(date),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: () {
              ref.read(currentDateProvider.notifier).updateDate(date.add(const Duration(days: 1)));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMealSection(BuildContext context, WidgetRef ref, String title, List meals) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ...meals.map((meal) => MealCard(
              meal: meal,
              onDelete: () {
                ref.read(mealsProvider.notifier).deleteMeal(meal.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Meal deleted')),
                );
              },
            )),
        const SizedBox(height: 16),
      ],
    );
  }
}
