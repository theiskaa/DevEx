import 'package:flutter/material.dart';

import '../../../core/utils/ui.dart';
import '../components/widgets.dart';

class ChangeUsernameDialog extends DevExamStatelessWidget {
  final Color accentColor;
  final Color darkColor;
  final Function act;
  final double height;
  final Widget infoWidget;
  final String title;
  final String actTitle;
  final Widget textField;

  ChangeUsernameDialog({
    Key key,
    this.accentColor,
    this.darkColor,
    @required this.act,
    this.height,
    this.infoWidget,
    this.title,
    this.actTitle,
    @required this.textField,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: shape(),
      title: buildTitle(context),
      content: buildContent(),
      actions: actionList(context, act),
    );
  }

  Text buildTitle(BuildContext context) {
    return Text(
      (title != null)
          ? title
          : devExam.intl.of(context).fmt('changeUsername.title'),
    );
  }

  Container buildContent() {
    return Container(
      height: (height != null) ? height : 120,
      child: Column(
        children: [
          textField,
          (infoWidget != null) ? SizedBox(height: 10) : Container(),
          (infoWidget != null) ? infoWidget : Container(),
        ],
      ),
    );
  }

  List<Widget> actionList(BuildContext context, Function actH) {
    return [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(
          devExam.intl.of(context).fmt('act.cancel'),
          style: TextStyle(color: Colors.blue),
        ),
      ),
      TextButton(
        style: alertButtonsStyle(Colors.red),
        onPressed: actH,
        child: Text(
          (actTitle != null)
              ? actTitle
              : devExam.intl.of(context).fmt('act.change'),
          style: TextStyle(color: Colors.red),
        ),
      ),
    ];
  }

  RoundedRectangleBorder shape() {
    return RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      side: BorderSide(color: Color(0xff017296)),
    );
  }
}
