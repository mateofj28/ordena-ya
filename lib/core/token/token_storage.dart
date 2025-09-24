// core/token/token_storage.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  final FlutterSecureStorage _storage;

  TokenStorage(this._storage);

  Future<void> saveToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'access_token');
  }

  Future<void> clearToken() async {
    await _storage.delete(key: 'access_token');
  }
}
