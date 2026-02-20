import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:runpet_app/models/auth_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthSessionStorage {
  Future<AuthSessionModel?> read();

  Future<void> write(AuthSessionModel session);

  Future<void> clear();
}

class LocalAuthSessionStorage implements AuthSessionStorage {
  LocalAuthSessionStorage({
    FlutterSecureStorage? secureStorage,
  }) : _secureStorage = secureStorage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
            );

  static const _storageKey = 'runpet_auth_session';
  final FlutterSecureStorage _secureStorage;

  @override
  Future<AuthSessionModel?> read() async {
    final raw = await _readRaw();
    if (raw == null || raw.isEmpty) return null;
    final json = jsonDecode(raw) as Map<String, dynamic>;
    return AuthSessionModel.fromJson(json);
  }

  @override
  Future<void> write(AuthSessionModel session) async {
    final raw = jsonEncode(session.toJson());
    await _writeRaw(raw);
  }

  @override
  Future<void> clear() async {
    await _writeRaw(null);
  }

  Future<String?> _readRaw() async {
    if (kIsWeb) {
      final pref = await SharedPreferences.getInstance();
      return pref.getString(_storageKey);
    }
    return _secureStorage.read(key: _storageKey);
  }

  Future<void> _writeRaw(String? value) async {
    if (kIsWeb) {
      final pref = await SharedPreferences.getInstance();
      if (value == null) {
        await pref.remove(_storageKey);
      } else {
        await pref.setString(_storageKey, value);
      }
      return;
    }

    if (value == null) {
      await _secureStorage.delete(key: _storageKey);
    } else {
      await _secureStorage.write(key: _storageKey, value: value);
    }
  }
}
