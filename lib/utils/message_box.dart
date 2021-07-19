import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_colors.dart';

class MessageBox {
  static const MethodChannel _channel =
      const MethodChannel('PonnamKarthik/fluttertoast');

  static Future<bool?> cancel() async {
    bool? res = await _channel.invokeMethod("cancel");
    return res;
  }

  static Future<bool?> showToast({
    required String msg,
    required MessageBoxType messageBoxType,
    int timeInSecForIosWeb = 1,
    bool webShowClose = false,
    webBgColor: "linear-gradient(to right, #00b09b, #96c93d)",
    webPosition: "right",
  }) async {
    Color textColor = Colors.white;
    late Color backgroundColor;
    switch (messageBoxType) {
      case MessageBoxType.Info:
        backgroundColor = CustomColors.messageBoxInfo;
        break;
      case MessageBoxType.Error:
        backgroundColor = CustomColors.messageBoxError;
        break;
      case MessageBoxType.Success:
        backgroundColor = CustomColors.messageBoxSuccess;
        break;
    }
    String toast = "short";

    String gravityToast = "center";

    final Map<String, dynamic> params = <String, dynamic>{
      'msg': msg,
      'length': toast,
      'time': timeInSecForIosWeb,
      'gravity': gravityToast,
      'bgcolor': backgroundColor.value,
      'textcolor': textColor.value,
      'fontSize': Constants.messageBoxFontSize,
      'webShowClose': webShowClose,
      'webBgColor': webBgColor,
      'webPosition': webPosition,
    };

    bool? res = await _channel.invokeMethod('showToast', params);
    return res;
  }
}
