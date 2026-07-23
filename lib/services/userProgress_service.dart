// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Rank {
  final String id;
  final String title;
  final int threshold;
  final String dashboardText;
  final String popupText;
  final String iconPath;

  const Rank({
    required this.id,
    required this.title,
    required this.threshold,
    required this.dashboardText,
    required this.popupText,
    required this.iconPath,
  });

  factory Rank.fromJson(Map<String, dynamic> j) => Rank(
    id: j['id'] as String,
    title: j['title'] as String,
    threshold: j['threshold'] as int,
    dashboardText: j['dashboardText'] as String,
    popupText: j['popupText'] as String,
    iconPath: j['icon'] as String,
  );
}

class UserProgressService {
  static final UserProgressService _i = UserProgressService._();
  factory UserProgressService() => _i;
  UserProgressService._();

  List<Rank>? _ranks;

  Future<List<Rank>?> loadRanks() async {
    if (_ranks != null) return _ranks!;
    final raw = await rootBundle.loadString('assets/ranks.json');
    final list = (json.decode(raw) as List)
        .map((e) => Rank.fromJson(e as Map<String, dynamic>))
        .toList();
    list.sort((a, b) => a.threshold.compareTo(b.threshold));
    _ranks = List.unmodifiable(list);
    return _ranks;
  }

  Future<Rank?> getRankForProgress(int progress) async {
    final ranks = await loadRanks();
    Rank? current = ranks?.first;
    for (final r in ranks!) {
      if (progress >= r.threshold) {
        current = r;
      } else {
        break;
      }
    }
    return current;
  }

  Future<Rank?> getNextRank(int progress) async {
    final ranks = await loadRanks();
    for (final r in ranks!) {
      if (progress < r.threshold) return r;
    }
    return null;
  }

  Future<double> progressRatioToNext(int progress) async {
    final ranks = await loadRanks();
    final current = await getRankForProgress(progress);
    final next = await getNextRank(progress);

    if (next == null) return 1.0;
    final span = next.threshold - current!.threshold;
    if (span <= 0) return 1.0;
    return (progress - current.threshold) / span;
  }
}
