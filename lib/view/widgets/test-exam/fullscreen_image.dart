import 'package:flutter/material.dart';
import 'package:flutter_button/flutter_button.dart';
import 'package:photo_view/photo_view.dart';

import '../components/widgets.dart';

class FullscreenImage extends DevExamStatelessWidget {
  final String image;

  FullscreenImage({
    Key key,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(.9),
      appBar: appBar(context),
      body: Container(
        width: double.infinity,
        child: buildPhotoView(),
      ),
    );
  }

  PhotoView buildPhotoView() => PhotoView(
        backgroundDecoration: BoxDecoration(color: Colors.transparent),
        minScale: PhotoViewComputedScale.contained,
        imageProvider: AssetImage(image),
      );

  AppBar appBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white.withOpacity(.9),
      leading: OpacityButton(
        opacityValue: .3,
        child: Icon(
          Icons.close_fullscreen,
          color: Colors.black,
        ),
        onTap: () => Navigator.pop(context),
      ),
    );
  }
}
