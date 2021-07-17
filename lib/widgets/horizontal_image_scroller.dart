import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class HorizontalImageScroller extends StatefulWidget {
  final List<AssetEntity> _assets;

  HorizontalImageScroller(this._assets, {Key? key}) : super(key: key);
  @override
  _HorizontalImageScrollerState createState() => _HorizontalImageScrollerState();
}

class _HorizontalImageScrollerState extends State<HorizontalImageScroller> {
  @override
  Widget build(BuildContext context) {
    return widget._assets.isNotEmpty ? Container(
      child: ListView.builder(
        itemBuilder: _assetItemBuilder,
        scrollDirection: Axis.horizontal,
        itemCount: widget._assets.length,
      ),
      height: 90.0,
    ) : SizedBox.shrink();
  }

  Widget _assetItemBuilder(BuildContext _, int index) {
    return Container(
      height: 70.0,
      width: 70.0,
      margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
      child: AspectRatio(
        aspectRatio: 1.0,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Stack(
            children: <Widget>[
              _imageWidget(index),
              _deleteButton(index),
            ],
          ),
        ),
      ),
    );
  }

  void _removeAsset(int index) {
    setState(() {
      widget._assets.remove(widget._assets.elementAt(index));
    });
  }

  Widget _imageWidget(int index) {
    return Positioned.fill(
      child: ExtendedImage(
        image: AssetEntityImageProvider(
          widget._assets.elementAt(index),
          isOriginal: false,
        ),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _deleteButton(int index) {
    return Positioned(
      top: 6.0,
      right: 6.0,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _removeAsset(index),
        child: Container(
          padding: const EdgeInsets.all(2.0),
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.close, size: 14.0, color: Colors.white),
        ),
      ),
    );
  }

}