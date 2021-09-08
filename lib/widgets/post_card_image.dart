import 'package:comment_overflow/utils/general_utils.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:skeleton_text/skeleton_text.dart';

class PostCardImage extends StatelessWidget {
  static final Widget _defaultFallback = Container(
    color: Colors.grey[200],
    child: Icon(Icons.refresh, color: Colors.grey),
  );

  static final _defaultLoadingIndicator = SkeletonAnimation(
      borderRadius: BorderRadius.circular(50),
      shimmerDuration: 2000,
      child: Container(
        color: Colors.grey[200],
      ));
  static const _defaultTimeout = Duration(seconds: 5);

  final String _url;
  final double? _width;
  final double? _height;
  final BoxFit _fit;
  final Widget _fallback;
  final Widget _loadingIndicator;
  final Duration _timeout;
  final bool _cache;
  final void Function()? _onTap;

  PostCardImage(this._url,
      {Key? key,
      width,
      height,
      fit: BoxFit.cover,
      fallback,
      loadingIndicator,
      timeout: _defaultTimeout,
      cache: true,
      onTap})
      : _width = width,
        _height = height,
        _fit = fit,
        _fallback = fallback == null ? _defaultFallback : fallback,
        _loadingIndicator = loadingIndicator == null
            ? _defaultLoadingIndicator
            : loadingIndicator,
        _timeout = timeout,
        _cache = cache,
        _onTap = onTap,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExtendedImage.network(
      GeneralUtils.getThumbnailPath(_url),
      timeLimit: _timeout,
      width: _width,
      height: _height,
      fit: _fit,
      cache: _cache,
      loadStateChanged: (ExtendedImageState state) {
        switch (state.extendedImageLoadState) {
          case LoadState.loading:
            return _loadingIndicator;
          case LoadState.completed:
            return _onTap == null
                ? state.completedWidget
                : GestureDetector(onTap: _onTap, child: state.completedWidget);
          case LoadState.failed:
            return GestureDetector(
                onTap: () => state.reLoadImage(), child: _fallback);
        }
      },
    );
  }
}
