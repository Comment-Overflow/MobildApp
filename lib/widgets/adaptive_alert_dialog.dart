import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AdaptiveAlertDialog extends StatelessWidget {

  final String? _titleText;
  final String? _contentText;
  final String _okLabel;
  final String _cancelLabel;
  final VoidCallback _okCallback;
  final VoidCallback _cancelCallback;

  const AdaptiveAlertDialog(
    this._titleText,
    this._contentText,
    this._okLabel,
    this._cancelLabel,
    this._okCallback,
    this._cancelCallback,
    {Key? key}
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Text? title = _titleText != null ?  Text(_titleText!) : null;
    Text? content = _contentText != null ? Text(_contentText!) : null;
    Widget androidApproveButton = TextButton(
      onPressed: _okCallback,
      child: Text(_okLabel)
    );
    Widget androidDisapproveButton = TextButton(
        onPressed: _cancelCallback,
        child: Text(_cancelLabel)
    );

    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: title,
        content: SingleChildScrollView(
          child: content,
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: _okCallback,
            child: Text(_okLabel),
          ),
          CupertinoDialogAction(
            onPressed: _cancelCallback,
            child: Text(_cancelLabel),
            isDestructiveAction: true,
          ),
        ],
      );
    } else {
      return AlertDialog(
        title: title,
        content: SingleChildScrollView(
          child: content,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: _okCallback,
            child: Text(_okLabel),
          ),
          TextButton(
            onPressed: _cancelCallback,
            child: Text(_cancelLabel),
          ),
        ],
      );
    }
  }
}

