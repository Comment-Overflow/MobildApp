import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class AdaptiveRefresher extends StatelessWidget {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final bool enablePullUp;
  final bool enablePullDown;
  final VoidCallback? onRefresh;
  final VoidCallback? onLoading;
  final Widget? child;
  final Widget? iosRefresh;
  final Widget? iosComplete;

  AdaptiveRefresher({
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
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      headerTriggerDistance: 60.0,
      child: SmartRefresher(
        controller: _refreshController,
        enablePullUp: this.enablePullUp,
        enablePullDown: this.enablePullDown,
        header: buildAdaptiveHeader(context),
        onRefresh: () {
          this.onRefresh!();
          _refreshController.refreshCompleted();
        },
        onLoading: this.onLoading,
        child: this.child,
      ),
    );
  }

  buildAdaptiveHeader(context) => Platform.isIOS
      ? WaterDropHeader(
          refresh: this.iosRefresh,
          complete: this.iosComplete,
        )
      : MaterialClassicHeader(
          color: Theme.of(context).accentColor,
        );

  refreshCompleted() {
    _refreshController.refreshCompleted();
  }
}
