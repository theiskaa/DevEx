import 'package:devexam/view/widgets/components/opacity_button.dart';
import 'package:flutter/material.dart';

import '../components/widgets.dart';

class NextButton extends DevExamStatelessWidget {
  final String label;
  final Function onTap;

  NextButton({
    Key key,
    this.onTap,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OpacityButton(
      opacityValue: .4,
      onTap: onTap,
      child: buttonBody(context),
    );
  }

  Container buttonBody(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [labelText(context), Icon(Icons.arrow_forward_ios)],
      ),
    );
  }

  Text labelText(BuildContext context) => Text(
        label,
        style: TextStyle(
          fontSize: getSizeOfText(context),
          fontWeight: FontWeight.w700,
        ),
      );

  double getSizeOfText(BuildContext context) {
    if (devExam.intl.of(context).fmt('lang') == "az") {
      return 16;
    } else if (devExam.intl.of(context).fmt('lang') == "ru") {
      return 15;
    } else {
      return null;
    }
  }
}
