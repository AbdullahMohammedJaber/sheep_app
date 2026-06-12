import 'package:sheep/core/data/response/auth/user_response.dart';
import 'package:sheep/util/storge/storge.dart';
import 'package:sheep/util/storge/storge_key.dart';

class HelperAuth {
  setUser(UserResponse user) {
    AppStorage.write(StorageKeys.userData, user.toJson());
  }

  UserResponse ?getUser() {
    final data = AppStorage.read(StorageKeys.userData);
    if (data != null) {
      return UserResponse.fromJson(data);
    }
    return null;
  }

  setLogin(bool login) {
    AppStorage.write(StorageKeys.isLoggedIn, login);
  }

  bool getLogin() {
    return AppStorage.read(StorageKeys.isLoggedIn) ?? false;
  }

  logoutUser() {
    AppStorage.remove(StorageKeys.userData);
    AppStorage.remove(StorageKeys.isLoggedIn);
  }

  loginUser(UserResponse user) {
    setUser(user);
    setLogin(true);
  }
}
