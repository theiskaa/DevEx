import 'package:flutter/material.dart';
import 'package:flutter_button/flutter_button.dart';

import '../components/widgets.dart';

class TestCategoriesCard extends DevExamStatelessWidget {
  final Color color;
  final String title;
  final Color textColor;
  final double fontSize;
  final Function onTap;
  final Border border;

  TestCategoriesCard({
    Key key,
    this.color,
    this.textColor,
    this.title,
    this.fontSize,
    this.onTap,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpacityButton(
      opacityValue: .5,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: buildButtonBody(),
      ),
    );
  }

  Container buildButtonBody() {
    return Container(
      padding: EdgeInsets.all(10),
      width: 300,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        border: border,
      ),
      child: Center(
        child: buildTitle(),
      ),
    );
  }

  Text buildTitle() => Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
        ),
      );
}
