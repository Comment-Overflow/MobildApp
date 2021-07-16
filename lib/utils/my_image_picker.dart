import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MyImagePicker {

  List<PickedFile>? imageFileList;

  set _imageFile(PickedFile? value) {
    imageFileList = value == null ? null : [value];
  }

  dynamic pickImageError;
  final ImagePicker _picker = ImagePicker();

  Future<List<PickedFile>?> pickImage(ImageSource source,
      {BuildContext? context, bool isMultiImage = false,
        double? maxWidth, double? maxHeight, int? quality}) async {
    if (isMultiImage) {
      try {
        final pickedFileList = await _picker.getMultiImage(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: quality,
        );
        imageFileList = pickedFileList;
      } catch (error) {
        pickImageError = error;
      }
    } else {
      try {
        final pickedFile = await _picker.getImage(
          source: source,
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          imageQuality: quality,
        );
        _imageFile = pickedFile;
      } catch (error) {
        pickImageError = error;
      }
    }
    return imageFileList;
  }

}