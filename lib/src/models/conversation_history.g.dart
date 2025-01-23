// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_history.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConversationHistoryAdapter extends TypeAdapter<ConversationHistory> {
  @override
  final int typeId = 2;

  @override
  ConversationHistory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConversationHistory(
      timestamp: fields[0] as DateTime,
      role: fields[1] as String,
      content: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ConversationHistory obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.timestamp)
      ..writeByte(1)
      ..write(obj.role)
      ..writeByte(2)
      ..write(obj.content);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConversationHistoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
