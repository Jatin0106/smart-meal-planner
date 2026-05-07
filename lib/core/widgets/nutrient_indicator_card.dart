import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'glass_container.dart';

class NutrientIndicatorCard extends StatelessWidget {
  final String title;
  final double current;
  final double target;
  final Color color;
  final String unit;

  const NutrientIndicatorCard({
    super.key,
    required this.title,
    required this.current,
    required this.target,
    required this.color,
    this.unit = 'g',
  });

  @override
  Widget build(BuildContext context) {
    double progress = target > 0 ? (current / target).clamp(0.0, 1.0) : 0;
    
    return GlassContainer(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(Icons.circle, color: color, size: 12),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${current.toStringAsFixed(1)}$unit',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'of ${target.toStringAsFixed(0)}$unit',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Spacer(),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: color.withOpacity(0.2),
              color: color,
              minHeight: 6,
            ),
          ).animate().scaleX(begin: 0, end: 1, duration: 600.ms, curve: Curves.easeOut),
        ],
      ),
    );
  }
}
