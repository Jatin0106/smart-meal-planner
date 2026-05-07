import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import 'glass_container.dart';

class CalorieProgressCard extends StatelessWidget {
  final double current;
  final double target;

  const CalorieProgressCard({
    super.key,
    required this.current,
    required this.target,
  });

  @override
  Widget build(BuildContext context) {
    double progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0;
    double remaining = target - current;
    if (remaining < 0) remaining = 0;

    return GlassContainer(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatColumn(context, 'Eaten', '${current.toStringAsFixed(0)}'),
          SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              fit: StackFit.expand,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 10,
                  backgroundColor: AppColors.primary.withOpacity(0.2),
                  color: AppColors.primary,
                ).animate().scale(duration: 600.ms, curve: Curves.easeOutCubic),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${remaining.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                      Text(
                        'Remaining',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildStatColumn(context, 'Target', '${target.toStringAsFixed(0)}'),
        ],
      ),
    );
  }

  Widget _buildStatColumn(BuildContext context, String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
