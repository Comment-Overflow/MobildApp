import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// The button is composed of a list of widgets arranged vertically.
/// Tap of the button will trigger a route jump.
class MultipleWidgetButton extends StatelessWidget {
  final String? _routeName;
  final List<Widget> _widgets;
  final _arguments;

  const MultipleWidgetButton(this._routeName, this._widgets,
      {Key? key, arguments})
      : this._arguments = arguments,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (_routeName != null)
          Navigator.pushNamed(context, _routeName!, arguments: this._arguments);
      },
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _widgets,
      ),
    );
  }
}
