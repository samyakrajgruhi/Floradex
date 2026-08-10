import 'dart:convert';
import 'package:floradex/models/plant_record.dart';
import 'package:floradex/models/user_info.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

enum Rarity { common, uncommon, rare, legendary }

extension RarityX on Rarity {
  String get label {
    switch (this) {
      case Rarity.common:
        return 'COMMON';
      case Rarity.uncommon:
        return 'UNCOMMON';
      case Rarity.rare:
        return 'RARE';
      case Rarity.legendary:
        return 'LEGENDARY';
    }
  }

  static Rarity parseRarity(String? raw) {
    switch (raw) {
      case 'uncommon':
        return Rarity.uncommon;
      case 'rare':
        return Rarity.rare;
      case 'legendary':
        return Rarity.legendary;
      case 'common':
      default:
        return Rarity.common;
    }
  }
}

class Achievement {
  final String id;
  final String title;
  final String category;
  final String iconPath;
  final String iconLockedPath;
  final int target;
  final String counter;
  final String description;
  final Rarity rarity;

  const Achievement({
    required this.id,
    required this.title,
    required this.category,
    required this.iconPath,
    required this.iconLockedPath,
    required this.target,
    required this.counter,
    required this.description,
    required this.rarity,
  });

  factory Achievement.fromJSON(Map<String, dynamic> j) => Achievement(
    id: j['id'] as String,
    title: j['title'] as String,
    category: j['category'] as String,
    iconPath: j['icon'] as String,
    iconLockedPath: j['iconLocked'] as String,
    target: j['target'] as int,
    counter: j['counter'] as String,
    description: (j['description'] as String?) ?? '',
    rarity: RarityX.parseRarity(j['rarity'] as String?),
  );

  bool isUnlockedFor(UserInfo user) => currentValueFor(user) >= target;
  int currentValueFor(UserInfo user) => CounterResolver.resolve(counter, user);

  double ratioFor(UserInfo user) {
    if (target <= 0) return 1.0;
    final v = currentValueFor(user);
    if (v >= target) return 1.0;
    return v / target;
  }
}

class CounterResolver {
  static int resolve(String counter, UserInfo user) {
    final parts = counter.split(':');
    final key = parts[0];
    final arg = parts.length > 1 ? parts[1] : null;

    switch (key) {
      case 'userProgress':
        return user.userProgress;

      case 'earlyScanCount':
        return user.earlyScanCount;

      case 'nightScanCount':
        return user.nightScanCount;

      case 'currentStreak':
        return user.currentStreak;

      case 'longestStreak':
        return user.longestStreak;

      case 'distinctScanDays':
        return user.distinctScanDays;

      case 'plantType':
        return CollectionCounter.byPlantType(arg ?? '');

      case 'rareCount':
        return CollectionCounter.rareCount();

      case 'uniqueSpeciesCount':
        return CollectionCounter.uniqueSpeciesCount();
    }
    return 0;
  }
}

class CollectionCounter {
  static int byPlantType(String type) {
    if (type.isEmpty) return 0;
    final box = Hive.box<PlantRecord>('plants_vault');
    return box.values
        .where(
          (p) => p.plantType.trim().toLowerCase() == type.trim().toLowerCase(),
        )
        .length;
  }

  static int rareCount() {
    final box = Hive.box<PlantRecord>('plants_vault');
    return box.values.where((p) => (int.tryParse(p.rarity))! >= 4).length;
  }

  static int uniqueSpeciesCount() {
    final box = Hive.box<PlantRecord>('plants_vault');
    return box.length;
  }
}

class AchievementService {
  static final AchievementService _i = AchievementService._();
  factory AchievementService() => _i;
  AchievementService._();

  List<Achievement>? _all;

  Future<List<Achievement>> loadAll() async {
    if (_all != null) return _all!;
    final raw = await rootBundle.loadString('lib/assets/achievements.json');
    final list = (json.decode(raw) as List)
        .map((e) => Achievement.fromJSON(e as Map<String, dynamic>))
        .toList();
    _all = List.unmodifiable(list);
    return _all!;
  }

  Future<List<Achievement>> unlockedFor(UserInfo user) async {
    final all = await loadAll();
    return all.where((a) => a.isUnlockedFor(user)).toList();
  }

  Future<List<Achievement>> evaluateAndCollectNew(UserInfo user) async {
    final all = await loadAll();
    final already = user.unlockedAchievementIds.toSet();
    return all
        .where((a) => !already.contains(a.id) && a.isUnlockedFor(user))
        .toList();
  }

  Future<Map<String, List<Achievement>>> grouped() async {
    final all = await loadAll();
    final map = <String, List<Achievement>>{};

    for (final a in all) {
      map.putIfAbsent(a.category, () => []).add(a);
    }

    return map;
  }
}
