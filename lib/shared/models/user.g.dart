// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 1;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as String,
      name: fields[1] as String,
      email: fields[2] as String?,
      isPremium: fields[3] as bool,
      premiumExpiryDate: fields[4] as DateTime?,
      createdAt: fields[5] as DateTime,
      lastActive: fields[6] as DateTime,
      totalDreams: fields[7] as int,
      lucidDreams: fields[8] as int,
      currentStreak: fields[9] as int,
      longestStreak: fields[10] as int,
      lastDreamDate: fields[11] as DateTime?,
      preferences: (fields[12] as Map).cast<String, dynamic>(),
      achievements: (fields[13] as List).cast<String>(),
      experiencePoints: fields[14] as int,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.isPremium)
      ..writeByte(4)
      ..write(obj.premiumExpiryDate)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.lastActive)
      ..writeByte(7)
      ..write(obj.totalDreams)
      ..writeByte(8)
      ..write(obj.lucidDreams)
      ..writeByte(9)
      ..write(obj.currentStreak)
      ..writeByte(10)
      ..write(obj.longestStreak)
      ..writeByte(11)
      ..write(obj.lastDreamDate)
      ..writeByte(12)
      ..write(obj.preferences)
      ..writeByte(13)
      ..write(obj.achievements)
      ..writeByte(14)
      ..write(obj.experiencePoints);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
