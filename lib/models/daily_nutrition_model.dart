import 'package:hive/hive.dart';

class DailyNutritionModel extends HiveObject {
  String date; // Format: yyyy-MM-dd
  double totalCalories;
  double totalProtein;
  double totalCarbs;
  double totalFats;

  DailyNutritionModel({
    required this.date,
    this.totalCalories = 0.0,
    this.totalProtein = 0.0,
    this.totalCarbs = 0.0,
    this.totalFats = 0.0,
  });
}

class DailyNutritionModelAdapter extends TypeAdapter<DailyNutritionModel> {
  @override
  final int typeId = 3;

  @override
  DailyNutritionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyNutritionModel(
      date: fields[0] as String,
      totalCalories: fields[1] as double,
      totalProtein: fields[2] as double,
      totalCarbs: fields[3] as double,
      totalFats: fields[4] as double,
    );
  }

  @override
  void write(BinaryWriter writer, DailyNutritionModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.date)
      ..writeByte(1)
      ..write(obj.totalCalories)
      ..writeByte(2)
      ..write(obj.totalProtein)
      ..writeByte(3)
      ..write(obj.totalCarbs)
      ..writeByte(4)
      ..write(obj.totalFats);
  }
}
