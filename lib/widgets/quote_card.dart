import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_colors.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/model/quote.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class QuoteCard extends StatelessWidget {
  /// Vertical gap between rows.
  static const _gap = const SizedBox(height: 5.0);

  final Quote? _quote;

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
                  this._quote!.title,
                  style: CustomStyles.referenceUserNameStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                _quote.floor == 0
                    ? SizedBox.shrink()
                    : Expanded(
                        child: Text(
                        this._quote.floor.toString() + "楼",
                        style: CustomStyles.floorStyle,
                        textAlign: TextAlign.right,
                      ))
              ],
            ),
            _gap,
            Text(
              this._quote!.content,
              style: CustomStyles.referenceContentStyle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
