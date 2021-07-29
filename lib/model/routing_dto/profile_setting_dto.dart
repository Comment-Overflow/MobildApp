import 'package:comment_overflow/assets/constants.dart';

class ProfileSettingDto {
  int userId;
  String? userAvatar;
  String brief;
  String userName;
  Gender gender;

  ProfileSettingDto(this.userId, this.userAvatar, this.brief, this.userName, this.gender);
}