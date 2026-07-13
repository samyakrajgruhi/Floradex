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
  late String profileImagePath;
}
