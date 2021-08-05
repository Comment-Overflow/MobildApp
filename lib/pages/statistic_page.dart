import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/model/response_dto/statistics_dto.dart';
import 'package:comment_overflow/service/statistics_service.dart';
import 'package:comment_overflow/widgets/statistics_list.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatisticPage extends StatefulWidget {
  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  StatisticsDTO? dto;
  bool _hasData = false;

  _onUpdateStatistics(StatisticsDTO newDto) {
    setState(() {
      dto = newDto;
    });
  }

  _initResponse(Response response) {
    setState(() {
      dto = StatisticsDTO.fromList(response.data);
      _hasData = true;
    });
  }

  @override
  void initState() {
    super.initState();
    StatisticsService.initStatistics(_onUpdateStatistics).then(_initResponse);
  }

  @override
  Widget build(BuildContext context) {
    return _hasData
        ? DefaultTabController(
            length: Constants.statisticPageTabs.length,
            child: Scaffold(
              appBar: AppBar(
                elevation: Constants.defaultAppBarElevation,
                title: Text("奉告统计", style: CustomStyles.pageTitleStyle),
                centerTitle: true,
                bottom: TabBar(
                  tabs: Constants.statisticPageTabs
                      .map((e) => Tab(text: e))
                      .toList(),
                  isScrollable: false,
                ),
              ),
              body: TabBarView(
                children: [
                  StatisticsList(dto: dto!, type: StatisticPeriodType.Day),
                  StatisticsList(dto: dto!, type: StatisticPeriodType.Week),
                  StatisticsList(dto: dto!, type: StatisticPeriodType.Month),
                  StatisticsList(dto: dto!, type: StatisticPeriodType.All),
                ],
              ),
            ),
          )
        : Container();
  }

  @override
  void dispose() {
    StatisticsService.dispose();
    super.dispose();
  }
}

class TabBarHeader extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar = TabBar(
    tabs: Constants.statisticPageTabs.map((e) => Tab(text: e)).toList(),
    isScrollable: false,
  );

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapContent) {
    return Container(
        color: Theme.of(context).scaffoldBackgroundColor, child: _tabBar);
  }

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
