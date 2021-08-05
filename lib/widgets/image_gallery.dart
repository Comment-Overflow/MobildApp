import 'dart:typed_data';

import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/service/image_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageGallery extends StatefulWidget {
  final LoadingBuilder? loadingBuilder;
  final BoxDecoration? backgroundDecoration;
  final dynamic minScale;
  final dynamic maxScale;
  final int initialIndex;
  final PageController pageController;
  final List<String> imageUrl;
  final Axis scrollDirection;

  ImageGallery(
      {required this.imageUrl,
      this.loadingBuilder,
      this.backgroundDecoration,
      this.minScale,
      this.maxScale,
      this.initialIndex = 0,
      this.scrollDirection = Axis.horizontal,
      Key? key})
      : pageController = PageController(initialPage: initialIndex),
        super(key: key);

  @override
  _ImageGalleryState createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  late int currentIndex = widget.initialIndex;
  bool _showBars = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _showBars ? _buildAppBar(context) : null,
      body: Container(
          decoration: widget.backgroundDecoration,
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height,
          ),
          child: GestureDetector(
            onTap: () => setState(() {
              _showBars = !_showBars;
            }),
            child: Stack(
              alignment: Alignment.bottomRight,
              children: <Widget>[
                PhotoViewGallery.builder(
                  scrollPhysics: const BouncingScrollPhysics(),
                  builder: _buildItem,
                  itemCount: widget.imageUrl.length,
                  loadingBuilder: widget.loadingBuilder,
                  backgroundDecoration: widget.backgroundDecoration,
                  pageController: widget.pageController,
                  onPageChanged: _onPageChanged,
                  scrollDirection: widget.scrollDirection,
                ),
              ],
            ),
          )),
      bottomNavigationBar: _showBars ? _buildBottomBar() : null,
    );
  }

  AppBar _buildAppBar(BuildContext context) => AppBar(
        title: Text("浏览图片", style: TextStyle(color: Colors.white)),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(Constants.defaultCardPadding / 1.3),
            child: ElevatedButton(
                child: Text("保存"),
                onPressed: _saveImage,
                style: ElevatedButton.styleFrom(
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ))),
          )
        ],
        backgroundColor: Colors.black87,
        automaticallyImplyLeading: false,
      );

  BottomAppBar _buildBottomBar() => BottomAppBar(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "第 ${currentIndex + 1} / ${widget.imageUrl.length} 张图片",
            style: CustomStyles.galleryStyle,
          ),
        ),
        color: Colors.black87,
      );

  void _onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  PhotoViewGalleryPageOptions _buildItem(BuildContext context, int index) {
    return PhotoViewGalleryPageOptions(
      imageProvider: NetworkImage(widget.imageUrl[index]),
      initialScale: PhotoViewComputedScale.contained,
      minScale: PhotoViewComputedScale.contained * (0.5 + index / 10),
      maxScale: PhotoViewComputedScale.covered * 4.1,
      heroAttributes: PhotoViewHeroAttributes(tag: index),
    );
  }

  void _saveImage() async {
    String currentUrl = widget.imageUrl[currentIndex];
    var response = await ImageService.getImageBytes(currentUrl);
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 100);
    print(result);
  }
}
