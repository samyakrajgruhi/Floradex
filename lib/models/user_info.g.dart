// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserInfoAdapter extends TypeAdapter<UserInfo> {
  @override
  final int typeId = 1;

  @override
  UserInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserInfo()
      ..userId = fields[0] as String
      ..userName = fields[1] as String
      ..userEmail = fields[2] as String
      ..rankName = fields[3] as String
      ..userProgress = fields[4] as int
      ..profileImagePath = fields[5] as String
      ..unlockedAchievementIds = (fields[6] as List).cast<String>()
      ..lastScanDate = fields[7] as DateTime?
      ..currentStreak = fields[8] as int
      ..longestStreak = fields[9] as int
      ..earlyScanCount = fields[10] as int
      ..nightScanCount = fields[11] as int
      ..distinctScanDays = fields[12] as int;
  }

  @override
  void write(BinaryWriter writer, UserInfo obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.userName)
      ..writeByte(2)
      ..write(obj.userEmail)
      ..writeByte(3)
      ..write(obj.rankName)
      ..writeByte(4)
      ..write(obj.userProgress)
      ..writeByte(5)
      ..write(obj.profileImagePath)
      ..writeByte(6)
      ..write(obj.unlockedAchievementIds)
      ..writeByte(7)
      ..write(obj.lastScanDate)
      ..writeByte(8)
      ..write(obj.currentStreak)
      ..writeByte(9)
      ..write(obj.longestStreak)
      ..writeByte(10)
      ..write(obj.earlyScanCount)
      ..writeByte(11)
      ..write(obj.nightScanCount)
      ..writeByte(12)
      ..write(obj.distinctScanDays);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
