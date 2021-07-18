import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_colors.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/utils/message_box.dart';
import 'package:comment_overflow/utils/my_image_picker.dart';
import 'package:comment_overflow/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ProfileSettingPage extends StatefulWidget {
  // final UserAvatar previousUserAvatar;
  // final String _previousIntroduction;
  // final String _previousNickname;
  // final String _previousGender;
  // we can't pass the initial value through constructor
  // my suggestion is initiating them in createState()

  ProfileSettingPage({Key? key}) : super(key: key);

  @override
  createState() => new _ProfileSettingPageState();
}

class _ProfileSettingPageState extends State<ProfileSettingPage> {
  late UserAvatar _userAvatar;
  String _introduction = "";
  bool _isIntroductionValid = true;
  String _nickname = "";
  bool _isNicknameValid = true;
  String _gender = "";
  late TextEditingController _introductionController;
  late TextEditingController _nicknameController;
  final List<AssetEntity> _assets = [];
  late MessageBox messageBox;

  static const _itemDivider = Divider(
    height: 10,
    thickness: 1,
  );
  static const _gap = const SizedBox(height: 5.0);

  Future<void> _selectAssets() async {
    final List<AssetEntity>? result = await MyImagePicker.pickImage(context,
        maxAssets: 1, selectedAssets: _assets);
    if (result != null) {
      setState(() {
        _assets.clear();
        _assets.addAll(List<AssetEntity>.from(result));
        _userAvatar = UserAvatar(
          Constants.profileSettingImageSize,
          image: AssetEntityImageProvider(_assets.first, isOriginal: false),
        );
      });
    }
  }

  @override
  void initState() {
    String _imageUrl = "";
    //In my opinion, first u should use an url get from userInfo to initiate the userAvatar
    //then after user upload image from local,recreate the userAvatar via AssetEntityImageProvider
    this._userAvatar = UserAvatar(Constants.profileSettingImageSize,
        image: NetworkImage(
            "http://img8.zol.com.cn/bbs/upload/23765/23764201.jpg"));
    this._introduction = "Hi there, this is WindowsXp";
    this._nickname = "WindowsXp";
    this._gender = "男";
    super.initState();
    _introductionController = TextEditingController(text: this._introduction);
    _nicknameController = TextEditingController(text: this._nickname);
  }

  @override
  void dispose() {
    _introductionController.dispose();
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("编辑资料"),
        leading: IconButton(icon:Icon(Icons.arrow_back),
          onPressed: () => {
            Navigator.of(context).pop()
          },
        ),
        actions: [
          new IconButton(
              icon: Icon(Icons.save),
              onPressed: (){
                if(_isNicknameValid && _isIntroductionValid){
                  MessageBox.showToast(msg: "保存成功", messageBoxType: MessageBoxType.Success);
                  Navigator.of(context).pop();
                }
              })
          ],
        ),
        body: _buildBody());
  }

  Widget _buildBody() {
    return Form(
        child: ListView(
      padding: const EdgeInsets.all(15.0),
      children: [
        GestureDetector(
          onTap: _selectAssets,
          child: _userAvatar,
        ),
        _gap,
        _gap,
        Text(
          "基本资料",
          style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 30.0),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "昵称",
              style: CustomStyles.profileSettingItemTitleStyle,
            ),
            Expanded(
              flex: 2,
              child: Container(),
            ),
            Expanded(
              flex: 15,
              child: TextFormField(
                  controller: _nicknameController,
                  inputFormatters: [
                    new LengthLimitingTextInputFormatter(10),
                  ],
                  // maxLength: 10,
                  decoration: InputDecoration(
                    hintText: '昵称（不超过10个字）',
                    border: null,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                  ),
                  onChanged: (value) {
                    setState(() {
                      value.isEmpty
                          ? _isNicknameValid = false
                          : _isNicknameValid = true;
                    });
                    if(!_isNicknameValid){
                      MessageBox.showToast(msg: "用户名不能为空", messageBoxType: MessageBoxType.Error);
                    }
                  }),
              // ),
            ),
          ],
        ),
        _itemDivider,
        _gap,
        _gap,
        Text(
          "一句话介绍",
          style: CustomStyles.profileSettingItemTitleStyle,
        ),
        TextFormField(
          controller: _introductionController,
          inputFormatters: [
            new LengthLimitingTextInputFormatter(30),
          ],
          maxLength: 30,
          minLines: 1,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: "不超过30个字",
            enabledBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: CustomColors.profileSettingInputGery),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide:
                  BorderSide(color: CustomColors.profileSettingInputGery),
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("性别", style: CustomStyles.profileSettingItemTitleStyle),
            Expanded(
              flex: 2,
              child: Container(),
            ),
            Expanded(
              flex: 15,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _gender,
                  onChanged: (String? newValue) {
                    setState(() {
                      _gender = newValue!;
                    });
                  },
                  items: <String>['男', '女', '保密']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        ),
        _itemDivider,
      ],
    ));
  }
}
