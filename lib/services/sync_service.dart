import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/meal_repository.dart';
import 'connectivity_service.dart';

final syncServiceProvider = Provider<SyncService>((ref) {
  // We'll pass the repository via provider later. This is a skeletal injection for the idea.
  return SyncService();
});

class SyncService {
  Future<int> syncPendingData(MealRepository mealRepo) async {
    final unsynced = mealRepo.getUnsyncedMeals();
    if (unsynced.isEmpty) return 0;

    // Simulate network delay for syncing
    await Future.delayed(const Duration(seconds: 2));

    // Mark as synced
    await mealRepo.markAsSynced(unsynced.map((e) => e.id).toList());
    
    return unsynced.length;
  }
}
