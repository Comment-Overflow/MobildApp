class LoginDTO {
  String token;
  int userId;
  String userName;
  String avatarUrl;

  LoginDTO(this.token, this.userId, this.userName, this.avatarUrl);

  LoginDTO.fromJson(Map<String, dynamic> json)
      : token = json['token'],
        userId = json['userId'],
        userName = json['userName'],
        avatarUrl = json['avatarUrl'];

  Map<String, dynamic> toJson() => {
        'token': token,
        'userId': userId,
        'userName': userName,
        'avatarUrl': avatarUrl,
      };
}
