import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageUtil {
  // Singleton method.
  factory StorageUtil() => _getInstance();
  static StorageUtil _instance = StorageUtil._internal();

  static StorageUtil _getInstance() {
    return _instance;
  }

  final FlutterSecureStorage _storage = FlutterSecureStorage();

  FlutterSecureStorage get storage => _storage;

  StorageUtil._internal();
}
