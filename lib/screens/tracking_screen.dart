import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/app_providers.dart';
import '../core/widgets/calorie_progress_card.dart';
import '../core/widgets/nutrient_indicator_card.dart';
import '../core/theme/app_colors.dart';

class TrackingScreen extends ConsumerWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyNutrition = ref.watch(dailyNutritionProvider);
    final goal = ref.watch(userGoalProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Nutri Dashboard', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).brightness == Brightness.dark ? Colors.black : AppColors.primaryLight.withOpacity(0.3),
              Theme.of(context).scaffoldBackgroundColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeHeader(context).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),
                const SizedBox(height: 24),
                CalorieProgressCard(
                  current: dailyNutrition.totalCalories,
                  target: goal.targetCalories,
                ).animate().scale(delay: 200.ms, curve: Curves.easeOutBack),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Macro Breakdown',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ).animate().fadeIn(delay: 400.ms),
                  ],
                ),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: [
                    NutrientIndicatorCard(
                      title: 'Protein',
                      current: dailyNutrition.totalProtein,
                      target: goal.targetProtein,
                      color: AppColors.protein,
                    ).animate().slideX(delay: 500.ms, begin: -0.2),
                    NutrientIndicatorCard(
                      title: 'Carbs',
                      current: dailyNutrition.totalCarbs,
                      target: goal.targetCarbs,
                      color: AppColors.carbs,
                    ).animate().slideX(delay: 600.ms, begin: 0.2),
                    NutrientIndicatorCard(
                      title: 'Fats',
                      current: dailyNutrition.totalFats,
                      target: goal.targetFats,
                      color: AppColors.fats,
                    ).animate().slideX(delay: 700.ms, begin: -0.2),
                    _buildExtraFeatureCard(context, 'Water', '4 / 8 Glasses', Icons.water_drop, Colors.blue).animate().slideX(delay: 800.ms, begin: 0.2),
                  ],
                ),
                const SizedBox(height: 32),
                _buildEnergyScore(context).animate().fadeIn(delay: 900.ms).slideY(begin: 0.2, end: 0),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Good Morning,', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.grey)),
            Text('Ready to crush your goals? 🔥', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.local_fire_department, color: AppColors.primary, size: 28)
              .animate(onPlay: (c) => c.repeat(reverse: true))
              .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.2, 1.2), duration: 800.ms),
        ),
      ],
    );
  }

  Widget _buildExtraFeatureCard(BuildContext context, String title, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
          const Spacer(),
          Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildEnergyScore(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.secondary, AppColors.secondary.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppColors.secondary.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Energy Score', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Your macro balance is excellent today! Keep it up.', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.9))),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
            child: const Text('92', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }
}
