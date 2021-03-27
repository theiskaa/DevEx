import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_button/flutter_button.dart';

import '../../../../../core/utils/ui.dart';
import '../../../../widgets/components/widgets.dart';
import '../../../../widgets/test-exam/choise_button.dart';
import '../../../../widgets/test-exam/circular_countdown_timer.dart';
import '../../../../widgets/test-exam/fullscreen_image.dart';
import '../../main/main_screen.dart';
import 'result_exam.dart';

// ignore: must_be_immutable
class ExamScreen extends DevExamStatefulWidget {
  var data;
  final userID;
  ExamScreen({Key key, this.data, @required this.userID}) : super(key: key);
  @override
  _ExamScreenState createState() => _ExamScreenState(data: data);
}

class _ExamScreenState extends DevExamState<ExamScreen> {
  var data;
  _ExamScreenState({this.data});

  int correctAnswers = 0;
  int incorrectAnswers = 0;
  int currentQuestionIndex = 1;
  List<dynamic> allQuestions;
  var allQuestionsLenght;
  Color currentColor = Color(0xff2865CE);
  bool buttonDisabled = false;

  int incorrectAnswersListCounter = 0;
  List<dynamic> incorrectAnswersList = [{}, {}];

  @override
  void initState() {
    super.initState();
    allQuestions = data[1].keys.toList();
    allQuestionsLenght = allQuestions.length;
  }

  void nextQuestion() {
    setState(() {
      buttonDisabled = false;
      if (currentQuestionIndex < allQuestionsLenght) {
        currentQuestionIndex++;
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => ExamResult(
              userID: widget.userID,
              correctAnswers: correctAnswers,
              incorrectAnswers: incorrectAnswers,
              incorrectAnswersList: incorrectAnswersList,
              allQuestionLenght: allQuestionsLenght,
            ),
          ),
          (route) => false,
        );
      }
    });
  }

  void checkAnswer(String k) async {
    if (data[1][currentQuestionIndex.toString()][k] ==
        data[1][currentQuestionIndex.toString()]["answer"]) {
      correctAnswers += 1;
    } else {
      incorrectAnswers += 1;
      setState(() {
        incorrectAnswersListCounter++;
        print(incorrectAnswersListCounter);
        incorrectAnswersList[0].putIfAbsent(
          incorrectAnswersListCounter.toString(),
          () => data[0][currentQuestionIndex.toString()],
        );
        incorrectAnswersList[1].putIfAbsent(
          incorrectAnswersListCounter.toString(),
          () => data[1][currentQuestionIndex.toString()],
        );
      });
    }
    setState(() {
      buttonDisabled = true;
    });
    await Future.delayed(Duration(seconds: 1));
    return nextQuestion();
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
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: buildBody(),
      ),
      onWillPop: () => showDialog(
        context: context,
        builder: (context) => buildAlertDialog(),
      ),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            buildQuestionText(),
            SizedBox(height: 5),
            buildImageContainer(),
            SizedBox(height: 5),
            buildAnswerButtons(),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget buildImageContainer() {
    return OpacityButton(
      opacityValue: .5,
      onTap: () {
        if (data[1][currentQuestionIndex.toString()]["img"] !=
            "assets/img/none.png") {
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (
                BuildContext context,
                _,
                __,
              ) =>
                  FullscreenImage(
                image: data[1][currentQuestionIndex.toString()]["img"],
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          child: ClipRRect(
            child: Image.asset(data[1][currentQuestionIndex.toString()]["img"]),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Column buildAnswerButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildChoiseButton("a"),
        buildChoiseButton("b"),
        buildChoiseButton("c"),
      ],
    );
  }

  ChoiseButton buildChoiseButton(String k) {
    return ChoiseButton(
      title: data[1][currentQuestionIndex.toString()][k],
      k: k.toUpperCase(),
      circleColor: Color(0xff1437C2),
      color: Color(0xff2865CE),
      textColor: Colors.white,
      onTap: !buttonDisabled
          ? () => checkAnswer(k)
          : () => print("==== button was disabled ===="),
    );
  }

  Widget buildQuestionText() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [devExam.theme.accentExamBlue, devExam.theme.darkExamBlue],
          ),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            topLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
        ),
        padding: EdgeInsets.all(30),
        alignment: Alignment.bottomCenter,
        child: Text(
          data[0][currentQuestionIndex.toString()],
          style: TextStyle(
            fontSize: "${data[0][currentQuestionIndex.toString()]}"
                        .characters
                        .length >
                    100
                ? 22
                : 25,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text("$currentQuestionIndex/$allQuestionsLenght",
          style: TextStyle(color: Colors.black)),
      leading: OpacityButton(
        opacityValue: .3,
        child: Icon(
          Icons.close,
          color: Colors.black,
        ),
        onTap: () => showDialog(
          context: context,
          builder: (context) => buildAlertDialog(),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: buildCircularCountDownTimer(context),
        ),
      ],
    );
  }

  CircularCountDownTimer buildCircularCountDownTimer(BuildContext context) {
    return CircularCountDownTimer(
      duration: 900,
      width: 45,
      height: 45,
      color: devExam.theme.darkExamBlue,
      fillColor: Colors.white,
      backgroundColor: null,
      strokeWidth: 3.5,
      textStyle: TextStyle(
        fontSize: 10.5,
        color: devExam.theme.darkExamBlue,
        fontWeight: FontWeight.bold,
      ),
      isReverse: true,
      isTimerTextShown: true,
      onComplete: () {
        print('Countdown Ended');
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => ExamResult(
              userID: widget.userID,
              correctAnswers: correctAnswers,
              incorrectAnswers: incorrectAnswers,
            ),
          ),
          (route) => false,
        );
      },
    );
  }

  AlertDialog buildAlertDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      title: Text("${devExam.intl.of(context).fmt('exam.exitAsk')}"),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            devExam.intl.of(context).fmt('act.cancel'),
            style: TextStyle(color: Colors.blue),
          ),
        ),
        TextButton(
          style: alertButtonsStyle(Colors.red),
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(),
            ),
            (route) => false,
          ),
          child: Text(
            devExam.intl.of(context).fmt('act.signout'),
            style: TextStyle(color: Colors.red),
          ),
        )
      ],
    );
  }
}
