class LoginDTO {
  int userId;
  String token;

  LoginDTO(this.userId, this.token);

  LoginDTO.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        token = json['token'];

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'token': token,
      };
}
