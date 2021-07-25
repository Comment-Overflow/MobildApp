import 'dart:convert';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:comment_overflow/utils/storage_util.dart';
import 'package:comment_overflow/widgets/adaptive_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchHistoryGrid extends StatefulWidget {
  final List _searchHistory;

  const SearchHistoryGrid(this._searchHistory, {Key? key}) : super(key: key);

  @override
  _SearchHistoryGridState createState() => _SearchHistoryGridState();
}

class _SearchHistoryGridState extends State<SearchHistoryGrid> {
  static final Color? _deleteColor = Colors.grey[600];
  static const double _headerFontSize = 17;

  late final List _searchHistory;
  bool _isEditing = false;

  @override
  initState() {
    _searchHistory = widget._searchHistory;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "搜索历史",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: _headerFontSize,
            ),
          ),
          _buildDeleteOptions(),
        ],
      ),
      SizedBox(height: 10.0),
      Expanded(
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (overScroll) {
            overScroll.disallowGlow();
            return true;
          },
          child: StaggeredGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 4.5,
            crossAxisSpacing: 4,
            staggeredTiles: _searchHistory
                .map<StaggeredTile>((_) => StaggeredTile.fit(1))
                .toList(),
            children: _searchHistory
                .asMap()
                .entries
                .map((entry) => Padding(
                    padding: EdgeInsets.only(right: 4.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: 20),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: _buildHistoryItem(entry),
                      ),
                    )))
                .toList(),
          ),
        ),
      ),
    ]);
  }

  _buildDeleteOptions() {
    return !_isEditing
        ? GestureDetector(
            onTap: () {
              setState(() {
                _isEditing = true;
              });
            },
            child: CustomStyles.getDefaultDeleteIcon(
              size: 18.0,
              color: _deleteColor,
            ),
          )
        : Row(children: [
            GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AdaptiveAlertDialog(
                            '删除全部', '确认删除全部历史记录?', "确定", "取消", () {
                          _deleteAll();
                          Navigator.of(context).pop();
                        }, () => Navigator.of(context).pop());
                      });
                },
                child: Text('删除全部',
                    style: TextStyle(
                      fontSize: _headerFontSize - 2,
                      color: _deleteColor,
                    ))),
            SizedBox(width: 20),
            GestureDetector(
                onTap: () {
                  setState(() {
                    _isEditing = false;
                  });
                },
                child: Text('完成',
                    style: TextStyle(
                      fontSize: _headerFontSize - 2,
                      color: _deleteColor,
                    ))),
          ]);
  }

  _buildHistoryItem(MapEntry<int, dynamic> entry) => GestureDetector(
        onTap: () => Navigator.of(context).pushNamed(
            RouteGenerator.searchResultRoute,
            arguments: entry.value),
        child: Chip(
            deleteIcon: Icon(
              Icons.clear,
              size: 18,
              color: Colors.grey[700],
            ),
            deleteIconColor: !_isEditing ? Colors.transparent : _deleteColor,
            onDeleted: !_isEditing ? null : () => _deleteOneHistory(entry.key),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            backgroundColor:
                !_isEditing ? Colors.transparent : Colors.grey[200],
            padding: !_isEditing ? EdgeInsets.zero : EdgeInsets.only(left: 10),
            labelPadding: EdgeInsets.symmetric(vertical: -2),
            label: SizedBox(
                width: double.infinity,
                child: Text(entry.value,
                    maxLines: 1, overflow: TextOverflow.ellipsis))),
      );

  _deleteOneHistory(int index) async {
    setState(() {
      _searchHistory.removeAt(index);
    });
    await StorageUtil()
        .storage
        .write(key: Constants.searchHistory, value: jsonEncode(_searchHistory));
  }

  _deleteAll() async {
    setState(() {
      _searchHistory.clear();
      _isEditing = false;
    });
    await StorageUtil()
        .storage
        .write(key: Constants.searchHistory, value: jsonEncode(_searchHistory));
  }
}
