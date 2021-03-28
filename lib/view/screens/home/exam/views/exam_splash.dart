import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/utils/connectivity.dart';
import '../../../../widgets/components/widgets.dart';
import '../../../../widgets/test-exam/exam_splash_button.dart';
import '../controller/getJsonForExam.dart';

class ExamSplash extends DevExamStatefulWidget {
  final userID;
  ExamSplash({Key key, @required this.userID}) : super(key: key);

  @override
  _ExamSplashState createState() => _ExamSplashState();
}

/*
   "16": {
      "a": "",
      "c": "",
      "des": "",
      "img": "",
      "answerByLetter": "",
      "answer": ""
    }
 */

class _ExamSplashState extends DevExamState<ExamSplash> {
  final _connection = ConnectivityObserver();
  bool _showNoInternet = false;

  void showError() {
    setState(() => _showNoInternet = true);
  }

  void hideError() {
    setState(() => _showNoInternet = false);
  }

  @override
  void initState() {
    super.initState();
    _connection.offlineAction = showError;
    _connection.onlineAction = hideError;
    _connection.connectionTest();
  }

  @override
  void dispose() {
    if (_connection.timerHandler != null) {
      _connection.timerHandler.cancel();
    }
    super.dispose();
  }

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
      backgroundColor: Colors.white.withOpacity(.9),
      appBar: buildAppBar(context),
      body: buildBody(context),
    );
  }

  SingleChildScrollView buildBody(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 25),
            buildImage(),
            _showNoInternet ? SizedBox(height: 20) : SizedBox(height: 0),
            _showNoInternet
                ? buildNoInternetCard(context)
                : SizedBox(height: 0),
            SizedBox(height: _showNoInternet ? 20 : 40),
            buildText(context),
            SizedBox(height: 25),
            buildButtons(context),
            SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Container buildNoInternetCard(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.red[700],
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            devExam.intl.of(context).fmt('exam.askNoConnection'),
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),
      ),
    );
  }

  Row buildButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ExamSplashButton(
          title: devExam.intl.of(context).fmt('act.no'),
          onPress: () => Navigator.pop(context),
          disabled: false,
        ),
        SizedBox(width: 20),
        ExamSplashButton(
          title: devExam.intl.of(context).fmt('act.yes'),
          disabled: false,
          onPress: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => GetJsonForExam(
                userID: widget.userID,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Text buildText(BuildContext context) {
    return Text(
      devExam.intl.of(context).fmt('exam.ask'),
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.black,
        fontSize: 35,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Hero buildImage() {
    return Hero(
      tag: "assets/custom/exam.png",
      child: Image.asset(
        'assets/custom/exam.png',
        height: 200,
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white.withOpacity(.9),
    );
  }
}
