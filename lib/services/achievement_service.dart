import 'dart:convert';
import 'package:floradex/models/user_info.dart';
import 'package:flutter/services.dart';

class Achievement {
  final String id;
  final String title;
  final String category;
  final String iconPath;
  final String iconLockedPath;
  final int target;
  final String counter;

  const Achievement({
    required this.id,
    required this.title,
    required this.category,
    required this.iconPath,
    required this.iconLockedPath,
    required this.target,
    required this.counter,
  });

  factory Achievement.fromJSON(Map<String, dynamic> j) => Achievement(
    id: j['id'] as String,
    title: j['title'] as String,
    category: j['category'] as String,
    iconPath: j['iconPath'] as String,
    iconLockedPath: j['iconLockedPath'] as String,
    target: j['target'] as int,
    counter: j['counter'] as String,
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
  static int byPlantType(String type) => 0;
  static int rareCount() => 0;
  static int uniqueSpeciesCount() => 0;
}

class AchievementService {
  static final AchievementService _i = AchievementService._();
  factory AchievementService() => _i;
  AchievementService._();

  List<Achievement>? _all;

  Future<List<Achievement>> loadAll() async {
    if (_all != null) return _all!;
    final raw = await rootBundle.loadString('assets/achievements.json');
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
