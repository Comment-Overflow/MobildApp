import 'package:chips_choice/chips_choice.dart';
import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/utils/my_image_picker.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:comment_overflow/widgets/horizontal_image_scroller.dart';
import 'package:flutter/material.dart';
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
  // The list of images to upload.
  final List<AssetEntity> _assets = [];
  // Index of tag, starting from zero.
  int _idx = 0;

  @override
  Widget build(BuildContext context) {
    print('build');
    final _activeForegroundColor = Theme.of(context).accentColor;
    final _activeBackgroundColor = Theme.of(context).buttonColor;

    return Scaffold(
      appBar: buildAppBar(),
      body: SingleChildScrollView(
          child: Column(children: [
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
            child: Column(children: [
              Divider(height: 1),
              buildTitleInputField(_activeForegroundColor),
              buildContentInputField(_activeForegroundColor),
            ]))
      ])),
      floatingActionButton: FloatingActionButton(
        mini: true,
        onPressed: () {
          _selectAssets(context);
        },
        child: CustomStyles.getDefaultImageIcon(
            size: Constants.defaultFabIconSize * 0.8, color: Colors.white),
      ),
      bottomSheet: HorizontalImageScroller(this._assets),
    );
  }

  buildAppBar() => AppBar(
        elevation: Constants.defaultAppBarElevation,
        title:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                RouteGenerator.homeRoute, (route) => false),
            child: CustomStyles.getDefaultBackIcon(context, size: _iconSize),
          ),
          Text("发布帖子"),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                RouteGenerator.homeRoute, (route) => false),
            child: CustomStyles.getDefaultSendIcon(context, size: _iconSize),
          ),
        ]),
        automaticallyImplyLeading: false,
      );

  buildTitleInputField(lineColor) => TextField(
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
      );

  buildContentInputField(lineColor) => TextField(
        maxLines: null,
        keyboardType: TextInputType.multiline,
        cursorColor: lineColor,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: '请输入内容',
        ),
      );

  Future<void> _selectAssets(context) async {
    final List<AssetEntity>? result = await MyImagePicker.pickImage(context,
        maxAssets: Constants.maxImageNumber, selectedAssets: _assets);
    if (result != null) {
      setState(() {
        _assets.clear();
        _assets.addAll(List<AssetEntity>.from(result));
      });
    }
  }
}
