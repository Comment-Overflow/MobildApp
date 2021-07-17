
import 'package:comment_overflow/widgets/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class ProfileSettingPage extends StatefulWidget {

  // final UserAvatar previousUserAvatar;
  // final String _previousIntroduction;
  // final String _previousNickname;
  // final String _previousGender;
  // we can't pass the initial value through constructor
  // my suggestion is initiating them in createState()

  ProfileSettingPage({Key? key}):super(key: key);

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
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _introductionController;
  late TextEditingController _nicknameController;

  @override
  void initState() {
    this._userAvatar = UserAvatar(30.0);
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
    _introductionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("编辑资料"),
        leading: IconButton(icon:Icon(Icons.arrow_back),
          onPressed: () => {
            Navigator.of(context).pushNamed('/')
          },
        ),
        actions: [
          new IconButton(
              icon: Icon(Icons.save),
              onPressed: (){
                print(_formKey.currentState!.validate());
                if(_formKey.currentState!.validate()){
                  showTopSnackBar(
                    context,
                    CustomSnackBar.info(
                      message: "保存成功",
                    ),
                  );
                }
              })
          ],
      ),
      body: _buildBody()
    );
  }

  Widget _buildBody() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(10.0),
        children: [
          _userAvatar,
          Text(
            "基本资料",
            style: new TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30.0
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Container(),
              ),
              Text(
                  "昵称",
                  style: new TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0
                  ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(),
              ),
              Expanded(
                flex: 15,
                child: Container(
                  height: 70.0,
                  child:TextFormField(
                    controller: _nicknameController,
                    inputFormatters: [
                      new LengthLimitingTextInputFormatter(10),
                    ],
                    maxLength: 10,
                    decoration: InputDecoration(
                      hintText: '昵称（必填）',
                      errorText: _isNicknameValid ? null : "昵称不可为空",
                      border: null,
                    ),
                    onFieldSubmitted: (value) {
                      setState(() {
                        value.isEmpty ? _isNicknameValid = false : _isNicknameValid = true;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Text(
            "一句话介绍",
            style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0
            ),
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
              border: null,
            ),
          ),
          DropdownButton<String>(
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
          )
        ],
      )
    );
  }
}
