import 'package:hive/hive.dart';
part 'user_info.g.dart';

@HiveType(typeId: 1)
class UserInfo extends HiveObject {
  @HiveField(0)
  late String userId;

  @HiveField(1)
  late String userName;

  @HiveField(2)
  late String userEmail;

  @HiveField(3)
  late String rankName;

  @HiveField(4)
  late int userProgress;

  @HiveField(5)
  String profileImagePath = 'assets/default_profile/male1.png';

  @HiveField(6)
  List<String> unlockedAchievementIds = [];

  @HiveField(7)
  DateTime? lastScanDate;

  @HiveField(8)
  int currentStreak = 0;

  @HiveField(9)
  int longestStreak = 0;

  @HiveField(10)
  int earlyScanCount = 0;

  @HiveField(11)
  int nightScanCount = 0;

  @HiveField(12)
  int distinctScanDays = 0;
}
