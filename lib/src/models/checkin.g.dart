// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkin.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CheckinAdapter extends TypeAdapter<Checkin> {
  @override
  final int typeId = 0;

  @override
  Checkin read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Checkin(
      time: fields[0] as TimeOfDay,
      note: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Checkin obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.time)
      ..writeByte(1)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CheckinAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
