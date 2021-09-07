import 'package:comment_overflow/assets/constants.dart';
import 'package:comment_overflow/assets/custom_colors.dart';
import 'package:comment_overflow/assets/custom_styles.dart';

import 'package:comment_overflow/model/routing_dto/profile_setting_dto.dart';
import 'package:comment_overflow/service/profile_service.dart';
import 'package:comment_overflow/utils/message_box.dart';
import 'package:comment_overflow/utils/my_image_picker.dart';
import 'package:comment_overflow/utils/route_generator.dart';
import 'package:comment_overflow/utils/storage_util.dart';
import 'package:comment_overflow/widgets/adaptive_picker.dart';
import 'package:comment_overflow/widgets/user_avatar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:dio/dio.dart';

class ProfileSettingPage extends StatefulWidget {
  final ProfileSettingDto _profileSettingDto;

  ProfileSettingPage(this._profileSettingDto, {Key? key}) : super(key: key);

  @override
  createState() => _ProfileSettingPageState(this._profileSettingDto);
}

class _ProfileSettingPageState extends State<ProfileSettingPage> {
  final ProfileSettingDto _profileSettingDto;

  bool _isIntroductionValid = true;
  bool _isUserNameValid = true;
  bool _isUserAvatarChanged = false;
  bool _isLoading = false;

  late UserAvatar _userAvatar;
  late String _gender;
  late TextEditingController _briefController;
  late TextEditingController _userNameController;
  final List<AssetEntity> _assets = [];
  late MessageBox messageBox;

  _ProfileSettingPageState(this._profileSettingDto);

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
          _profileSettingDto.userId,
          Constants.profileSettingImageSize,
          canJump: false,
          imageContent: _assets.first,
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
    super.initState();
    _gender = genderEnum2StringMap[_profileSettingDto.gender]!;
    _userAvatar = UserAvatar(
      _profileSettingDto.userId,
      Constants.profileSettingImageSize,
      imageContent: _profileSettingDto.userAvatar,
      canJump: false,
    );
    _userNameController =
        TextEditingController(text: this._profileSettingDto.userName);
    _briefController =
        TextEditingController(text: this._profileSettingDto.brief);
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
                icon: _isLoading
                    ? CupertinoActivityIndicator()
                    : Icon(Icons.check),
                onPressed: () async {
                  if (_isUserNameValid && _isIntroductionValid) {
                    bool errorFlag = false;
                    setState(() => _isLoading = true);
                    try {
                      final Response response =
                          await ProfileService.putProfileSetting(
                              "/profiles/settings", (await formData()));
                      Map userNameAndAvatarUrl = response.data;
                      StorageUtil().writeOnProfileChange(
                          userNameAndAvatarUrl['userName'],
                          userNameAndAvatarUrl['avatarUrl']);
                    } on DioError catch (e) {
                      errorFlag = true;
                      MessageBox.showToast(
                          msg: e.response == null
                              ? Constants.networkError
                              : e.response!.data,
                          messageBoxType: MessageBoxType.Error);
                    }
                    if (!errorFlag) {
                      MessageBox.showToast(
                          msg: "保存成功", messageBoxType: MessageBoxType.Success);
                      Navigator.pushAndRemoveUntil(
                          context,
                          RouteGenerator.generateRoute(RouteSettings(
                            name: RouteGenerator.homeRoute,
                            arguments: 2,
                          )),
                          (_) => false);
                    }
                    setState(() => _isLoading = false);
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Form(
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
          _gap,
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
            maxLines: 1,
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
                child: AdaptivePicker(
                    dropdownItems: ['男', '女', '保密'],
                    initialSelectedIndex:
                        Gender.values.indexOf(_profileSettingDto.gender),
                    onSelect: (int index, String item) {
                      _gender = item;
                    }),
              ),
            ],
          ),
          _itemDivider,
        ],
      )),
    );
  }
}
