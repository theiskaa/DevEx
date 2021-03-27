import 'package:flutter/material.dart';

import '../components/widgets.dart';

class ChoiseButton extends DevExamStatelessWidget {
  final Function onTap;
  final String title;
  final String k;
  final Color textColor;
  final Color color;
  final Color circleColor;

  ChoiseButton({
    Key key,
    this.onTap,
    this.title,
    this.k,
    this.color,
    this.textColor,
    this.circleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: buildButton(),
    );
  }

  MaterialButton buildButton() {
    return MaterialButton(
      splashColor: Colors.black54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      height: 40,
      minWidth: 200,
      color: color,
      onPressed: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            kCard(),
            SizedBox(width: 10),
            titleText(),
          ],
        ),
      ),
    );
  }

  Expanded titleText() {
    return Expanded(
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: title.length < 20 ? 19 : 16.5,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 10,
      ),
    );
  }

  Container kCard() {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: circleColor,
      ),
      child: Center(
        child: Text(
          k,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
      ),
    );
  }
}
