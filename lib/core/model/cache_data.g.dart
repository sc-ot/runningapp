// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CacheDataAdapter extends TypeAdapter<CacheData> {
  @override
  final int typeId = 1;

  @override
  CacheData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CacheData()
      ..path = fields[1] as String
      ..body = fields[2] as dynamic
      ..headers = fields[3] as dynamic
      ..queryParams = fields[4] as dynamic
      ..timestamp = fields[5] as DateTime
      ..response = fields[6] as String?;
  }

  @override
  void write(BinaryWriter writer, CacheData obj) {
    writer
      ..writeByte(6)
      ..writeByte(1)
      ..write(obj.path)
      ..writeByte(2)
      ..write(obj.body)
      ..writeByte(3)
      ..write(obj.headers)
      ..writeByte(4)
      ..write(obj.queryParams)
      ..writeByte(5)
      ..write(obj.timestamp)
      ..writeByte(6)
      ..write(obj.response);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CacheDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
