import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class MealModel extends HiveObject {
  String id;
  String mealType; // Breakfast, Lunch, Dinner, Snacks
  String foodName;
  double quantity;
  double calories;
  double protein;
  double carbs;
  double fats;
  DateTime dateTime;
  bool isSynced;

  MealModel({
    String? id,
    required this.mealType,
    required this.foodName,
    required this.quantity,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.dateTime,
    this.isSynced = false,
  }) : id = id ?? const Uuid().v4();
}

class MealModelAdapter extends TypeAdapter<MealModel> {
  @override
  final int typeId = 0;

  @override
  MealModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MealModel(
      id: fields[0] as String,
      mealType: fields[1] as String,
      foodName: fields[2] as String,
      quantity: fields[3] as double,
      calories: fields[4] as double,
      protein: fields[5] as double,
      carbs: fields[6] as double,
      fats: fields[7] as double,
      dateTime: fields[8] as DateTime,
      isSynced: fields[9] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, MealModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.mealType)
      ..writeByte(2)
      ..write(obj.foodName)
      ..writeByte(3)
      ..write(obj.quantity)
      ..writeByte(4)
      ..write(obj.calories)
      ..writeByte(5)
      ..write(obj.protein)
      ..writeByte(6)
      ..write(obj.carbs)
      ..writeByte(7)
      ..write(obj.fats)
      ..writeByte(8)
      ..write(obj.dateTime)
      ..writeByte(9)
      ..write(obj.isSynced);
  }
}
