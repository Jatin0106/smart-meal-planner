import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/meal_model.dart';
import '../models/daily_nutrition_model.dart';
import '../core/theme/app_colors.dart';
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
    final savedEmail = Hive.box('settings').get('last_email', defaultValue: 'guest@smartmeal.com');

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Profile & Settings', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              isDark ? Colors.black : AppColors.primaryLight.withOpacity(0.4),
              Theme.of(context).scaffoldBackgroundColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            children: [
              _buildProfileHeader(context, savedEmail).animate().fadeIn(duration: 500.ms).slideY(begin: -0.2),
              const SizedBox(height: 32),
              Text('PREFERENCES', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.grey, letterSpacing: 1.5)).animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 12),
              _buildSettingsCard(
                context: context,
                children: [
                  _buildListTile(
                    icon: Icons.dark_mode,
                    iconColor: Colors.deepPurple,
                    title: 'Dark Mode',
                    trailing: Switch(
                      value: isDark,
                      activeColor: AppColors.primary,
                      onChanged: (val) => ref.read(themeModeProvider.notifier).toggleTheme(),
                    ),
                  ),
                ],
              ).animate().slideX(delay: 300.ms),
              const SizedBox(height: 24),
              Text('DATA & SYNC', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.grey, letterSpacing: 1.5)).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 12),
              _buildSettingsCard(
                context: context,
                children: [
                  _buildListTile(
                    icon: Icons.cloud_sync,
                    iconColor: Colors.blue,
                    title: 'Sync Offline Data',
                    subtitle: 'Back up your meals to the cloud',
                    onTap: () async => _handleSync(context, ref),
                  ),
                  const Divider(height: 1, indent: 56),
                  _buildListTile(
                    icon: Icons.delete_sweep,
                    iconColor: Colors.redAccent,
                    title: 'Clear Local Storage',
                    subtitle: 'Free up space on your device',
                    onTap: () async => _handleClearData(context, ref),
                  ),
                ],
              ).animate().slideX(delay: 500.ms),
              const SizedBox(height: 24),
              Text('ACCOUNT', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.grey, letterSpacing: 1.5)).animate().fadeIn(delay: 600.ms),
              const SizedBox(height: 12),
              _buildSettingsCard(
                context: context,
                children: [
                  _buildListTile(
                    icon: Icons.logout,
                    iconColor: Colors.red,
                    title: 'Sign Out',
                    titleColor: Colors.red,
                    onTap: () async {
                      try {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        await ref.read(authControllerProvider).signOut();
                      } catch (e) {
                        debugPrint("Sign out error: $e");
                      }
                    },
                  ),
                ],
              ).animate().slideX(delay: 700.ms),
              const SizedBox(height: 40),
              Center(
                child: Column(
                  children: [
                    Text('Smart Meal Planner', style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 4),
                    const Text('Version 1.0.0 • Developed for Practical Exam', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ).animate().fadeIn(delay: 800.ms),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, String email) {
    final name = email.split('@').first.toUpperCase();
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Text(
              name.isNotEmpty ? name[0] : '?',
              style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withOpacity(0.8)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(12)),
                  child: const Text('Premium Member', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({required BuildContext context, required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    Color? titleColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: iconColor.withOpacity(0.1), shape: BoxShape.circle),
        child: Icon(icon, color: iconColor),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: titleColor)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      trailing: trailing ?? (onTap != null ? const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey) : null),
      onTap: onTap,
    );
  }

  Future<void> _handleSync(BuildContext context, WidgetRef ref) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (c) => const Center(child: CircularProgressIndicator()),
      );
      final count = await ref.read(syncServiceProvider).syncPendingData(ref.read(mealRepositoryProvider));
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(count > 0 ? 'Synced $count meals successfully' : 'All data is up to date')));
        ref.read(mealsProvider.notifier).loadMeals();
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sync failed: $e')));
      }
    }
  }

  Future<void> _handleClearData(BuildContext context, WidgetRef ref) async {
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
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All data cleared')));
      } catch (e) {
        await Hive.box('meals').clear();
        await Hive.box('nutrition').clear();
        ref.read(mealsProvider.notifier).loadMeals();
        if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All data cleared')));
      }
    }
  }
}
