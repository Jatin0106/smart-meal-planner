import 'package:hive/hive.dart';
import '../models/goal_model.dart';

class GoalRepository {
  final Box<GoalModel> _goalBox;

  GoalRepository(this._goalBox);

  Future<void> saveGoal(GoalModel goal) async {
    await _goalBox.put('user_goal', goal);
  }

  GoalModel getGoal() {
    return _goalBox.get('user_goal') ?? GoalModel(
      targetCalories: 2000,
      targetProtein: 150,
      targetCarbs: 250,
      targetFats: 65,
    );
  }
}
