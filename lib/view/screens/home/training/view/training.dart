import 'package:devexam/core/blocs/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_button/flutter_button.dart';

import '../../../../../core/services/user_service.dart';
import '../../../../../core/utils/connectivity.dart';
import '../../../../../core/utils/ui.dart';
import '../../../../widgets/components/widgets.dart';
import '../../../../widgets/test-exam/choise_button.dart';
import '../../../../widgets/test-exam/fullscreen_image.dart';
import '../../../../widgets/test-exam/next_button.dart';
import '../../main/main_screen.dart';
import 'thecorrect_answer.dart';

class TrainingScreen extends DevExamStatefulWidget {
  final data;
  final questionIndex;
  final userID;
  final bool isAbleToSaveQ;
  TrainingScreen(
      {Key key, this.data, this.questionIndex, this.userID, this.isAbleToSaveQ})
      : super(key: key);
  @override
  _TrainingScreenState createState() => _TrainingScreenState(data: data);
}

class _TrainingScreenState extends DevExamState<TrainingScreen> {
  var data;
  _TrainingScreenState({this.data});

  UserServices _userServices = UserServices();

  final _connection = ConnectivityObserver();
  bool _showNoInternet = false;

  int currentQuestionIndex = 1;
  List<dynamic> allQuestions;
  var allQuestionsLenght;
  Color right = Colors.green;
  Color wrong = Colors.red;
  Color currentColor = Color(0xff8C3FF5);
  bool disableButton = false;
  bool questionIsSaved = false;

  int savedQuestionLength = 0;
  List<dynamic> savedQuestionList = [{}, {}];

  Map<String, dynamic> buttonColor = {
    "a": Color(0xff8C3FF5),
    "b": Color(0xff8C3FF5),
    "c": Color(0xff8C3FF5),
  };

  void showError() {
    setState(() => _showNoInternet = true);
  }

  void hideError() {
    setState(() => _showNoInternet = false);
  }

  @override
  void initState() {
    super.initState();
    currentQuestionIndex = widget.questionIndex;
    allQuestions = data[1].keys.toList();
    allQuestionsLenght = allQuestions.length;
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

  void nextQuestion() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    setState(() {
      if (currentQuestionIndex < allQuestionsLenght) {
        currentQuestionIndex++;
      } else {
        showDialog(
          context: context,
          builder: (context) => buildAlertDialog(),
        );
      }

      buttonColor["a"] = Color(0xff8C3FF5);
      buttonColor["b"] = Color(0xff8C3FF5);
      buttonColor["c"] = Color(0xff8C3FF5);
      disableButton = false;
      questionIsSaved = false;
    });
  }

  void backQuestion() {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    setState(() {
      if (currentQuestionIndex > 1) {
        currentQuestionIndex--;
      } else {
        return null;
      }

      buttonColor["a"] = Color(0xff8C3FF5);
      buttonColor["b"] = Color(0xff8C3FF5);
      buttonColor["c"] = Color(0xff8C3FF5);
      disableButton = false;
      questionIsSaved = false;
    });
  }

  void saveQuestionToCustomCategory() {
    setState(() {
      savedQuestionLength++;
      questionIsSaved = true;
    });
    print(savedQuestionLength);
    savedQuestionList[0].putIfAbsent(
      savedQuestionLength.toString(),
      () => data[0][currentQuestionIndex.toString()],
    );
    savedQuestionList[1].putIfAbsent(
      savedQuestionLength.toString(),
      () => data[1][currentQuestionIndex.toString()],
    );
    print(savedQuestionList);
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
      [
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ],
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
      backgroundColor: devExam.theme.darkTestPurple,
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
      circleColor: devExam.theme.darkTestPurple,
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
            colors: [
              devExam.theme.accentTestPurple,
              devExam.theme.darkTestPurple,
            ],
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

  double getSizeOfAppBarTitle(BuildContext context) {
    if (devExam.intl.of(context).fmt('lang') == "en") {
      return 20;
    } else if (devExam.intl.of(context).fmt('lang') == "ru") {
      return 18;
    } else {
      return 18;
    }
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        "$currentQuestionIndex/$allQuestionsLenght",
        style: TextStyle(
          fontSize: getSizeOfAppBarTitle(context),
        ),
      ),
      leading: OpacityButton(
          opacityValue: .3,
          child: Icon(Icons.close),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => buildAlertDialog(),
            );
          }),
      actions: [
        questionIsSaved
            ? Icon(
                Icons.save_alt_rounded,
                color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                        devExam.theme.dark
                    ? Colors.white.withOpacity(.5)
                    : Colors.black.withOpacity(.5),
              )
            : OpacityButton(
                opacityValue: .3,
                child: Icon(
                  Icons.save_alt_rounded,
                ),
                onTap: () {
                  if (widget.isAbleToSaveQ == false) {
                    showSnack(
                      devExam: devExam,
                      context: context,
                      sec: 6,
                      title: devExam.intl
                          .of(context)
                          .fmt('attention.min10Question'),
                      color: devExam.theme.errorBg,
                    );
                  } else {
                    if (_showNoInternet) {
                      showSnack(
                        devExam: devExam,
                        context: context,
                        title: devExam.intl
                            .of(context)
                            .fmt('attention.noConnection'),
                        color: devExam.theme.errorBg,
                      );
                    } else {
                      setState(() => questionIsSaved = true);
                      showActerSnack(
                        context: context,
                        title: devExam.intl
                            .of(context)
                            .fmt('customCategory.saving'),
                        actTitle: devExam.intl.of(context).fmt('act.cancel'),
                        color: devExam.theme.darkTestPurple,
                        onComplete: () => saveQuestionToCustomCategory(),
                        onDissmissed: () {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          setState(() => questionIsSaved = false);
                        },
                      );
                    }
                  }
                },
              ),
        SizedBox(width: 20),
        OpacityButton(
          opacityValue: .3,
          child: Icon(
            Icons.description,
          ),
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
        SizedBox(width: 15),
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
      content: (savedQuestionList[0].length > 0)
          ? Text(
              "${devExam.intl.of(context).fmt('test.saved..')} ${savedQuestionList[0].length} ${devExam.intl.of(context).fmt('..test.questions')}",
              style: TextStyle(
                color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                        devExam.theme.dark
                    ? Colors.white.withOpacity(.9)
                    : Colors.black.withOpacity(.7),
              ),
            )
          : SizedBox(height: 0),
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
          onPressed: () async {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            setState(() {
              savedQuestionLength = 0;
              savedQuestionList[0] = {};
              savedQuestionList[0] = {};
            });
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen(),
                ),
                (route) => false);
          },
          child: Text(
            "${devExam.intl.of(context).fmt('act.signout')}",
            style: TextStyle(color: Colors.red),
          ),
        ),
        (savedQuestionList[0].length > 0)
            ? TextButton(
                style: alertButtonsStyle(devExam.theme.darkTestPurple),
                onPressed: () async {
                  ScaffoldMessenger.of(context).removeCurrentSnackBar();

                  var result = await _userServices.createCustomCategory(
                    uid: widget.userID,
                    savedQuestions: savedQuestionList,
                    context: context,
                    devExam: devExam,
                  );
                  print("===================== $result");
                  if (result == true) {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainScreen(),
                        ),
                        (route) => false);
                  } else {
                    Navigator.pop(context);
                    showSnack(
                      devExam: devExam,
                      context: context,
                      title:
                          "Couldn't created new custom category please check your internet connection, and try later.",
                      color: Color(0xff017296),
                    );
                  }
                },
                child: Text(
                  "${devExam.intl.of(context).fmt('test.act.createBack')}",
                  style: TextStyle(
                    color:
                        BlocProvider.of<ThemeBloc>(context).state.themeData ==
                                devExam.theme.dark
                            ? Colors.white
                            : devExam.theme.darkTestPurple,
                  ),
                ),
              )
            : SizedBox(height: 0),
      ],
    );
  }
}
