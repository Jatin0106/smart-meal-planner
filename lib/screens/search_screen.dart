import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import '../core/widgets/custom_text_field.dart';
import '../core/widgets/meal_card.dart';
import '../core/theme/app_colors.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _filterMealType = 'All';

  @override
  Widget build(BuildContext context) {
    final allMeals = ref.watch(mealRepositoryProvider).getAllMeals();
    
    final filteredMeals = allMeals.where((meal) {
      final matchesQuery = meal.foodName.toLowerCase().contains(_query.toLowerCase());
      final matchesType = _filterMealType == 'All' || meal.mealType == _filterMealType;
      return matchesQuery && matchesType;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Meals'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _searchController,
                    hintText: 'Search logged meals...',
                    prefixIcon: Icons.search,
                    onChanged: (val) {
                      setState(() {
                        _query = val;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: _filterMealType,
                  items: ['All', 'Breakfast', 'Lunch', 'Dinner', 'Snacks']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _filterMealType = val);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: filteredMeals.isEmpty
                ? const Center(child: Text('No meals found matching your search.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredMeals.length,
                    itemBuilder: (context, index) {
                      final meal = filteredMeals[index];
                      return MealCard(
                        meal: meal,
                        onDelete: () {
                          ref.read(mealsProvider.notifier).deleteMeal(meal.id);
                          setState(() {});
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
