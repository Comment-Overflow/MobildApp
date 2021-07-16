import 'package:flutter/material.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class MyImagePicker {

  static Future<List<AssetEntity>?> pickImage(BuildContext context, {
    maxAssets: 9, selectedAssets
  }) async {
    return AssetPicker.pickAssets(
      context,
      maxAssets: maxAssets,
      themeColor: Colors.blueAccent,
      pathThumbSize: 84,
      selectedAssets: selectedAssets,
      requestType: RequestType.image,
    );
  }

}