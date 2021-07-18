import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AdaptiveRefresher extends StatefulWidget {
  final bool enablePullUp;
  final bool enablePullDown;
  final Future Function()? onRefresh;
  final VoidCallback? onLoading;
  final Widget? child;
  final Widget? iosRefresh;
  final Widget? iosComplete;

  const AdaptiveRefresher({
    Key? key,
    this.enablePullDown: true,
    this.enablePullUp: false,
    this.onRefresh,
    this.onLoading,
    this.iosRefresh,
    this.iosComplete,
    this.child,
  }) : super(key: key);

  @override
  _AdaptiveRefresherState createState() => _AdaptiveRefresherState();
}

class _AdaptiveRefresherState extends State<AdaptiveRefresher> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void didUpdateWidget(covariant AdaptiveRefresher oldWidget) {
    print('did update');
    super.didUpdateWidget(oldWidget);
  }

  @override
  dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      headerTriggerDistance: 60.0,
      child: SmartRefresher(
        controller: _refreshController,
        enablePullUp: widget.enablePullUp,
        enablePullDown: widget.enablePullDown,
        header: buildAdaptiveHeader(context),
        onRefresh: () async {
          await widget.onRefresh!();
          _refreshController.refreshCompleted();
        },
        onLoading: widget.onLoading,
        child: widget.child,
      ),
    );
  }

  buildAdaptiveHeader(context) => Platform.isIOS
      ? WaterDropHeader(
          refresh: widget.iosRefresh,
          complete: widget.iosComplete,
        )
      : MaterialClassicHeader(
          color: Theme.of(context).accentColor,
        );
}
