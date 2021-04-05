import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_button/flutter_button.dart';

import '../../../../../core/utils/ui.dart';
import '../../../../widgets/components/widgets.dart';
import '../../../../widgets/test-exam/choise_button.dart';
import '../../../../widgets/test-exam/fullscreen_image.dart';
import '../../../../widgets/test-exam/next_button.dart';
import '../../main/main_screen.dart';
import '../../training/view/thecorrect_answer.dart';

class ExamReview extends DevExamStatefulWidget {
  final List<dynamic> data;
  final questionIndex;

  ExamReview({Key key, this.data, this.questionIndex}) : super(key: key);
  @override
  _ExamReviewState createState() => _ExamReviewState(data: data);
}

class _ExamReviewState extends DevExamState<ExamReview> {
  final List<dynamic> data;
  _ExamReviewState({this.data});

  int currentQuestionIndex = 1;
  List<dynamic> allQuestions;
  var allQuestionsLenght;
  Color right = Colors.green;
  Color wrong = Colors.red;
  Color currentColor = Color(0xff2865CE);
  bool disableButton = false;

  Map<String, dynamic> buttonColor = {
    "a": Color(0xff2865CE),
    "b": Color(0xff2865CE),
    "c": Color(0xff2865CE),
  };

  @override
  void initState() {
    super.initState();
    currentQuestionIndex = widget.questionIndex;
    allQuestions = data[1].keys.toList();
    allQuestionsLenght = allQuestions.length;
  }

  void nextQuestion() {
    setState(() {
      if (currentQuestionIndex < allQuestionsLenght) {
        currentQuestionIndex++;
      } else {
        showDialog(
          context: context,
          builder: (context) => buildAlertDialog(),
        );
      }

      buttonColor["a"] = Color(0xff2865CE);
      buttonColor["b"] = Color(0xff2865CE);
      buttonColor["c"] = Color(0xff2865CE);
      disableButton = false;
    });
  }

  void backQuestion() {
    setState(() {
      if (currentQuestionIndex > 1) {
        currentQuestionIndex--;
      } else {
        return null;
      }

      buttonColor["a"] = Color(0xff2865CE);
      buttonColor["b"] = Color(0xff2865CE);
      buttonColor["c"] = Color(0xff2865CE);
      disableButton = false;
    });
  }

  void checkAnswer(String k) {
    if (data[1][currentQuestionIndex.toString()][k] ==
        data[1][currentQuestionIndex.toString()]["answer"]) {
      setState(() {
        buttonColor[k] = right;
        disableButton = true;
      });
    } else {
      currentColor = wrong;
      setState(() {
        buttonColor[k] = currentColor;
        disableButton = true;
        buttonColor[data[1][currentQuestionIndex.toString()]
            ["answerByLetter"]] = right;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //
    SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp],
    );
    //
    return WillPopScope(
      child: Scaffold(
        appBar: buildAppBar(context),
        body: buildSingleChildScrollView(),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniCenterFloat,
        floatingActionButton: buildBackButton(),
      ),
      onWillPop: () => showDialog(
        context: context,
        builder: (context) => buildAlertDialog(),
      ),
    );
  }

  CustomFAB buildBackButton() {
    return CustomFAB(
      backgroundColor: devExam.theme.darkExamBlue,
      child: Icon(Icons.keyboard_backspace_sharp, color: Colors.white),
      onTap: () => backQuestion(),
      bottomLeftRadius: 30,
      bottomRightRadius: 30,
      topLeftRadius: 30,
      topRightRadius: 30,
      border: BorderSide(color: Colors.black),
    );
  }

  Widget buildSingleChildScrollView() {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            SizedBox(height: 20),
            buildQuestionText(),
            SizedBox(height: 2.5),
            buildImageContainer(),
            SizedBox(height: 2.5),
            buildAnswerButtons(),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  Widget buildImageContainer() {
    if (data[1][currentQuestionIndex.toString()]["img"] ==
            "assets/img/none.png" ||
        data[1][currentQuestionIndex.toString()]["img"] == " ") {
      return SizedBox(height: 0, width: 0);
    } else {
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
          child: (data[1][currentQuestionIndex.toString()]["img"] != null)
              ? Container(
                  child: ClipRRect(
                    child: Image.asset(
                        data[1][currentQuestionIndex.toString()]["img"]),
                    borderRadius: BorderRadius.circular(30),
                  ),
                )
              : SizedBox.shrink(),
        ),
      );
    }
  }

  Column buildAnswerButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        buildChoiseButton("a", buttonColor['a']),
        buildChoiseButton("b", buttonColor['b']),
        buildChoiseButton("c", buttonColor['c']),
      ],
    );
  }

  Widget buildChoiseButton(String k, Color color) {
    return ChoiseButton(
      title: data[1][currentQuestionIndex.toString()][k],
      k: k.toUpperCase(),
      color: color,
      textColor: Colors.white,
      circleColor: devExam.theme.darkExamBlue,
      onTap: !disableButton
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
                    80
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
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
      title: Text(
        allQuestionsLenght > 1
            ? "$currentQuestionIndex/$allQuestionsLenght"
            : "",
        style: TextStyle(fontSize: 20),
      ),
      leading: OpacityButton(
        opacityValue: .3,
        child: Icon(Icons.close),
        onTap: () => showDialog(
          context: context,
          builder: (context) => buildAlertDialog(),
        ),
      ),
      actions: [
        OpacityButton(
          opacityValue: .3,
          child: Icon(Icons.description),
          onTap: () => Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              pageBuilder: (BuildContext context, _, __) => TheCorrectAnswer(
                data: data,
                i: currentQuestionIndex,
              ),
            ),
          ),
        ),
        SizedBox(width: 10),
        NextButton(
          label: devExam.intl.of(context).fmt('test.act.forward'),
          onTap: () => nextQuestion(),
        ),
      ],
    );
  }

  AlertDialog buildAlertDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Text(
        "${devExam.intl.of(context).fmt('test.wannaPassTest')}",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "${devExam.intl.of(context).fmt('act.cancel')}",
            style: TextStyle(color: Colors.blue),
          ),
        ),
        TextButton(
          style: alertButtonsStyle(Colors.red),
          onPressed: () => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => MainScreen(index: 1),
            ),
            (route) => false,
          ),
          child: Text(
            "${devExam.intl.of(context).fmt('act.signout')}",
            style: TextStyle(color: Colors.red),
          ),
        )
      ],
    );
  }
}
