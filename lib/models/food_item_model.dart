import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

class FoodItemModel extends HiveObject {
  String id;
  String name;
  double defaultCalories;
  double protein;
  double carbs;
  double fats;
  bool isCustom;

  FoodItemModel({
    String? id,
    required this.name,
    required this.defaultCalories,
    required this.protein,
    required this.carbs,
    required this.fats,
    this.isCustom = false,
  }) : id = id ?? const Uuid().v4();
}

class FoodItemModelAdapter extends TypeAdapter<FoodItemModel> {
  @override
  final int typeId = 1;

  @override
  FoodItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FoodItemModel(
      id: fields[0] as String,
      name: fields[1] as String,
      defaultCalories: fields[2] as double,
      protein: fields[3] as double,
      carbs: fields[4] as double,
      fats: fields[5] as double,
      isCustom: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, FoodItemModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.defaultCalories)
      ..writeByte(3)
      ..write(obj.protein)
      ..writeByte(4)
      ..write(obj.carbs)
      ..writeByte(5)
      ..write(obj.fats)
      ..writeByte(6)
      ..write(obj.isCustom);
  }
}
