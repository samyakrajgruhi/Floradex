import 'dart:io';

import 'package:floradex/models/plant_record.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseService {
  Future<void> savePlantToVault(
    Map<String, dynamic> plantDetails,
    XFile imageFile,
  ) async {
    final box = await Hive.openBox<PlantRecord>('plants_vault');
    final itemId = plantDetails['scientific_name']
        .toString()
        .toLowerCase()
        .replaceAll(' ', '_');
    if (box.containsKey(itemId)) {
      return;
    }
    final directory = await getApplicationDocumentsDirectory();
    final String fileName =
        DateTime.now().millisecondsSinceEpoch.toString() + '.jpg';

    final String permenantImagePath = '${directory.path}/$fileName';
    await File(imageFile.path).copy(permenantImagePath);

    final finalPlantRecord = PlantRecord()
      ..id = itemId
      ..imagePath = permenantImagePath
      ..plantName = plantDetails['common_name'] ?? 'Unknown'
      ..scientificName = plantDetails['scientific_name'] ?? 'Unknown'
      ..rarity = plantDetails['rarity']?.toString() ?? '?'
      ..environment = plantDetails['environment'] ?? 'Unkown'
      ..medicalUses =
          (plantDetails['medical_uses'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          []
      ..edibility = plantDetails['edibility'] ?? 'Unknown'
      ..taste = plantDetails['taste'] ?? 'Unknown'
      ..harvestSeason = plantDetails['harvest_season'] ?? 'Unkown'
      ..growthTime = plantDetails['growth_time'] ?? 'Unkown'
      ..origin = plantDetails['origin'] ?? 'Unkown'
      ..facts =
          (plantDetails['facts'] as List?)?.map((e) => e.toString()).toList() ??
          [];

    await box.put(itemId, finalPlantRecord);
  }

  Future<List<PlantRecord>> fetchPlants() async {
    final box = await Hive.openBox<PlantRecord>('plants_vault');
    return box.values.toList();
  }

  Future<void> clearVault() async {
    final box = await Hive.openBox<PlantRecord>('plants_vault');
    await box.clear();
  }
}
