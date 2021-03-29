import 'package:flutter/material.dart';

import '../components/widgets.dart';

class SearchQuestionDropDown extends DevExamStatelessWidget {
  final Widget child;
  SearchQuestionDropDown({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      DecoratedBox(decoration: buildDecoration(), child: buildChild());

  Padding buildChild() =>
      Padding(padding: EdgeInsets.symmetric(horizontal: 40), child: child);

  ShapeDecoration buildDecoration() {
    return ShapeDecoration(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 2,
          style: BorderStyle.solid,
          color: devExam.theme.darkTestPurple,
        ),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    );
  }
}
