// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitAdapter extends TypeAdapter<Habit> {
  @override
  final int typeId = 0;

  @override
  Habit read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Habit(
      id: fields[0] as String,
      name: fields[1] as String,
      icon: fields[2] as String,
      colorValue: fields[3] as int,
      type: fields[4] as HabitType,
      targetValue: fields[5] as double,
      unit: fields[6] as String,
      frequency: fields[7] as Frequency,
      customDays: (fields[8] as List).cast<int>(),
      reminderTime: fields[9] as String?,
      createdAt: fields[10] as DateTime,
      sortOrder: fields[11] as int,
      isArchived: fields[12] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Habit obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.icon)
      ..writeByte(3)
      ..write(obj.colorValue)
      ..writeByte(4)
      ..write(obj.type)
      ..writeByte(5)
      ..write(obj.targetValue)
      ..writeByte(6)
      ..write(obj.unit)
      ..writeByte(7)
      ..write(obj.frequency)
      ..writeByte(8)
      ..write(obj.customDays)
      ..writeByte(9)
      ..write(obj.reminderTime)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.sortOrder)
      ..writeByte(12)
      ..write(obj.isArchived);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
