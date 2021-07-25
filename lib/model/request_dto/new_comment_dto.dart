import 'package:dio/dio.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class NewCommentDTO {
  final int _postId;
  final int _quoteId;
  final String _content;
  final List<AssetEntity> _imageList;

  NewCommentDTO({
    required int postId,
    required int quoteId,
    required String content,
    required List<AssetEntity> assets
  }) : _postId = postId,
        _quoteId = quoteId,
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
    "postId" : _postId,
    "quoteId" : _quoteId,
    "content": _content,
    "uploadFiles": await _transport(_imageList)
  });
}