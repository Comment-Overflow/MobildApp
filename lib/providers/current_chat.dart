import 'package:flutter/cupertino.dart';

class CurrentChat extends ChangeNotifier {
  Key? _currentPrivateChatPageKey;

  Key? get currentPrivateChatPageKey => _currentPrivateChatPageKey;

  void enterPrivateChatPage(Key key) {
    _currentPrivateChatPageKey = key;
    notifyListeners();
  }

  void leavePrivateChatPage() {
    _currentPrivateChatPageKey = null;
    notifyListeners();
  }
}