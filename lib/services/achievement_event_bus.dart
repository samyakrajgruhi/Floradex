import 'dart:async';

sealed class AchievementEvent {
  const AchievementEvent();
}

class ScanCompleted extends AchievementEvent {
  final DateTime when;
  const ScanCompleted(this.when);
}

class AchievementEventBus {
  AchievementEventBus._();
  static final AchievementEventBus instance = AchievementEventBus._();
  final _controller = StreamController<AchievementEvent>.broadcast();

  Stream<T> on<T extends AchievementEvent>() =>
      _controller.stream.where((e) => e is T).cast<T>();

  void publish(AchievementEvent event) => _controller.add(event);

  Future<void> dispose() => _controller.close();
}
