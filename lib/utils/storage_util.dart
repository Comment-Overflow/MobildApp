import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/response_dto/login_dto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageUtil {
  _LoginInfo _loginInfo;

  // Singleton method.
  factory StorageUtil() => _getInstance();
  static StorageUtil _instance = StorageUtil._internal();

  static StorageUtil _getInstance() {
    return _instance;
  }

  final FlutterSecureStorage _storage = FlutterSecureStorage();

  FlutterSecureStorage get storage => _storage;
  _LoginInfo get loginInfo => _loginInfo;

  StorageUtil._internal() : _loginInfo = _LoginInfo();

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

    _loginInfo.userId = loginDTO.userId;
  }

  Future deleteOnLogout() async {
    await StorageUtil().storage.delete(key: Constants.token);
    await StorageUtil().storage.delete(key: Constants.userId);
    await StorageUtil().storage.delete(key: Constants.userName);
    await StorageUtil().storage.delete(key: Constants.avatarUrl);
    await StorageUtil().storage.delete(key: Constants.searchHistory);

    _loginInfo.userId = _LoginInfo.notLoggedInId;
  }

  Future writeOnProfileChange(String userName, String avatarUrl) async {
    StorageUtil().storage.write(key: Constants.userName, value: userName);
    StorageUtil().storage.write(key: Constants.avatarUrl, value: avatarUrl);
  }
}

class _LoginInfo {
  static const notLoggedInId = 0;

  int? _userId;

  int get userId => _userId == null ? notLoggedInId : _userId!;

  set userId(int value) {
    _userId = value;
  }
}
