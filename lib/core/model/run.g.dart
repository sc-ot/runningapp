// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'run.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RunAdapter extends TypeAdapter<Run> {
  @override
  final int typeId = 2;

  @override
  Run read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Run(
      fields[1] as double,
      fields[2] as DateTime,
      fields[3] as double,
      fields[4] as double,
      fields[5] as int,
      fields[6] as int,
      fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Run obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.runDistance)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.caloriesBurned)
      ..writeByte(4)
      ..write(obj.avgSpeed)
      ..writeByte(5)
      ..write(obj.runHour)
      ..writeByte(6)
      ..write(obj.runMinutes)
      ..writeByte(7)
      ..write(obj.runSeconds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RunAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Run _$RunFromJson(Map<String, dynamic> json) {
  return Run(
    (json['runDistance'] as num).toDouble(),
    DateTime.parse(json['date'] as String),
    (json['caloriesBurned'] as num).toDouble(),
    (json['avgSpeed'] as num).toDouble(),
    json['runHour'] as int,
    json['runMinutes'] as int,
    json['runSeconds'] as int,
  );
}

Map<String, dynamic> _$RunToJson(Run instance) => <String, dynamic>{
      'runDistance': instance.runDistance,
      'date': instance.date.toIso8601String(),
      'caloriesBurned': instance.caloriesBurned,
      'avgSpeed': instance.avgSpeed,
      'runHour': instance.runHour,
      'runMinutes': instance.runMinutes,
      'runSeconds': instance.runSeconds,
    };
