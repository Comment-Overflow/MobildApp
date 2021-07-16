import 'package:comment_overflow/assets/custom_styles.dart';
import 'package:comment_overflow/fake_data/fake_data.dart';
import 'package:comment_overflow/model/user_info.dart';
import 'package:comment_overflow/widgets/personal_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PersonalPage extends StatefulWidget {
  const PersonalPage({Key? key}) : super(key: key);

  @override
  _PersonalPageState createState() => _PersonalPageState();
}

class _PersonalPageState extends State<PersonalPage> {

  PersonalPageInfo _personalPageInfo = personalPageInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "个人主页",
          style: CustomStyles.pageTitleStyle,
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          PersonalHeader(_personalPageInfo)
        ],
      ),
    );
  }
}
