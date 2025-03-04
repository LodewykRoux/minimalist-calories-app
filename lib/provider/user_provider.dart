import 'package:calories_app/http/user_http.dart';
import 'package:calories_app/models/user.dart';
import 'package:calories_app/service/secure_storage_service.dart';
import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  User? user;

  User? get userDetails => user;

  /// Assigns [User] to user.
  Future<User?> validate(String userToken) async {
    final newUser = await HttpUserService().validate(userToken);
    user = newUser;
    notifyListeners();
    return user;
  }

  /// Assigns [User] to user.
  Future<User?> login(String email, String password) async {
    await SecureStorageService.instance.setAccessToken(null);
    final newUser = await HttpUserService().login(email, password);
    user = newUser;
    SecureStorageService.instance.setAccessToken(newUser.token);
    notifyListeners();
    return user;
  }

  /// Creates and assigns [User] to user.
  Future<User?> register(String name, String email, String password) async {
    await SecureStorageService.instance.setAccessToken(null);
    final newUser = await HttpUserService().signUp(name, email, password);
    user = newUser;
    await SecureStorageService.instance.setAccessToken(newUser.token);
    notifyListeners();
    return user;
  }

  /// Logs user out.
  Future<void> logout() async {
    await HttpUserService().logout();
    user = null;
    await SecureStorageService.instance.setAccessToken(null);
    notifyListeners();
  }
}
