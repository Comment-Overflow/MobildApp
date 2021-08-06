import 'package:comment_overflow/assets/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';

class SkeletonNotificationCardList extends StatelessWidget {
  static final _block = SkeletonLine(
      style: SkeletonLineStyle(
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    height: 50.0,
  ));
  static final _card = SizedBox(
      height: 150,
      child: Card(
          elevation: Constants.defaultCardElevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
          ),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: SkeletonItem(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonUserAvatarAndNameAndDate(),
                  SizedBox(height: 20.0),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: _block,
                      )
                    ],
                  ),
                ],
              ),
            ),
          )));

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.filled(7, _card),
    );
  }
}

/// Height: 40.
class SkeletonUserAvatarAndNameAndDate extends StatelessWidget {
  static final _horizontalGap = SizedBox(width: 10);
  static final _avatar = SkeletonAvatar(
    style: SkeletonAvatarStyle(
      width: 40,
      height: 40,
      shape: BoxShape.circle,
    ),
  );
  static final _line = SkeletonLine(
      style: SkeletonLineStyle(
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    height: 11.0,
  ));

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _avatar,
        _horizontalGap,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _line,
              SizedBox(height: 18.0),
              FractionallySizedBox(
                widthFactor: 0.6,
                child: _line,
              )
            ],
          ),
        ),
      ],
    );
  }
}
