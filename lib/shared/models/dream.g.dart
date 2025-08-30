// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dream.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DreamAdapter extends TypeAdapter<Dream> {
  @override
  final int typeId = 0;

  @override
  Dream read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Dream(
      id: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      summary: fields[3] as String?,
      imagePath: fields[4] as String?,
      createdAt: fields[5] as DateTime,
      dreamDate: fields[6] as DateTime?,
      tags: (fields[7] as List).cast<String>(),
      emotion: fields[8] as String?,
      isLucid: fields[9] as bool,
      lucidityLevel: fields[10] as double?,
      audioPath: fields[11] as String?,
      aiAnalysis: (fields[12] as Map?)?.cast<String, dynamic>(),
      isPremium: fields[13] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Dream obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.summary)
      ..writeByte(4)
      ..write(obj.imagePath)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.dreamDate)
      ..writeByte(7)
      ..write(obj.tags)
      ..writeByte(8)
      ..write(obj.emotion)
      ..writeByte(9)
      ..write(obj.isLucid)
      ..writeByte(10)
      ..write(obj.lucidityLevel)
      ..writeByte(11)
      ..write(obj.audioPath)
      ..writeByte(12)
      ..write(obj.aiAnalysis)
      ..writeByte(13)
      ..write(obj.isPremium);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DreamAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
