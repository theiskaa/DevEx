import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../widgets/components/widgets.dart';

// ignore: must_be_immutable
class ExamInfo extends DevExamStatelessWidget {
  @override
  Widget build(BuildContext context) {
    String info = "${devExam.intl.of(context).fmt('exam.info')}";
    //
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ],
    );
    //
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(.8),
      appBar: buildAppBar(context),
      body: buildBody(context, info),
    );
  }

  Widget buildBody(BuildContext context, String info) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 45),
            Image.asset(
              'assets/custom/exam.png',
              height: 200,
            ),
            SizedBox(height: 15),
            buildTitle(context),
            SizedBox(height: 15),
            buildInfoTitle(info)
          ],
        ),
      ),
    );
  }

  Text buildInfoTitle(String info) {
    return Text(
      info,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 23,
        color: Colors.black.withOpacity(.7),
      ),
    );
  }

  Text buildTitle(BuildContext context) {
    return Text(
      "${devExam.intl.of(context).fmt('exam.info.title')}",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 30,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      backgroundColor: Colors.white.withOpacity(.7),
    );
  }
}
