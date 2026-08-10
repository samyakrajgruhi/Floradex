import 'package:floradex/models/user_info.dart';
import 'package:hive/hive.dart';

class StatsService {
  Future<void> recordScan(DateTime when) async {
    final box = await Hive.openBox<UserInfo>('user_data');
    final user = box.get('current_user')!;

    // early -> before 8am, night -> after 6pm
    if (when.hour < 8) user.earlyScanCount++;
    if (when.hour >= 18) user.nightScanCount++;

    //streaks
    final today = DateTime(when.year, when.month, when.day);
    final last = user.lastScanDate;
    if (last == null) {
      user.currentStreak = 1;
    } else {
      final lastDay = DateTime(last.year, last.month, last.day);
      final diff = today.difference(lastDay).inDays;
      if (diff == 0) {
      } else if (diff == 1) {
        user.currentStreak++;
      } else {
        user.currentStreak = 1;
      }
    }

    if (user.currentStreak > user.longestStreak) {
      user.longestStreak = user.currentStreak;
    }
    user.lastScanDate = when;

    await box.put('current_user', user);
  }
}
