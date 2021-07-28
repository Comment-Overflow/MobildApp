import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_colors.dart';
import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/service/profile_setting_service.dart';
import 'package:comment_overflow/utils/message_box.dart';
import 'package:comment_overflow/utils/my_image_picker.dart';
import 'package:comment_overflow/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:dio/dio.dart';

class ProfileSettingPage extends StatefulWidget {

  ProfileSettingPage({Key? key}) : super(key: key);

  @override
  createState() => _ProfileSettingPageState();
}

class _ProfileSettingPageState extends State<ProfileSettingPage> {
  UserAvatar _userAvatar = UserAvatar(Constants.profileSettingImageSize);
  String _brief = "";
  bool _isIntroductionValid = true;
  String _userName = "";
  bool _isUserNameValid = true;
  bool _isUserAvatarChanged = false;
  String _gender = "保密";
  late TextEditingController _briefController;
  late TextEditingController _userNameController;
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
    print(result?.length);
    if (result != null) {
      _isUserAvatarChanged = true;
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

  Future<MultipartFile> _transport(AssetEntity asset) async {
    return MultipartFile.fromFileSync((await asset.file)!.path);
  }

  Future<FormData> formData() async => FormData.fromMap({
    "userName": _userNameController.text,
    "brief": _briefController.text,
    "avatar": _isUserAvatarChanged ? await _transport(_assets.first) : null,
    "gender": _gender
  });

  @override
  void initState() {
    ValueSetter callback = (dynamic json) => this.setState(() {
      String? _imageUrl = json['avatarUrl'] == null ? null : json['avatarUrl'] as String;
      this._userAvatar = UserAvatar(Constants.profileSettingImageSize,
          image: _imageUrl == null ? null : NetworkImage(_imageUrl)
      );
      this._brief = json['brief'] as String;
      this._userName = json['userName'] as String;
      switch(json['gender'] as String){
        case "MALE":
          this._gender = "男";
          break;
        case "FEMALE":
          this._gender = "女";
          break;
        case "SECRET":
          this._gender = "保密";
          break;
      }
      _userNameController = TextEditingController(text: this._userName);
      _briefController = TextEditingController(text: this._brief);
    });
    ProfileSettingService.getProfile("/profiles", callback);
    super.initState();
    _userNameController = TextEditingController();
    _briefController = TextEditingController();
  }

  @override
  void dispose() {
    _briefController.dispose();
    _userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: Constants.defaultAppBarElevation,
          title: Text("编辑资料"),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => {Navigator.of(context).pop()},
          ),
          actions: [
            IconButton(
                icon: Icon(Icons.save),
                onPressed: () async {
                  if (_isUserNameValid && _isIntroductionValid) {
                    bool errorFlag = false;
                    try{
                      final response = await ProfileSettingService.putProfile("/profiles", (await formData()));
                    } on DioError catch(e) {
                      errorFlag = true;
                      print(e.message);
                      MessageBox.showToast(
                          msg: "网络错误", messageBoxType: MessageBoxType.Error);
                    }
                    if(!errorFlag) {
                      MessageBox.showToast(
                          msg: "保存成功", messageBoxType: MessageBoxType.Success);
                      Navigator.of(context).pop();
                    }
                  } else if (!_isUserNameValid) {
                    MessageBox.showToast(
                        msg: "用户名不能为空", messageBoxType: MessageBoxType.Error);
                  } else {
                    MessageBox.showToast(
                        msg: "请输入有效的自我介绍",
                        messageBoxType: MessageBoxType.Error);
                  }
                })
          ],
        ),
        body: _buildBody());
  }

  Widget _buildBody() {
    return Form(
        child: ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        GestureDetector(
          onTap: _selectAssets,
          child: _userAvatar,
        ),
        _gap,
        _gap,
        _gap,
        _gap,
        Text(
          "基本资料",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24.0),
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
                  controller: _userNameController,
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
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
                          ? _isUserNameValid = false
                          : _isUserNameValid = true;
                    });
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
          controller: _briefController,
          inputFormatters: [
            LengthLimitingTextInputFormatter(30),
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
                  onChanged: (String? Value) {
                    setState(() {
                      _gender = Value!;
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
