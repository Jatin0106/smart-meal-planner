import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/meal_model.dart';
import '../models/daily_nutrition_model.dart';
import '../providers/app_providers.dart';
import '../providers/auth_provider.dart';
import '../core/widgets/animated_button.dart';
import '../services/sync_service.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: isDark,
            onChanged: (val) {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
            secondary: const Icon(Icons.dark_mode),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.sync),
            title: const Text('Sync Offline Data'),
            onTap: () async {
              try {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (c) => const Center(child: CircularProgressIndicator()),
                );
                final count = await ref.read(syncServiceProvider).syncPendingData(ref.read(mealRepositoryProvider));
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(count > 0 ? 'Synced $count meals successfully' : 'All data is up to date')),
                  );
                  // Refresh meals
                  ref.read(mealsProvider.notifier).loadMeals();
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context); // close dialog
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sync failed: $e')));
                }
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text('Clear All Local Data', style: TextStyle(color: Colors.red)),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (c) => AlertDialog(
                  title: const Text('Clear Data'),
                  content: const Text('Are you sure you want to delete all local data? This cannot be undone.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(c, false), child: const Text('Cancel')),
                    TextButton(onPressed: () => Navigator.pop(c, true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
                  ],
                ),
              );

              if (confirm == true) {
                try {
                  await Hive.box<MealModel>('meals').clear();
                  await Hive.box<DailyNutritionModel>('nutrition').clear();
                  ref.read(mealsProvider.notifier).loadMeals();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All data cleared')));
                  }
                } catch (e) {
                  // Fallback without types
                  await Hive.box('meals').clear();
                  await Hive.box('nutrition').clear();
                  ref.read(mealsProvider.notifier).loadMeals();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All data cleared')));
                  }
                }
              }
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Sign Out', style: TextStyle(color: Colors.red)),
            onTap: () async {
              try {
                // Ensure we go back to root navigation before signing out to cleanly show login
                Navigator.of(context).popUntil((route) => route.isFirst);
                await ref.read(authControllerProvider).signOut();
              } catch (e) {
                debugPrint("Sign out error: $e");
              }
            },
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('App Info'),
            subtitle: Text('Version 1.0.0\nDeveloped for Practical Exam'),
          ),
        ],
      ),
    );
  }
}
