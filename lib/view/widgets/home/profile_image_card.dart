import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../components/widgets.dart';

class ProfileImageCard extends DevExamStatelessWidget {
  final double size;
  final String imageUrl;

  ProfileImageCard({
    @required this.size,
    @required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: buildBoxDecoration(),
      child: buildGridAndImg(),
    );
  }

  CustomPaint buildGridAndImg() {
    return CustomPaint(
      painter: borderPaint(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(300),
            child: imageUrl == "loading"
                ? SpinKitFadingCircle(
                    color: Color(0xff017296),
                    size: 30,
                  )
                : CachedNetworkImage(
                    imageUrl: imageUrl,
                    placeholder: (context, imageUrl) => SpinKitFadingCircle(
                      color: Color(0xff017296),
                      size: 30,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
          ),
        ),
      ),
    );
  }

  BoxDecoration buildBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(300),
      boxShadow: [
        BoxShadow(
          spreadRadius: .3,
          color: Colors.black.withOpacity(.5),
          blurRadius: 15,
          offset: Offset(0, 8),
        ),
      ],
    );
  }

  _GradientBorderPaint borderPaint() {
    return _GradientBorderPaint(
      strokeWidth: 5,
      radius: 100,
      gradient: LinearGradient(
        colors: [
          Color(0xff2865CE),
          Color(0xff8C3FF5),
          Color(0xff1437C2),
          Color(0xff3C1571),
        ],
      ),
    );
  }
}

class _GradientBorderPaint extends CustomPainter {
  final Paint _paint = Paint();
  final double radius;
  final double strokeWidth;
  final Gradient gradient;

  _GradientBorderPaint({
    @required double strokeWidth,
    @required double radius,
    @required Gradient gradient,
  })  : this.strokeWidth = strokeWidth,
        this.radius = radius,
        this.gradient = gradient;

  @override
  void paint(Canvas canvas, Size size) {
    double defaultStroke = (strokeWidth != null) ? strokeWidth : 2;
    double defaultRadius = (radius != null) ? radius : 200;

    Rect outerRect = Offset.zero & size;
    var outerRRect =
        RRect.fromRectAndRadius(outerRect, Radius.circular(defaultRadius));

    Rect innerRect = Rect.fromLTWH(
      defaultStroke,
      defaultStroke,
      size.width - defaultStroke * 2,
      size.height - defaultStroke * 2,
    );
    var innerRRect = RRect.fromRectAndRadius(
      innerRect,
      Radius.circular(
        defaultRadius - defaultStroke,
      ),
    );

    _paint.shader = gradient.createShader(outerRect);

    Path firstPath = Path()..addRRect(outerRRect);
    Path seccondPath = Path()..addRRect(innerRRect);
    var path = Path.combine(PathOperation.difference, firstPath, seccondPath);
    canvas.drawPath(path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => oldDelegate != this;
}
