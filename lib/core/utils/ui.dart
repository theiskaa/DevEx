import 'package:flutter/material.dart';

import '../../view/widgets/test-exam/circular_countdown_timer.dart';
import '../system/devexam.dart';

/// The profile/settings drop down items.
Widget menuButton(String item, IconData icon) {
  return Container(
    padding: EdgeInsets.only(bottom: 10, top: 10),
    decoration: BoxDecoration(
      border: Border(bottom: BorderSide(color: Colors.grey)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(item)),
        Icon(icon),
      ],
    ),
  );
}

/// The list of profile/settings drop down item's strings.
List<String> menuStrings(BuildContext context, DevExam devExam) => [
      "${devExam.intl.of(context).fmt('more.clearExamResults')}",
      "${devExam.intl.of(context).fmt('more.changeUsername')}",
      "${devExam.intl.of(context).fmt('more.resetPassword')}",
      "${devExam.intl.of(context).fmt('more.changeLanguage')}",
      "${devExam.intl.of(context).fmt('more.title')}",
      "${devExam.intl.of(context).fmt('more.logout')}",
    ];

/// The List of profile/settings drop down item's icons.
List<IconData> menuIcons = [
  Icons.history,
  Icons.person_outline_outlined,
  Icons.lock_outlined,
  Icons.language,
  Icons.settings,
  Icons.exit_to_app,
];

/// Get valid icon by listening `menuStrings`.
IconData getValidIcon(Object item, BuildContext context, DevExam devExam) {
  if (item == menuStrings(context, devExam)[0]) {
    return menuIcons[0];
  } else if (item == menuStrings(context, devExam)[1]) {
    return menuIcons[1];
  } else if (item == menuStrings(context, devExam)[2]) {
    return menuIcons[2];
  } else if (item == menuStrings(context, devExam)[3]) {
    return menuIcons[3];
  } else if (item == menuStrings(context, devExam)[4]) {
    return menuIcons[4];
  } else if (item == menuStrings(context, devExam)[5]) {
    return menuIcons[5];
  } else {
    return null;
  }
}

/// Custom divider.
Widget divider() {
  return Divider(
    height: 5,
    thickness: 1,
    indent: 50,
    endIndent: 50,
  );
}

/// For display snackbar by simple way.
void showSnack({
  BuildContext context,
  String title,
  Color color,
  bool isFloating = false,
  int sec,
  @required DevExam devExam,
}) async {
  final snack = SnackBar(
    content: Text(
      title,
      style: TextStyle(color: Colors.white),
    ),
    duration: Duration(seconds: (sec != null) ? sec : 3),
    margin: isFloating ? EdgeInsets.all(8) : null,
    behavior: isFloating ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
    shape: RoundedRectangleBorder(
      borderRadius: isFloating
          ? BorderRadius.circular(8)
          : BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
    ),
    backgroundColor: color,
  );

  void showSnack = ScaffoldMessenger.of(context).showSnackBar(snack);
  return showSnack;
}

/// For display complex/timer/acter snackbar by simple way.
Future<void> showActerSnack({
  BuildContext context,
  String title,
  Color color,
  bool isFloating = false,
  int sec,
  Function onComplete,
  Function onDissmissed,
  String actTitle,
}) async {
  Widget timer = Padding(
    padding: EdgeInsets.all(2),
    child: CircularCountDownTimer(
      duration: sec ?? 5,
      width: 30,
      textFormat: "",
      height: 30,
      color: Colors.white,
      fillColor: color,
      backgroundColor: null,
      strokeWidth: 2,
      textStyle: TextStyle(
        fontSize: 12,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      isReverse: true,
      isTimerTextShown: true,
      onComplete: () => onComplete(),
    ),
  );

  // The snackbar.
  final snack = SnackBar(
    content: WillPopScope(
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 10,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          timer,
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              "$title...",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      onWillPop: () async {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        return true;
      },
    ),
    duration: Duration(seconds: (sec != null) ? sec : 5),
    margin: isFloating ? EdgeInsets.all(8) : null,
    behavior: isFloating ? SnackBarBehavior.floating : SnackBarBehavior.fixed,
    shape: RoundedRectangleBorder(
      borderRadius: isFloating
          ? BorderRadius.circular(8)
          : BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
    ),
    backgroundColor: color,
    action: SnackBarAction(
      label: "$actTitle",
      textColor: Colors.white,
      onPressed: () {
        return onDissmissed();
      },
    ),
  );

  void showSnack = ScaffoldMessenger.of(context).showSnackBar(snack);
  return showSnack;
}

ButtonStyle alertButtonsStyle(Color color) {
  return ButtonStyle(
    foregroundColor: MaterialStateProperty.all<Color>(color),
    overlayColor: MaterialStateProperty.resolveWith<Color>(
      (Set<MaterialState> states) {
        if (states.contains(MaterialState.hovered))
          return color.withOpacity(.3);
        if (states.contains(MaterialState.focused) ||
            states.contains(MaterialState.pressed))
          return color.withOpacity(0.2);
        return null;
      },
    ),
  );
}
