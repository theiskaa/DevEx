import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../widgets/components/widgets.dart';
import '../../../widgets/home/home_card.dart';
import '../exam/views/exam_info.dart';
import '../exam/views/exam_splash.dart';
import '../training/view/test_info.dart';
import '../training/view/test_splash.dart';

class Home extends DevExamStatefulWidget {
  final userID;
  Home({@required this.userID});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends DevExamState<Home> {
  @override
  Widget build(BuildContext context) {
    //
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ],
    );
    //
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            SizedBox(height: 10),
            buildHomeItem1(context),
            buildHomeItem2(context),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget buildHomeItem1(BuildContext context) {
    return HomeCard(
      tag: 'assets/custom/test.png',
      img: 'assets/custom/test.png',
      onLongPress: () => Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (
            BuildContext context,
            _,
            __,
          ) =>
              TestInfo(),
        ),
      ),
      onTap: () => Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) =>
              GenerateOfTestSplash(userID: widget.userID),
        ),
      ),
    );
  }

  Widget buildHomeItem2(BuildContext context) {
    return HomeCard(
      tag: 'assets/custom/exam.png',
      img: 'assets/custom/exam.png',
      onLongPress: () => Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (
            BuildContext context,
            _,
            __,
          ) =>
              ExamInfo(),
        ),
      ),
      onTap: () => Navigator.of(context).push(
        PageRouteBuilder(
          opaque: false,
          pageBuilder: (BuildContext context, _, __) => ExamSplash(
            userID: widget.userID,
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      leading: SizedBox(height: 5),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }
}
