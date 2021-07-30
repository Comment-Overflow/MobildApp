import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/response_dto/login_dto.dart';
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

  Future configOnLogin(LoginDTO loginDTO) async {
    await StorageUtil()
        .storage
        .write(key: Constants.token, value: loginDTO.token);
    await StorageUtil()
        .storage
        .write(key: Constants.userId, value: loginDTO.userId.toString());
    await StorageUtil()
        .storage
        .write(key: Constants.userName, value: loginDTO.userName);
    await StorageUtil()
        .storage
        .write(key: Constants.avatarUrl, value: loginDTO.avatarUrl);
    await StorageUtil().storage.delete(key: Constants.emailToken);
  }

  Future deleteOnLogout() async {
    await StorageUtil().storage.delete(key: Constants.token);
    await StorageUtil().storage.delete(key: Constants.userId);
    await StorageUtil().storage.delete(key: Constants.userName);
    await StorageUtil().storage.delete(key: Constants.avatarUrl);
    await StorageUtil().storage.delete(key: Constants.searchHistory);
  }

  Future writeOnProfileChange(String userName, String avatarUrl) async {
    StorageUtil().storage.write(key: Constants.userName, value: userName);
    StorageUtil().storage.write(key: Constants.avatarUrl, value: avatarUrl);
  }
}
