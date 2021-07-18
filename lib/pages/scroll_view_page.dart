import 'package:comment_overflow/assets/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ScrollViewPage extends StatelessWidget {
  final Widget _cardList;
  final String _title;
  final String _backwardRoute;
  ScrollViewPage(this._cardList, this._title, this._backwardRoute, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        floatHeaderSlivers: true,
        headerSliverBuilder: (context, value) => [
          SliverAppBar(
              pinned: true,
              floating: true,
              elevation: Constants.defaultAppBarElevation,
              title: Text(_title),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () =>
                    {Navigator.of(context).pushNamed(_backwardRoute)},
              )),
        ],
        body: MediaQuery.removePadding(
          context: context,
          child: _cardList,
          removeTop: true,
        ),
      ),
    );
  }
}
