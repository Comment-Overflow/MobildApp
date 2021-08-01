import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_colors.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class QuoteCard extends StatelessWidget {
  /// Vertical gap between rows.
  static const _gap = const SizedBox(height: 5.0);

  final _quote;

  const QuoteCard(this._quote, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: Constants.defaultCardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      color: CustomColors.quoteCardBackground,
      child: Padding(
        padding: EdgeInsets.all(Constants.defaultCardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  this._quote.title,
                  style: CustomStyles.referenceUserNameStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Expanded(
                    child: Text(
                  _quote.floor == 0 ? "楼主" : this._quote.floor.toString() + "楼",
                  style: CustomStyles.floorStyle,
                  textAlign: TextAlign.right,
                ))
              ],
            ),
            ...(this._quote.content.isNotEmpty
                ? [
                    _gap,
                    Text(
                      this._quote.content,
                      style: CustomStyles.referenceContentStyle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ]
                : [SizedBox.shrink()]),
          ],
        ),
      ),
    );
  }
}
