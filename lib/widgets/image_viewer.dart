import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageViewer extends StatelessWidget {
  final String url;
  const ImageViewer({Key key, this.url}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
    child: PhotoView(
      imageProvider: NetworkImage(url),
    )
  );
  }
}