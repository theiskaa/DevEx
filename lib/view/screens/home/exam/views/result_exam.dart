import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../../core/services/user_service.dart';
import '../../../../../core/utils/connectivity.dart';
import '../../../../widgets/components/widgets.dart';
import '../../../../widgets/test-exam/exam_splash_button.dart';
import '../../main/main_screen.dart';

// ignore: must_be_immutable
class ExamResult extends DevExamStatefulWidget {
  final int correctAnswers;
  final int incorrectAnswers;
  final userID;
  List<dynamic> incorrectAnswersList;
  final int allQuestionLenght;

  ExamResult({
    Key key,
    this.correctAnswers,
    this.incorrectAnswers,
    @required this.userID,
    this.incorrectAnswersList,
    this.allQuestionLenght,
  }) : super(key: key);

  @override
  _ExamResultState createState() => _ExamResultState(
        correctAnswers: correctAnswers,
        incorrectAnswers: incorrectAnswers,
        allQuestionLenght: allQuestionLenght,
        incorrectAnswersList: incorrectAnswersList,
      );
}

class _ExamResultState extends DevExamState<ExamResult> {
  int correctAnswers;
  int incorrectAnswers;
  int allQuestionLenght;
  List<dynamic> incorrectAnswersList;
  final _userService = UserServices();

  _ExamResultState({
    this.correctAnswers,
    this.incorrectAnswers,
    this.allQuestionLenght,
    this.incorrectAnswersList,
  });

  String image;

  final _connection = ConnectivityObserver();
  bool _showNoInternet = false;

  bool isButtonDisabled = true;

  @override
  void initState() {
    if (correctAnswers < 5) {
      image = "assets/custom/bad.png";
      // shenit shoperi ar gomova cay locikoba ikitxe (bez pilotcikisi)
    } else if (correctAnswers >= 5 && correctAnswers <= 8) {
      image = "assets/custom/good.png";
    } else if (correctAnswers > 8 && correctAnswers <= 10) {
      image = "assets/custom/better.png";
    }
    _connection.offlineAction = showError;
    _connection.onlineAction = hideError;
    _connection.connectionTest();
    Timer(Duration(seconds: 2), () => saveExamResultToCloud(context));
    super.initState();
  }

  void saveExamResultToCloud(BuildContext contxt) async {
    if (_showNoInternet) {
      print("NO INTERNET");
    } else {
      var result = await _userService.saveExamHistory(
        correctAnswersCount: "$correctAnswers",
        incorrectAnswersCount: "$incorrectAnswers",
        personID: widget.userID,
        incorrectAnswersList: incorrectAnswersList,
        context: context,
        devExam: devExam,
      );
      if (result == true) {
        print("Successfullt saved data on cloud");
      } else {
        print("couldn't save data to cloud");
        // ignore: deprecated_member_use
        // Scaffold.of(contxt).showSnackBar(
        //   SnackBar(
        //     content: Text(
        //       devExam.intl.of(contxt).fmt('attention.cantSaveExamResult'),
        //     ),
        //   ),
        // );
      }
    }
    setState(() => isButtonDisabled = false);
  }

  @override
  void dispose() {
    if (_connection.timerHandler != null) {
      _connection.timerHandler.cancel();
    }
    super.dispose();
  }

  void showError() {
    setState(() => _showNoInternet = true);
  }

  void hideError() {
    setState(() => _showNoInternet = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Center(child: buildBody()),
        ),
      ),
    );
  }

  Widget buildBody() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 30),
          buildImage(),
          SizedBox(height: 40),
          buildResults(),
          SizedBox(height: 40),
          buildButtons(),
        ],
      ),
    );
  }

  Padding buildResults() {
    return Padding(
      padding: const EdgeInsets.all(13),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildMessageResult(
            "${devExam.intl.of(context).fmt('examResult.correctAnswers')}:",
            correctAnswers,
          ),
          SizedBox(height: 20),
          buildMessageResult(
            "${devExam.intl.of(context).fmt('examResult.incorrectAnswers')}:",
            incorrectAnswers,
          ),
        ],
      ),
    );
  }

  Widget buildMessageResult(String message, int result) {
    return Container(
      child: RichText(
        text: TextSpan(
          text: "$message ",
          style: TextStyle(
            color: Colors.black,
            fontSize: getSizeOfText(),
          ),
          children: [
            TextSpan(
              text: "$result ",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: getSizeOfText() + 2,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Image buildImage() {
    return Image.asset(
      image ?? "assets/img/none.png",
      height: image != null ? 200 : 0,
    );
  }

  double getSizeOfText() {
    if (devExam.intl.of(context).fmt('lang') == "en") {
      return 25;
    } else if (devExam.intl.of(context).fmt('lang') == "ru") {
      return 22;
    } else {
      return null;
    }
  }

  Widget buildButtons() {
    return ExamSplashButton(
      disabled: isButtonDisabled,
      title: " ${devExam.intl.of(context).fmt('act.goBack')} ",
      onPress: () => Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(),
        ),
        (route) => false,
      ),
    );
  }
}
