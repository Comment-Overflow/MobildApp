import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CrossPlatformAlertDialog extends StatelessWidget {

  final String? _titleText;
  final String? _contentText;
  final String _approveText;
  final String _disapproveText;
  final VoidCallback _approveCallback;
  final VoidCallback _disapproveCallback;

  const CrossPlatformAlertDialog(
    this._titleText,
    this._contentText,
    this._approveText,
    this._disapproveText,
    this._approveCallback,
    this._disapproveCallback,
    {Key? key}
  ) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Text? title = _titleText != null ?  Text(_titleText!) : null;
    Text? content = _contentText != null ? Text(_contentText!) : null;
    Widget androidApproveButton = TextButton(
      onPressed: _approveCallback,
      child: Text(_approveText)
    );
    Widget androidDisapproveButton = TextButton(
        onPressed: _disapproveCallback,
        child: Text(_disapproveText)
    );

    if (Platform.isIOS) {
      return CupertinoAlertDialog(
        title: title,
        content: SingleChildScrollView(
          child: content,
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            onPressed: _approveCallback,
            child: Text(_approveText),
          ),
          CupertinoDialogAction(
            onPressed: _disapproveCallback,
            child: Text(_disapproveText),
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
            onPressed: _approveCallback,
            child: Text(_approveText),
          ),
          TextButton(
            onPressed: _disapproveCallback,
            child: Text(_disapproveText),
          ),
        ],
      );
    }
  }
}

