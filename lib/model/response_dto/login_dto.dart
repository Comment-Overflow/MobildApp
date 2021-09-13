import 'package:comment_overflow/assets/constants.dart';

class LoginDTO {
  String token;
  int userId;
  String userName;
  String avatarUrl;
  UserType userType;

  LoginDTO(this.token, this.userId, this.userName, this.avatarUrl, this.userType);

  LoginDTO.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        userId = json['userId'],
        userName = json['userName'],
        avatarUrl = json['avatarUrl'],
        userType = userTypeMap[json['userType']]!;

  Map<String, dynamic> toJson() => {
        'token': token,
        'userId': userId,
        'userName': userName,
        'avatarUrl': avatarUrl,
        'userType' : userTypeString[userType],
      };
}
