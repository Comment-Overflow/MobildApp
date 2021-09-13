import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AdaptivePicker extends StatefulWidget {
  final List<String> _dropdownItems;
  final int _initialSelectedIndex;
  final Function(int index, String item) _onSelect;

  // IOS only.
  final double _fontSize;
  final double _maxHeight;
  final double _magnification;
  final double _itemExtent;
  late final Color _backgroundColor;

  AdaptivePicker(
      {required List<String> dropdownItems,
      required int initialSelectedIndex,
      required Function(int index, String item) onSelect,
      double fontSize = 16.0,
      double maxHeight = 150.0,
      double magnification = 1.0,
      double itemExtent = 36.0,
      Color? backgroundColor,
      Key? key})
      : _dropdownItems = dropdownItems,
        _initialSelectedIndex = initialSelectedIndex,
        _onSelect = onSelect,
        _fontSize = fontSize,
        _maxHeight = maxHeight,
        _magnification = magnification,
        _itemExtent = itemExtent,
        super(key: key) {
    _backgroundColor = (backgroundColor ?? Colors.grey[200])!;
  }

  @override
  _AdaptivePickerState createState() =>
      _AdaptivePickerState(_initialSelectedIndex);
}

class _AdaptivePickerState extends State<AdaptivePicker> {
  int _selectedIndex;

  _AdaptivePickerState(this._selectedIndex);

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid)
      return _buildAndroidDropdown();
    else
      return _buildIOSDropdown();
  }

  Widget _buildAndroidDropdown() {
    return DropdownButton<String>(
      underline: Container(),
      icon: Container(),
      value: widget._dropdownItems[_selectedIndex],
      // style: TextStyle(color: Colors.orange),
      onChanged: (String? value) {
        setState(() {
          _selectedIndex = widget._dropdownItems.indexOf(value!);
        });
        widget._onSelect(_selectedIndex, value!);
      },
      items:
          widget._dropdownItems.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildIOSDropdown() {
    return GestureDetector(
      onTap: _showPicker,
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 45.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget._dropdownItems[_selectedIndex],
              style: TextStyle(fontSize: widget._fontSize),
            ),
          ],
        ),
      ),
    );
  }

  _showPicker() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) {
          return ConstrainedBox(
            constraints: BoxConstraints(maxHeight: widget._maxHeight),
            child: CupertinoPicker(
              scrollController:
                  FixedExtentScrollController(initialItem: _selectedIndex),
              backgroundColor: widget._backgroundColor,
              onSelectedItemChanged: (index) {
                setState(() {
                  this._selectedIndex = index;
                });
                widget._onSelect(index, widget._dropdownItems[index]);
              },
              magnification: widget._magnification,
              itemExtent: widget._itemExtent,
              children:
                  List<Widget>.of(widget._dropdownItems.map((item) => Center(
                        child: Text(item),
                      ))),
            ),
          );
        });
  }
}
