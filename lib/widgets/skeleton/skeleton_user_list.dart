import 'package:comment_overflow/assets/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:skeletons/skeletons.dart';

class SkeletonUserList extends StatelessWidget {
  static const _line = SkeletonLine(
      style: SkeletonLineStyle(
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    height: 11.0,
  ));
  static const _avatar = SkeletonAvatar(
    style: SkeletonAvatarStyle(
      height: 50,
      width: 50,
      shape: BoxShape.circle,
    ),
  );
  static final _card = SizedBox(
    height: 87,
    child: Card(
      elevation: Constants.defaultCardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Padding(
        padding: EdgeInsets.all(Constants.defaultCardPadding),
        child: SkeletonItem(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 15,
                  child: _avatar,
                ),
                Expanded(
                  flex: 4,
                  child: Container(),
                ),
                Expanded(
                  flex: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ConstrainedBox(
                          constraints: BoxConstraints(minHeight: 20.0),
                          child: _line),
                      SizedBox(height: 20.0),
                      FractionallySizedBox(
                        widthFactor: 0.5,
                        child: _line,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 31,
                  child: Container(),
                ),
              ]),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.filled(6, _card),
    );
  }
}
