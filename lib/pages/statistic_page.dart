import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/model/response_dto/statistics_dto.dart';
import 'package:comment_overflow/service/statistics_service.dart';
import 'package:comment_overflow/widgets/statistics_list.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

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
    return DefaultTabController(
      length: Constants.statisticPageTabs.length,
      child: Scaffold(
        appBar: AppBar(
          elevation: Constants.defaultAppBarElevation,
          title: Text("奉告统计", style: CustomStyles.pageTitleStyle),
          centerTitle: true,
          bottom: TabBar(
            tabs: Constants.statisticPageTabs.map((e) => Tab(text: e)).toList(),
            isScrollable: false,
          ),
        ),
        body: TabBarView(
          children: _hasData
              ? <Widget>[
                  StatisticsList(dto: dto!, type: StatisticPeriodType.Day),
                  StatisticsList(dto: dto!, type: StatisticPeriodType.Week),
                  StatisticsList(dto: dto!, type: StatisticPeriodType.Month),
                  StatisticsList(dto: dto!, type: StatisticPeriodType.All),
                ]
              : <Widget>[
                  _SkeletonCards(),
                  _SkeletonCards(),
                  _SkeletonCards(),
                  _SkeletonCards()
                ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    StatisticsService.dispose();
    super.dispose();
  }
}

class _SkeletonCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: Constants.defaultNinePatternSpacing,
              crossAxisSpacing: Constants.defaultNinePatternSpacing,
              childAspectRatio: 1.15),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 6,
          itemBuilder: (bc, index) {
            return Card(
              shadowColor: Colors.blueAccent,
              child: Column(
                children: [
                  SizedBox(height: 40.0),
                  SkeletonLine(
                      style: SkeletonLineStyle(
                          maxLength: 80.0,
                          minLength: 70.0,
                          height: 20.0,
                          alignment: Alignment.center)),
                  SizedBox(height: 15.0),
                  SkeletonLine(
                      style: SkeletonLineStyle(
                          maxLength: 32.0,
                          minLength: 30.0,
                          height: 30.0,
                          alignment: Alignment.center)),
                ],
              ),
            );
          }),
    );
  }
}
