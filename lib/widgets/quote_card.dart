import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:zhihu_demo/assets/constants.dart';
import 'package:zhihu_demo/assets/custom_colors.dart';
import 'package:zhihu_demo/assets/custom_styles.dart';

class QuoteCard extends StatelessWidget {
  /// Vertical gap between rows.
  static const _gap = const SizedBox(height: 5.0);

  final _quote;

  const QuoteCard(this._quote, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      color: CustomColors.lightGrey,
      child: Padding(
        padding: EdgeInsets.all(Constants.defaultCardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              this._quote.userName,
              style: CustomStyles.referenceUserNameStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            _gap,
            Text(
              this._quote.content,
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
