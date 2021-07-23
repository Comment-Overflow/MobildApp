import 'dart:async';

import 'package:dio/dio.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class NewPostDTO {
  final String _tagString;
  final String _title;
  final String _content;
  final List<AssetEntity> _imageList;
  
  NewPostDTO({
    required String tag,
    required String title,
    required String content,
    required List<AssetEntity> assets
  }) : _tagString = tag,
      _title = title,
      _content = content,
      _imageList = assets;

  Future<List<MultipartFile>> _transport(List<AssetEntity> assets) async {
    var list = <MultipartFile>[];
    for (AssetEntity entity in assets) {
      list.add(MultipartFile.fromFileSync((await entity.file)!.path));
    }
    return list;
  }

  Future<FormData> formData() async => FormData.fromMap({
      "title": _title,
      "tag": _tagString,
      "content": _content,
      "uploadFiles": await _transport(_imageList)
  });

}