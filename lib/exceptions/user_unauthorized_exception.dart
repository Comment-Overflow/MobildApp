class UserUnauthorizedException implements Exception {
  String _message;

  UserUnauthorizedException([String message = 'User is not authorized.'])
      : _message = message;

  @override
  String toString() {
    return _message;
  }
}
