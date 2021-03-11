import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewPage extends StatefulWidget {
  final String heroTag;
  final List<int> imageBytes;

  PhotoViewPage({@required this.imageBytes, @required this.heroTag}) : assert(imageBytes != null);

  @override
  _PhotoViewPageState createState() => _PhotoViewPageState();
}

class _PhotoViewPageState extends State<PhotoViewPage> {
  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: widget.heroTag,
        child: Material(
          child: Container(
              child: PhotoView(
            imageProvider: MemoryImage(widget.imageBytes),
          )),
        ));
  }
}
