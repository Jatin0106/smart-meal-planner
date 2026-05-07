import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/app_providers.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/glass_container.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyNutrition = ref.watch(weeklyNutritionProvider);
    final goal = ref.watch(userGoalProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Calories Trend',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GlassContainer(
              height: 300,
              padding: const EdgeInsets.all(16),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (goal.targetCalories * 1.5).clamp(0, double.infinity),
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() >= 0 && value.toInt() < weeklyNutrition.length) {
                            final dateStr = weeklyNutrition[value.toInt()].date;
                            if (dateStr.isNotEmpty) {
                              final date = DateTime.parse(dateStr);
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(DateFormat('E').format(date), style: const TextStyle(fontSize: 10)),
                              );
                            }
                          }
                          return const Text('');
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 40,
                        getTitlesWidget: (value, meta) {
                          if (value == 0) return const Text('');
                          return Text(value.toInt().toString(), style: const TextStyle(fontSize: 10));
                        },
                      ),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: weeklyNutrition.asMap().entries.map((entry) {
                    final index = entry.key;
                    final nut = entry.value;
                    final isOver = nut.totalCalories > goal.targetCalories;
                    return BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: nut.totalCalories,
                          color: isOver ? AppColors.error : AppColors.primary,
                          width: 16,
                          borderRadius: BorderRadius.circular(4),
                          backDrawRodData: BackgroundBarChartRodData(
                            show: true,
                            toY: goal.targetCalories,
                            color: Colors.grey.withOpacity(0.2),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildInsightsCard(context, weeklyNutrition, goal.targetCalories),
          ],
        ),
      ),
    );
  }

  Widget _buildInsightsCard(BuildContext context, List weeklyNutrition, double targetCal) {
    int overGoalDays = 0;
    for (var nut in weeklyNutrition) {
      if (nut.totalCalories > targetCal) overGoalDays++;
    }

    String insight = "You stayed within your goal mostly this week. Great consistency!";
    if (overGoalDays > 3) {
      insight = "You exceeded your calorie goal frequently this week. Consider adjusting your meals.";
    }

    return GlassContainer(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.lightbulb, color: AppColors.secondary, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('AI Insight', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(insight, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
