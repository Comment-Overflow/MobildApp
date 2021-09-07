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
    print(loginDTO.token);
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
    _loginInfo.userType = loginDTO.userType;
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
  static const notLoggedInUserType = UserType.Unauthorized;

  int? _userId;
  UserType? _userType;

  int get userId => _userId == null ? notLoggedInId : _userId!;
  UserType get userType => _userType == null ? notLoggedInUserType : _userType!;

  set userId(int value) {
    _userId = value;
  }

  set userType(UserType userType) {
    _userType = userType;
  }
}
