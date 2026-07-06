import 'package:floradex/models/user_info.dart';
import 'package:hive/hive.dart';

class UserService {
  Future<UserInfo> getUserInfo() async {
    final box = await Hive.openBox<UserInfo>('user_data');
    final userInfo = box.get('current_user');

    if (userInfo == null) {
      throw StateError('User info not found');
    }

    return userInfo;
  }

  Future<void> incrementProgress(int n) async {
    final box = await Hive.openBox<UserInfo>('user_data');
    final userInfo = box.get('current_user');
    if (userInfo == null) throw StateError('User info not found');
    userInfo.userProgress += n;
    await box.put('current_user', userInfo);
  }
}
