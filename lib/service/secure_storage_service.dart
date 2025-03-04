import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const instance = SecureStorageService._();

  final _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );

  final _tokenKey = 'access_token';

  const SecureStorageService._();

  Future<String?> get accessToken => _storage.read(key: _tokenKey);
  Future<void> setAccessToken(String? _) async {
    _storage.write(
      key: _tokenKey,
      value: _,
    );
  }
}
