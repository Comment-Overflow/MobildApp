import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fsearch/fsearch.dart';
import 'package:zhihu_demo/assets/constants.dart';
import 'package:zhihu_demo/assets/custom_colors.dart';

class SearchBar extends StatefulWidget {
  final enable;
  final onTap;
  final onSearch;
  final autoFocus;
  final _controller = FSearchController();

  SearchBar({Key? key, this.onSearch, this.enable = true, this.onTap,
    this.autoFocus = false}) :
        super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String _text = "";

  @override
  void initState() {
    super.initState();
    // Update text on input field change.
    widget._controller.setListener(() {
      setState(() {_text = widget._controller.text;});
    });
    if (widget.autoFocus) {
      WidgetsBinding.instance!.addPostFrameCallback(
        (_) => widget._controller.requestFocus()
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FSearch(
      controller: widget._controller,
      height: Constants.searchBarHeight,
      cursorWidth: 1.0,
      corner: FSearchCorner.all(18.0),
      backgroundColor: CustomColors.lightGrey,
      style: TextStyle(
          fontSize: 16.0, height: 1.2, color: Color(0xff333333)),
      margin: EdgeInsets.only(left: 6.0),
      prefixes: [
        const SizedBox(width: 10.0),
        Icon(
          Icons.search,
          size: 20,
          color: Colors.grey[400],
        ),
        const SizedBox(width: 3.0)
      ],
      suffixes: this._text.isNotEmpty ? [
        const SizedBox(width: 3.0),
        GestureDetector(
          onTap: () { widget._controller.text = ""; },
          child: Icon(
            Icons.cancel,
            size: 20,
            color: Colors.grey[400],
          ),
        ),
        const SizedBox(width: 10.0),
      ] : [],
      hints: [
        "搜索...",
        "",
      ],
      onSearch: widget.onSearch,
      onTap: widget.onTap,
      enable: widget.enable,
    );
  }
}