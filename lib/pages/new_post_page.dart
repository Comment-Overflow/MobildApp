import 'package:chips_choice/chips_choice.dart';
import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/model/post.dart';
import 'package:comment_overflow/model/request_dto/new_post_dto.dart';
import 'package:comment_overflow/model/routing_dto/jump_post_dto.dart';
import 'package:comment_overflow/service/post_service.dart';
import 'package:comment_overflow/utils/general_utils.dart';
import 'package:comment_overflow/utils/message_box.dart';
import 'package:comment_overflow/utils/my_image_picker.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:comment_overflow/widgets/horizontal_image_scroller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
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
  final List<String> _options = ['校园生活', '学在交大', '文化艺术', '心情驿站', '职业发展'];

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

  bool _isLoading = false;

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
          child:
              SafeArea(child: buildContentInputField(_activeForegroundColor)),
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
          SizedBox(
            height: _iconSize,
            width: _iconSize,
            child: _isLoading
                ? CupertinoActivityIndicator()
                : IconButton(
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
                            _pushSend();
                          }
                        : null),
          ),
        ]),
        automaticallyImplyLeading: false,
      );

  Widget buildTitleInputField(lineColor) => TextField(
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

  Widget buildContentInputField(lineColor) => TextField(
        maxLines: null,
        maxLength: Constants.postContentMaximumLength,
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
    setState(() {
      _isLoading = true;
    });

    // Check image size to be less than 20MB each.
    List<int> overSizedIndex = await GeneralUtils.checkImageSize(_assets);
    if (overSizedIndex.isNotEmpty) {
      MessageBox.showToast(
          msg: "发帖失败！" + GeneralUtils.buildOverSizeAlert(overSizedIndex),
          messageBoxType: MessageBoxType.Error);
      setState(() {
        _isLoading = false;
      });
      return;
    }

    final dto = NewPostDTO(
        tag: _tags[_idx], title: _title, content: _content, assets: _assets);
    try {
      final response = await PostService.postPost(dto);
      Navigator.pushReplacement(
          context,
          RouteGenerator.generateRoute(RouteSettings(
            name: RouteGenerator.postRoute,
            arguments: JumpPostDTO(Post.fromJson(response.data)),
          )));
    } on DioError catch (e) {
      // Error: Connect timeout.
      if (e.type == DioErrorType.connectTimeout) {
        MessageBox.showToast(
            msg: "发帖失败！网络连接超时", messageBoxType: MessageBoxType.Error);
        return;
      }
      // Error: User silenced.
      if (e.response != null && e.response!.statusCode == 401) {
        MessageBox.showToast(
            msg: "发帖失败！您已被禁言", messageBoxType: MessageBoxType.Error);
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
        return;
      }
      // Error: Any other type.
      MessageBox.showToast(
          msg: "发帖失败！${e.response!.data}",
          messageBoxType: MessageBoxType.Error);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
