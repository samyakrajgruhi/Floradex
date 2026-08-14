// ignore_for_file: unused_field

import 'dart:async';

import 'package:floradex/models/user_info.dart';
import 'package:floradex/services/achievement_event_bus.dart';
import 'package:floradex/services/achievement_service.dart';
import 'package:floradex/services/stats_service.dart';
import 'package:floradex/services/user_service.dart';
import 'package:floradex/widgets/achievement_unlock_popup.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AchievementEventBusScope extends StatefulWidget {
  final Widget child;
  const AchievementEventBusScope({super.key, required this.child});

  @override
  State<AchievementEventBusScope> createState() =>
      _AchievementEventBusScopeState();
}

bool _evaluating = false;

class _AchievementEventBusScopeState extends State<AchievementEventBusScope> {
  final _bus = AchievementEventBus.instance;
  final _userService = UserService();
  final _achievements = AchievementService();
  final _statsService = StatsService();

  final _pending = <Achievement>[];
  bool _showing = false;

  late final List<StreamSubscription> _subs;

  @override
  void initState() {
    super.initState();
    _subs = [
      _bus.on<ScanCompleted>().listen(_handleScan),
    ];
  }

  Future<void> _handleScan(ScanCompleted e) async {
    await _statsService.recordScan(e.when);
    await _evaluateAndQueue();
  }

  Future<void> _evaluateAndQueue() async {
    if (_evaluating) return;
    _evaluating = true;
    try {
      final user = await _userService.getUserInfo();
      final newScans = await _achievements.evaluateAndCollectNew(user);
      if (newScans.isEmpty) return;

      final userBox = await Hive.openBox<UserInfo>('user_data');

      user.unlockedAchievementIds = {
        ...user.unlockedAchievementIds,
        ...newScans.map((a) => a.id),
      }.toList();

      await userBox.put('current_user', user);

      _pending.addAll(newScans);
      _maybeShowNext();
    } finally {
      _evaluating = false;
    }
  }

  void _maybeShowNext() {
    if (_showing || _pending.isEmpty) return;
    _showing = true;
    final next = _pending.removeAt(0);

    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => AchievementUnlockPopup(
        achievement: next,
        onDismiss: () {
          entry.remove();
          _showing = false;
          _maybeShowNext();
        },
      ),
    );
    overlay.insert(entry);
  }

  @override
  void dispose() {
    for (final s in _subs) s.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) => widget.child;
}
