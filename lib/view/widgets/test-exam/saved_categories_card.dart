import 'package:flutter/material.dart';
import 'package:flutter_button/flutter_button.dart';

import '../components/widgets.dart';

class SavedQuestionCard extends DevExamStatelessWidget {
  final Color color;
  final String title;
  final Color textColor;
  final double fontSize;
  final Function onTap;
  final IconData icon;
  final Border border;
  final String questionsLength;

  SavedQuestionCard({
    Key key,
    this.color,
    this.textColor,
    this.title,
    this.fontSize,
    this.onTap,
    this.icon,
    this.border,
    this.questionsLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpacityButton(
      opacityValue: .5,
      onTap: onTap,
      child: body(),
    );
  }

  Widget body() {
    return Stack(
      children: [
        button(),
        questionsLength == "0" ? SizedBox() : questionsCounter(),
      ],
    );
  }

  Padding button() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: EdgeInsets.all(10),
        width: 300,
        decoration: buildBoxDecoration(),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              SizedBox(width: 15),
              buildTitle(),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration buildBoxDecoration() {
    return BoxDecoration(
      border: border,
      color: color,
      borderRadius: BorderRadius.circular(20),
    );
  }

  Text buildTitle() {
    return Text(
      title,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: fontSize,
      ),
    );
  }

  Positioned questionsCounter() {
    return Positioned(
      top: 3.0,
      right: 4.0,
      child: Container(
        height: 23,
        width: 23,
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            questionsLength ?? "!",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 11.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
