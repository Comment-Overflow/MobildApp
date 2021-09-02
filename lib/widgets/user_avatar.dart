import 'package:comment_overflow/model/routing_dto/personal_page_access_dto.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:skeletons/skeletons.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class UserAvatar extends StatelessWidget {
  /// Diameter of the circular avatar.
  final double _imageSize;
  final bool _canJump;
  final int _userId;
  dynamic _imageContent;

  UserAvatar(
    userId,
    this._imageSize, {
    imageContent,
    canJump: true,
    Key? key,
  })  : _userId = userId,
        _imageContent = imageContent,
        _canJump = canJump,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget avatarContent;

    if (_imageContent.runtimeType == AssetEntity) {
      avatarContent = Image(
        image: AssetEntityImageProvider(_imageContent as AssetEntity,
            isOriginal: false),
        width: _imageSize,
        height: _imageSize,
        fit: BoxFit.cover,
      );
    } else if (_imageContent.runtimeType == String) {
      if (_canJump) {
        avatarContent = avatarContent = GestureDetector(
          onTap: _canJump
              ? () => Navigator.of(context).pushNamed(
                  RouteGenerator.personalRoute,
                  arguments: PersonalPageAccessDto(_userId, true))
              : () {},
          child: ExtendedImage.network(
            _imageContent as String,
            width: _imageSize,
            height: _imageSize,
            fit: BoxFit.cover,
            loadStateChanged: (ExtendedImageState state) {
              switch (state.extendedImageLoadState) {
                case LoadState.loading:
                  return SkeletonAvatar(
                    style: SkeletonAvatarStyle(
                      shape: BoxShape.circle,
                    ),
                  );
                case LoadState.completed:
                  return null;
                case LoadState.failed:
                  return _buildFallbackContent(context);
              }
            },
          ),
        );
      } else {
        avatarContent = ExtendedImage.network(
          _imageContent as String,
          width: _imageSize,
          height: _imageSize,
          fit: BoxFit.cover,
          loadStateChanged: (ExtendedImageState state) {
            switch (state.extendedImageLoadState) {
              case LoadState.loading:
                return SkeletonAvatar(
                  style: SkeletonAvatarStyle(
                    shape: BoxShape.circle,
                  ),
                );
              case LoadState.completed:
                return null;
              case LoadState.failed:
                return _buildFallbackContent(context);
            }
          },
        );
      }
    } else {
      if (_canJump) {
        avatarContent = GestureDetector(
            onTap: _canJump
                ? () => Navigator.of(context).pushNamed(
                    RouteGenerator.personalRoute,
                    arguments: PersonalPageAccessDto(_userId, true))
                : () {},
            child: _buildFallbackContent(context));
      } else {
        avatarContent = _buildFallbackContent(context);
      }
    }

    return CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: this._imageSize / 2,
      child: ClipOval(child: avatarContent),
    );
  }

  _buildFallbackContent(context) {
    return Icon(
      Icons.account_circle_rounded,
      color: Theme.of(context).accentColor,
      size: _imageSize,
    );
  }
}
