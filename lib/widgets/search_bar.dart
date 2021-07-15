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
  final String defaultText;
  final _controller = FSearchController();

  SearchBar(
      {Key? key,
      this.onSearch,
      this.enable = true,
      this.onTap,
      this.autoFocus = false,
      this.defaultText = ""})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  String _text = "";

  @override
  void initState() {
    super.initState();
    // Update text on input field change.
    if (widget.defaultText.isNotEmpty) {
      _text = widget.defaultText;
      // Must be called after first build.
      WidgetsBinding.instance!.addPostFrameCallback(
          (_) => widget._controller.text = widget.defaultText);
    }

    if (widget.autoFocus) {
      WidgetsBinding.instance!
          .addPostFrameCallback((_) => widget._controller.requestFocus());
    }

    widget._controller.setListener(() {
      setState(() {
        _text = widget._controller.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FSearch(
      controller: widget._controller,
      height: Constants.searchBarHeight,
      cursorWidth: 1.0,
      corner: FSearchCorner.all(18.0),
      backgroundColor: CustomColors.lightGrey,
      style: TextStyle(fontSize: 16.0, height: 1.2, color: Color(0xff333333)),
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
      suffixes: this._text.isNotEmpty && widget._controller.focus
          ? [
              const SizedBox(width: 3.0),
              GestureDetector(
                onTap: () {
                  widget._controller.text = "";
                },
                child: Icon(
                  Icons.cancel,
                  size: 20,
                  color: Colors.grey[400],
                ),
              ),
              const SizedBox(width: 10.0),
            ]
          : [],
      hints: [
        "搜索...",
        "",
      ],
      onSearch: (text) {
        if (text.isNotEmpty) {
          widget.onSearch(text);
        } else {
          widget._controller.requestFocus();
        }
      },
      onTap: widget.onTap,
      enable: widget.enable,
    );
  }
}
