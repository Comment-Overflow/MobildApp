class ImageGalleryDto {
  final List<String> _imageUrl;
  final int _index;

  List<String> get imageUrl => _imageUrl;
  int get index => _index;

  ImageGalleryDto(this._imageUrl, this._index);
}