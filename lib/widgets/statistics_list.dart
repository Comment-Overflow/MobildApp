import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/model/response_dto/statistics_dto.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StatisticsList extends StatelessWidget {
  final StatisticsDTO _dto;
  final StatisticPeriodType _type;

  StatisticsList(
      {required StatisticsDTO dto, required StatisticPeriodType type, Key? key})
      : _dto = dto,
        _type = type,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    int offset;
    switch (_type) {
      case StatisticPeriodType.Day:
        offset = 0;
        break;
      case StatisticPeriodType.Week:
        offset = 6;
        break;
      case StatisticPeriodType.Month:
        offset = 12;
        break;
      case StatisticPeriodType.All:
        offset = 18;
        break;
    }
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
              shadowColor: Colors.black87,
              child: Column(
                children: [
                  SizedBox(height: 36.0),
                  Text(Constants.statistics[index],
                      style: CustomStyles.statisticTextStyle),
                  SizedBox(height: 10.0),
                  AnimatedFlipCounter(
                    value: _dto.getCountByIndex(offset + index).toDouble(),
                    textStyle: CustomStyles.statisticFigureStyle,
                  ),
                ],
              ),
            );
          }),
    );
  }
}
