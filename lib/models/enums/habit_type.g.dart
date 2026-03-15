// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitTypeAdapter extends TypeAdapter<HabitType> {
  @override
  final int typeId = 10;

  @override
  HabitType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return HabitType.boolean;
      case 1:
        return HabitType.quantity;
      case 2:
        return HabitType.count;
      case 3:
        return HabitType.duration;
      default:
        return HabitType.boolean;
    }
  }

  @override
  void write(BinaryWriter writer, HabitType obj) {
    switch (obj) {
      case HabitType.boolean:
        writer.writeByte(0);
        break;
      case HabitType.quantity:
        writer.writeByte(1);
        break;
      case HabitType.count:
        writer.writeByte(2);
        break;
      case HabitType.duration:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
