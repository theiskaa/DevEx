import 'package:flutter/material.dart';

import '../components/widgets.dart';

class HomeCard extends DevExamStatelessWidget {
  final Function onTap;
  final Function onLongPress;
  final String img;
  final String tag;

  HomeCard({
    Key key,
    this.onTap,
    this.onLongPress,
    this.img,
    this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        splashColor: Colors.black.withOpacity(.6),
        highlightColor: Colors.grey.withOpacity(.5),
        onLongPress: onLongPress,
        child: gridOfCard(context),
      ),
    );
  }

  Padding gridOfCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Container(
        width: MediaQuery.of(context).size.width - 100,
        height: MediaQuery.of(context).size.width - 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              spreadRadius: .3,
              color: Colors.grey[700],
              blurRadius: 15,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: Hero(
            tag: tag,
            child: Image.asset(img, height: 220),
          ),
        ),
      ),
    );
  }
}
