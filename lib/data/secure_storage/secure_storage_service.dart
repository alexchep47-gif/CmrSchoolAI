import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  SecureStorageService({FlutterSecureStorage? storage}) : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static const _keyName = 'cmr_school_ai_hive_key';

  Future<String> hiveEncryptionKey() async {
    final existing = await _storage.read(key: _keyName);
    if (existing != null && existing.isNotEmpty) return existing;
    final bytes = List<int>.generate(32, (_) => Random.secure().nextInt(256));
    final digest = sha256.convert(bytes);
    final key = base64UrlEncode(digest.bytes);
    await _storage.write(key: _keyName, value: key);
    return key;
  }

  Future<void> clearAll() async => _storage.deleteAll();
}
