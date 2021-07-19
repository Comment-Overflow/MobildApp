import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/model/routing_dto/image_gallery_dto.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';

class ImageList extends StatelessWidget {
  final List<String> _imageUrl;

  ImageList(this._imageUrl, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _imageUrl.length <= 3
        ? _buildPlainImageList()
        : _buildNinePatternImageList(context);
  }

  Widget _buildPlainImageList() => ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _imageUrl.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      RouteGenerator.generateRoute(RouteSettings(
                        name: RouteGenerator.galleryRoute,
                        arguments: ImageGalleryDto(_imageUrl, index),
                      )));
                },
                child: ExtendedImage.network(
                  _imageUrl[index],
                  fit: BoxFit.fitWidth,
                  cache: true,
                ),
              )),
        ),
      );

  Widget _buildNinePatternImageList(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: GridView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: Constants.defaultNinePatternSpacing,
              crossAxisSpacing: Constants.defaultNinePatternSpacing,
              childAspectRatio: 1.0),
          children: _buildGridItems(context),
        ),
      );

  List<Widget> _buildGridItems(BuildContext context) {
    List<Widget> list = [];
    for (int index = 0; index < _imageUrl.length; ++index) {
      list.add(GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              RouteGenerator.generateRoute(RouteSettings(
                name: RouteGenerator.galleryRoute,
                arguments: ImageGalleryDto(_imageUrl, index),
              )));
        },
        child: ExtendedImage.network(
          _imageUrl[index],
          fit: BoxFit.cover,
          cache: true,
        ),
      ));
    }
    return list;
  }
}
