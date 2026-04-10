import 'dart:ffi';

import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
part 'plant_record.g.dart';

@HiveType(typeId: 0)
class PlantRecord extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String imagePath;

  @HiveField(2)
  late String plantName;

  @HiveField(3)
  late String scientificName;

  @HiveField(4)
  late String rarity;

  @HiveField(5)
  late String environment;

  @HiveField(6)
  late List<String> medicalUses;

  @HiveField(7)
  late String edibility;

  @HiveField(8)
  late String taste;

  @HiveField(9)
  late String harvestSeason;

  @HiveField(10)
  late String growthTime;

  @HiveField(11)
  late String origin;

  @HiveField(12)
  late List<String> facts;
}
