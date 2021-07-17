import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/model/quote.dart';
import 'package:comment_overflow/utils/my_image_picker.dart';
import 'package:comment_overflow/widgets/quote_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'horizontal_image_scroller.dart';

class MultipleInputField extends StatelessWidget {

  final BuildContext _context;
  /// Holds text in TextField.
  final TextEditingController _controller;
  /// Holds selected images.
  final List<AssetEntity> _assets;
  /// Quote of this reply. (if any)
  final Quote? _quote;

  /*
    Usage:
    add [onTap] property for reply button
  ================================================
    void _pushReply() {
    showModalBottomSheet(
      isScrollControlled: true, // !important
      context: context,
      builder: (_) {
        return MultipleInputField(
            context: context,
            textController: _replyController,
            assets: _assets,
            quote: _quote,
        );
      }
    );
  }
  ================================================
  */

  MultipleInputField({
    @required context,
    @required textController,
    @required assets,
    quote,
    Key? key})
      : _context = context,
        _controller = textController,
        _assets = assets,
        _quote = quote,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                height: 17.0,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {Navigator.pop(context);},
                      icon: CustomStyles.getDefaultCloseIcon(size: 16.0),
                    )
                  ],
                ),
              ),
              _quote == null
                ? SizedBox.shrink()
                : Padding(
                  padding: EdgeInsets.all(6.0),
                  child: QuoteCard(_quote),
                ),
              HorizontalImageScroller(_assets),
              Row(
                children: [
                  _buildTextField(),
                  Padding(
                    padding: EdgeInsets.only(right: 5.0),
                    child: ElevatedButton(
                      child: Text("发送"),
                      onPressed: () {},
                    ),
                  )
                ],
              ),
            ]
        ),
      )
    );
  }

  Widget _buildTextField() {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: TextField(
          controller: _controller,
          textInputAction: TextInputAction.newline,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: "友善的回复向世界问好",
            border: OutlineInputBorder(),
            contentPadding: const EdgeInsets.all(6.0),
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: CustomStyles.getDefaultImageIcon(size: 24.0),
                  onPressed: _selectAssets,
                ),
              ],
            )
          ),
          autofocus: true,
        ),
      )
    );
  }

  Future<void> _selectAssets() async {
    final List<AssetEntity>? result = await MyImagePicker.pickImage(
        _context,
        maxAssets: Constants.maxImageNumber,
        selectedAssets: _assets
    );
    if (result != null) {
      _assets.clear();
      _assets.addAll(List<AssetEntity>.from(result));
    }
  }
}