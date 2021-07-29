import 'package:cached_network_image/cached_network_image.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class UserAvatar extends StatelessWidget {
  /// Diameter of the circular avatar.
  final double _imageSize;

  dynamic _imageContent;

  UserAvatar(
    this._imageSize, {
    imageContent = null,
    Key? key,
  })  : _imageContent = imageContent,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget avatarContent;

    if (_imageContent.runtimeType == AssetEntity)
      avatarContent = Image(
        image: AssetEntityImageProvider(_imageContent as AssetEntity,
            isOriginal: false),
        width: _imageSize,
        height: _imageSize,
        fit: BoxFit.cover,
      );
    else if (_imageContent.runtimeType == String)
      avatarContent = ExtendedImage.network(
        _imageContent as String,
        width: _imageSize,
        height: _imageSize,
        fit: BoxFit.cover,
        loadStateChanged: (ExtendedImageState state) {
          switch (state.extendedImageLoadState) {
            case LoadState.loading:
              return SkeletonAnimation(
                borderRadius: BorderRadius.circular(50),
                shimmerDuration: 2000,
                child: Container(
                  color: Colors.grey[200],
                ),
              );
            case LoadState.completed:
              return null;
            case LoadState.failed:
              return _buildFallbackContent();
          }
        },
      );
    else
      avatarContent = _buildFallbackContent();

    return CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: this._imageSize / 2,
      child: ClipOval(child: avatarContent),
    );
  }

  Widget _buildFallbackContent() {
    return Icon(
      Icons.account_circle_rounded,
      color: Colors.blueAccent,
      size: _imageSize,
    );
  }
}
