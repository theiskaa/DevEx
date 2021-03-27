import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_button/flutter_button.dart';

import '../../../../../core/system/fire.dart';
import '../../../../../core/utils/connectivity.dart';
import '../../../../../core/utils/ui.dart';
import '../../../../widgets/components/loading.dart';
import '../../../../widgets/components/widgets.dart';
import '../../../../widgets/test-exam/saved_categories_card.dart';
import '../../../../widgets/test-exam/search_question_drowdown.dart';
import '../../../../widgets/test-exam/test_categories_card.dart';
import '../controller/getJsonForTraining.dart';
import 'custom/custom_categories.dart';

class GenerateOfTestSplash extends DevExamStatelessWidget {
  final userID;
  GenerateOfTestSplash({Key key, this.userID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString(
        "assets/json/${devExam.intl.of(context).fmt('lang')}.json",
      ),
      builder: (context, snapshot) {
        List data = jsonDecode(snapshot.data.toString());
        if (data == null) {
          return Loading();
        } else {
          return TestSplash(data: data, userID: userID);
        }
      },
    );
  }
}

class TestSplash extends DevExamStatefulWidget {
  final data;
  final userID;
  TestSplash({Key key, this.data, this.userID}) : super(key: key);

  @override
  _TestSplashState createState() => _TestSplashState(data: data);
}

class _TestSplashState extends DevExamState<TestSplash> {
  var data;
  _TestSplashState({this.data});

  final _connection = ConnectivityObserver();
  bool _showNoInternet = false;

  List<dynamic> allQuestions;

  Stream<QuerySnapshot> customCategorysStream;

  String lenghtOfSavedQuestions;
  @override
  void initState() {
    super.initState();
    customCategorysStream = usersRef
        .doc(widget.userID)
        .collection('savedQuestions')
        .orderBy("date", descending: true)
        .snapshots();
    allQuestions = data[1].keys.toList();
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

  void showError() {
    setState(() => _showNoInternet = true);
  }

  void hideError() {
    setState(() => _showNoInternet = false);
  }

  bool isAbleToSaveQuestion() {
    if (lenghtOfSavedQuestions == "10") {
      return false;
    } else if (lenghtOfSavedQuestions == "!") {
      return false;
    } else if (lenghtOfSavedQuestions == null) {
      return false;
    }
    return true;
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
      child: Center(
        child: Column(
          children: [
            Hero(
              tag: 'assets/custom/test.png',
              child: Image.asset('assets/custom/test.png', height: 180),
            ),
            SizedBox(height: 30),
            buildCategories(context),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Column buildCategories(BuildContext context) {
    return Column(
      children: [
        searchQuestionDropDown(),
        customCategoriesCard(),
        SizedBox(height: 15),
        divider(context),
        SizedBox(height: 15),
        categories()
      ],
    );
  }

  StreamBuilder<QuerySnapshot> customCategoriesCard() {
    return StreamBuilder<QuerySnapshot>(
      stream: customCategorysStream,
      builder: (context, snapshot) {
        String rightquestionsLength() {
          if (snapshot.hasData) {
            lenghtOfSavedQuestions = "${snapshot.data.docs.length}";
          } else if (snapshot.hasError) {
            lenghtOfSavedQuestions = "!";
          } else {
            lenghtOfSavedQuestions = "0";
          }

          return lenghtOfSavedQuestions;
        }

        return SavedQuestionCard(
          questionsLength: !_showNoInternet ? rightquestionsLength() : "!",
          color: devExam.theme.darkTestPurple,
          title: devExam.intl.of(context).fmt('category.customs'),
          icon: Icons.save_alt_rounded,
          fontSize: 18,
          textColor: Colors.white,
          onTap: () {
            if (_showNoInternet) {
              showSnack(
                context: context,
                title: devExam.intl.of(context).fmt('attention.noConnection'),
                color: devExam.theme.errorBg,
              );
            } else {
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (
                    BuildContext context,
                    _,
                    __,
                  ) =>
                      CustomTestCategories(
                    userID: widget.userID,
                    snapshot: snapshot,
                    commingFromProfile: false,
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }

  Widget searchQuestionDropDown() {
    return SearchQuestionDropDown(
      child: DropdownButton(
        iconEnabledColor: devExam.theme.darkTestPurple,
        hint: Text(
          devExam.intl.of(context).fmt('category.searchByIndex'),
          style: TextStyle(color: devExam.theme.darkTestPurple),
        ),
        items: allQuestions.map((value) {
          return DropdownMenuItem(
            value: value,
            child: Text(
              '$value',
              style: TextStyle(
                color: devExam.theme.darkTestPurple,
                fontSize: 17.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }).toList(),
        onChanged: (value) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => GetJsonForTraining(
                id: devExam.intl.of(context).fmt('lang'),
                questionIndex: int.parse(value),
                userID: widget.userID,
                isAbleToSaveQ: isAbleToSaveQuestion(),
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white.withOpacity(.9),
      elevation: 0,
      leading: OpacityButton(
        opacityValue: .3,
        child: Icon(Icons.arrow_back_ios, color: Colors.black),
        onTap: () => Navigator.pop(context),
      ),
    );
  }

  Column categories() {
    return Column(
      children: [
        allQuestions.length > 1
            ? TestCategoriesCard(
                color: Color(0xffFF5551),
                title: devExam.intl.of(context).fmt('category.1'),
                fontSize: 21,
                textColor: Colors.white,
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => GetJsonForTraining(
                      id: devExam.intl.of(context).fmt('lang'),
                      questionIndex: 1,
                      userID: widget.userID,
                      isAbleToSaveQ: isAbleToSaveQuestion(),
                    ),
                  ),
                ),
              )
            : SizedBox(height: 0),
        allQuestions.length > 21
            ? TestCategoriesCard(
                color: Color(0xff2D56A1),
                title: devExam.intl.of(context).fmt('category.2'),
                fontSize: 20,
                textColor: Colors.white,
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => GetJsonForTraining(
                      id: devExam.intl.of(context).fmt('lang'),
                      questionIndex: 21,
                      userID: widget.userID,
                      isAbleToSaveQ: isAbleToSaveQuestion(),
                    ),
                  ),
                ),
              )
            : SizedBox(height: 0),
        allQuestions.length > 40
            ? TestCategoriesCard(
                color: Color(0xffEB7B00),
                title: devExam.intl.of(context).fmt('category.3'),
                fontSize: 21,
                textColor: Colors.white,
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => GetJsonForTraining(
                      id: devExam.intl.of(context).fmt('lang'),
                      questionIndex: 40,
                      userID: widget.userID,
                      isAbleToSaveQ: isAbleToSaveQuestion(),
                    ),
                  ),
                ),
              )
            : SizedBox(
                height: 0,
              ),
        allQuestions.length > 117
            ? TestCategoriesCard(
                color: Color(0xff6EC14D),
                title: devExam.intl.of(context).fmt('category.4'),
                fontSize: 21,
                textColor: Colors.white,
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => GetJsonForTraining(
                      id: devExam.intl.of(context).fmt('lang'),
                      questionIndex: 117,
                      userID: widget.userID,
                      isAbleToSaveQ: isAbleToSaveQuestion(),
                    ),
                  ),
                ),
              )
            : SizedBox(height: 0),
        allQuestions.length > 155
            ? TestCategoriesCard(
                color: Color(0xff2896FF),
                title: devExam.intl.of(context).fmt('category.5'),
                fontSize: 21,
                textColor: Colors.white,
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => GetJsonForTraining(
                      id: devExam.intl.of(context).fmt('lang'),
                      questionIndex: 155,
                      userID: widget.userID,
                      isAbleToSaveQ: isAbleToSaveQuestion(),
                    ),
                  ),
                ),
              )
            : SizedBox(height: 0),
        allQuestions.length > 164
            ? TestCategoriesCard(
                color: Color(0xFF4A56BE),
                title: devExam.intl.of(context).fmt('category.6'),
                fontSize: 21,
                textColor: Colors.white,
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => GetJsonForTraining(
                      id: devExam.intl.of(context).fmt('lang'),
                      questionIndex: 164,
                      userID: widget.userID,
                      isAbleToSaveQ: isAbleToSaveQuestion(),
                    ),
                  ),
                ),
              )
            : SizedBox(height: 0),
        allQuestions.length > 191
            ? TestCategoriesCard(
                color: Color(0xFF1F775D),
                title: devExam.intl.of(context).fmt('category.7'),
                fontSize: 21,
                textColor: Colors.white,
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => GetJsonForTraining(
                      id: devExam.intl.of(context).fmt('lang'),
                      questionIndex: 191,
                      userID: widget.userID,
                      isAbleToSaveQ: isAbleToSaveQuestion(),
                    ),
                  ),
                ),
              )
            : SizedBox(height: 0),
        allQuestions.length > 199
            ? TestCategoriesCard(
                color: Color(0xFF371F77),
                title: devExam.intl.of(context).fmt('category.8'),
                fontSize: 21,
                textColor: Colors.white,
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => GetJsonForTraining(
                      id: devExam.intl.of(context).fmt('lang'),
                      questionIndex: 199,
                      userID: widget.userID,
                      isAbleToSaveQ: isAbleToSaveQuestion(),
                    ),
                  ),
                ),
              )
            : SizedBox(height: 0),
        allQuestions.length > 291
            ? TestCategoriesCard(
                color: Color(0xFFC72159),
                title: devExam.intl.of(context).fmt('category.9'),
                fontSize: 21,
                textColor: Colors.white,
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => GetJsonForTraining(
                      id: devExam.intl.of(context).fmt('lang'),
                      questionIndex: 291,
                      userID: widget.userID,
                      isAbleToSaveQ: isAbleToSaveQuestion(),
                    ),
                  ),
                ),
              )
            : SizedBox(height: 0),
        allQuestions.length > 311
            ? TestCategoriesCard(
                color: Color(0xFF6AA300),
                title: devExam.intl.of(context).fmt('category.10'),
                fontSize: 21,
                textColor: Colors.white,
                onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => GetJsonForTraining(
                      id: devExam.intl.of(context).fmt('lang'),
                      questionIndex: 311,
                      userID: widget.userID,
                      isAbleToSaveQ: isAbleToSaveQuestion(),
                    ),
                  ),
                ),
              )
            : SizedBox(height: 0),
      ],
    );
  }
}
