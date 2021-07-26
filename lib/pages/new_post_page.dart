import 'package:chips_choice/chips_choice.dart';
import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/model/request_dto/new_post_dto.dart';
import 'package:comment_overflow/service/post_service.dart';
import 'package:comment_overflow/utils/my_image_picker.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:comment_overflow/widgets/horizontal_image_scroller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class NewPostPage extends StatefulWidget {
  const NewPostPage({Key? key}) : super(key: key);

  @override
  _NewPostPageState createState() => _NewPostPageState();
}

class _NewPostPageState extends State<NewPostPage> {
  final _iconSize = Constants.searchBarHeight * 0.8;
  // List of category tags.
  final List<String> _options = tags;

  // Below are the fields that user inputs.
  // Title can't be empty, but content can.
  // Index of tag, starting from zero.
  int _idx = 0;
  // Title of the post.
  String _title = '';
  // Content of the post.
  String _content = '';
  // The list of images to upload.
  final List<AssetEntity> _assets = [];

  List<String> _tags = ["LIFE", "STUDY", "ART", "MOOD", "CAREER"];

  @override
  Widget build(BuildContext context) {
    final _activeForegroundColor = Theme.of(context).accentColor;
    final _activeBackgroundColor = Theme.of(context).buttonColor;
    final _iconColor = _activeForegroundColor;
    final _splashColor = _activeBackgroundColor;

    Future<void> _selectAssets() async {
      final List<AssetEntity>? result = await MyImagePicker.pickImage(context,
          maxAssets: Constants.maxImageNumber, selectedAssets: _assets);
      if (result != null) {
        setState(() {
          _assets.clear();
          _assets.addAll(List<AssetEntity>.from(result));
        });
      }
    }

    return Scaffold(
      appBar: buildAppBar(_iconColor, _splashColor),
      body: Column(children: [
        ChipsChoice<int>.single(
          value: _idx,
          onChanged: (val) => setState(() => _idx = val),
          choiceItems: C2Choice.listFrom<int, String>(
            source: _options,
            value: (i, v) => i,
            label: (i, v) => v,
          ),
          choiceStyle: C2ChoiceStyle(
            clipBehavior: Clip.none,
            padding: EdgeInsets.all(2.0),
          ),
          choiceActiveStyle: C2ChoiceStyle(
              brightness: Brightness.dark,
              color: _activeBackgroundColor,
              clipBehavior: Clip.none,
              padding: EdgeInsets.all(2.0),
              borderColor: _activeForegroundColor,
              labelStyle: TextStyle(
                color: _activeForegroundColor,
              )),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Divider(height: 1),
            buildTitleInputField(_activeForegroundColor),
          ]),
        ),
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: buildContentInputField(_activeForegroundColor),
        )),
      ]),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: _selectAssets,
        child: CustomStyles.getDefaultImageIcon(
            size: Constants.defaultFabIconSize * 0.8, color: Colors.white),
      ),
      bottomSheet: HorizontalImageScroller(this._assets),
    );
  }

  buildAppBar(iconColor, iconSplashColor) => AppBar(
        elevation: Constants.defaultAppBarElevation,
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          // Back button.
          IconButton(
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(),
            splashRadius: _iconSize / 1.3,
            splashColor: Theme.of(context).buttonColor,
            icon: CustomStyles.getDefaultBackIcon(
                size: _iconSize, color: iconColor),
            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                RouteGenerator.homeRoute, (route) => false),
          ),
          Text("发布帖子"),
          // Send icon.
          IconButton(
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
              splashRadius: _iconSize / 1.3,
              splashColor: Theme.of(context).buttonColor,
              icon: CustomStyles.getDefaultSendIcon(
                  size: _iconSize,
                  color: this._title.isNotEmpty
                      ? iconColor
                      : Theme.of(context).disabledColor),
              onPressed: this._title.isNotEmpty
                  ? () {
                      print(this._title);
                      print(this._content);
                      _pushSend();
                    }
                  : null),
        ]),
        automaticallyImplyLeading: false,
      );

  buildTitleInputField(lineColor) => TextField(
        maxLengthEnforcement: MaxLengthEnforcement.truncateAfterCompositionEnds,
        cursorColor: lineColor,
        maxLength: Constants.postTitleMaximumLength,
        style: CustomStyles.newPostTitleStyle,
        decoration: InputDecoration(
          hintText: '请输入标题',
          hintStyle: CustomStyles.newPostTitleStyle,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: lineColor,
              width: 1.5,
            ),
          ),
        ),
        onChanged: (String text) => setState(() => this._title = text),
      );

  buildContentInputField(lineColor) => TextField(
        maxLines: null,
        keyboardType: TextInputType.multiline,
        cursorColor: lineColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '请输入内容',
        ),
        expands: true,
        onChanged: (String text) => this._content = text,
      );

  void _pushSend() {
    _post();
  }

  Future<void> _post() async {
    final dto = NewPostDTO(
        tag: _tags[_idx], title: _title, content: _content, assets: _assets);
    try {
      final response = await PostService.postPost(dto);
      print(response);
    } on DioError catch (e) {
      print(e.message);
    }
  }
}
