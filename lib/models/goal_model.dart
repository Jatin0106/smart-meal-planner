import 'package:hive/hive.dart';

class GoalModel extends HiveObject {
  double targetCalories;
  double targetProtein;
  double targetCarbs;
  double targetFats;

  GoalModel({
    required this.targetCalories,
    required this.targetProtein,
    required this.targetCarbs,
    required this.targetFats,
  });
}

class GoalModelAdapter extends TypeAdapter<GoalModel> {
  @override
  final int typeId = 2;

  @override
  GoalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GoalModel(
      targetCalories: fields[0] as double,
      targetProtein: fields[1] as double,
      targetCarbs: fields[2] as double,
      targetFats: fields[3] as double,
    );
  }

  @override
  void write(BinaryWriter writer, GoalModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.targetCalories)
      ..writeByte(1)
      ..write(obj.targetProtein)
      ..writeByte(2)
      ..write(obj.targetCarbs)
      ..writeByte(3)
      ..write(obj.targetFats);
  }
}
