// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlantRecordAdapter extends TypeAdapter<PlantRecord> {
  @override
  final int typeId = 0;

  @override
  PlantRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlantRecord()
      ..id = fields[0] as String
      ..imagePath = fields[1] as String
      ..plantName = fields[2] as String
      ..scientificName = fields[3] as String
      ..rarity = fields[4] as String
      ..environment = fields[5] as String
      ..medicalUses = (fields[6] as List).cast<String>()
      ..edibility = fields[7] as String
      ..taste = fields[8] as String
      ..harvestSeason = fields[9] as String
      ..growthTime = fields[10] as String
      ..origin = fields[11] as String
      ..facts = (fields[12] as List).cast<String>();
  }

  @override
  void write(BinaryWriter writer, PlantRecord obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imagePath)
      ..writeByte(2)
      ..write(obj.plantName)
      ..writeByte(3)
      ..write(obj.scientificName)
      ..writeByte(4)
      ..write(obj.rarity)
      ..writeByte(5)
      ..write(obj.environment)
      ..writeByte(6)
      ..write(obj.medicalUses)
      ..writeByte(7)
      ..write(obj.edibility)
      ..writeByte(8)
      ..write(obj.taste)
      ..writeByte(9)
      ..write(obj.harvestSeason)
      ..writeByte(10)
      ..write(obj.growthTime)
      ..writeByte(11)
      ..write(obj.origin)
      ..writeByte(12)
      ..write(obj.facts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
