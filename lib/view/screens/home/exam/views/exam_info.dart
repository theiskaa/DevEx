import 'package:devexam/core/blocs/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      backgroundColor: BlocProvider.of<ThemeBloc>(context).state.themeData ==
              devExam.theme.dark
          ? devExam.theme.dark.scaffoldBackgroundColor.withOpacity(.7)
          : Colors.white.withOpacity(.7),
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
      ),
    );
  }

  Text buildTitle(BuildContext context) {
    return Text(
      "${devExam.intl.of(context).fmt('exam.info.title')}",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.pop(context),
      ),
      backgroundColor: BlocProvider.of<ThemeBloc>(context).state.themeData ==
              devExam.theme.dark
          ? devExam.theme.dark.scaffoldBackgroundColor.withOpacity(.7)
          : Colors.white.withOpacity(.7),
    );
  }
}
