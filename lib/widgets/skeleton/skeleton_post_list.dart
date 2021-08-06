import 'package:comment_overflow/assets/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:skeletons/skeletons.dart';

class SkeletonPostList extends StatelessWidget {
  static const _gap = const SizedBox(height: 20.0);
  static const _line = SkeletonLine(
      style: SkeletonLineStyle(
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    height: 11.0,
  ));
  static const _block = SkeletonLine(
    style: SkeletonLineStyle(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      height: 80,
    ),
  );
  static final _card = SizedBox(
    height: 128,
    child: Card(
        elevation: Constants.defaultCardElevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
        ),
        child: Padding(
          padding: EdgeInsets.all(24),
          child: SkeletonItem(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 10,
                  child: Column(
                    children: [
                      _line,
                      _gap,
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: _line,
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Container(),
                ),
                Expanded(
                  flex: 5,
                  child: _block,
                ),
              ],
            ),
          ),
        )),
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.filled(6, _card),
    );
  }
}
