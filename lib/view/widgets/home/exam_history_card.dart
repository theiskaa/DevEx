import 'package:flutter/material.dart';
import 'package:flutter_button/flutter_button.dart';

import '../../../core/utils/perceptive.dart';
import '../../screens/home/exam/views/exam_review.dart';
import '../components/widgets.dart';

class ExamHistoryCard extends DevExamStatelessWidget {
  final String correctAnswersCount;
  final String incorrectAnswersCount;
  final String date;
  final double size;
  final String langType;
  final List<dynamic> incorrectAnswersList;
  final bool noInternet;

  ExamHistoryCard({
    Key key,
    this.correctAnswersCount,
    this.incorrectAnswersCount,
    this.date,
    this.size,
    this.langType,
    this.incorrectAnswersList,
    this.noInternet,
  }) : super(key: key);

  bool isRussian(BuildContext context) {
    if ("${devExam.intl.of(context).fmt('lang')}" == "ru") {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size != null ? size : MediaQuery.of(context).size.width - 30,
      decoration: buildDecoration(),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: buildButtonBody(context),
    );
  }

  Center buildButtonBody(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          buildCardTitles(context),
          incorrectAnswersCount != "0"
              ? SizedBox(height: 10)
              : SizedBox(height: 0),
          incorrectAnswersCount != "0"
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildReviewButton(context),
                    buildDateTitel(),
                  ],
                )
              : buildDateTitel(),
        ],
      ),
    );
  }

  Container buildDateTitel() {
    return Container(
      alignment: Alignment.centerRight,
      child: Text(
        "$date",
        style: TextStyle(
          color: Color(0xFF220052),
          fontSize: 11.0.fP,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Button3D buildReviewButton(BuildContext context) {
    return Button3D(
      height: 40,
      width: 190,
      style: StyleOf3dButton(
        topColor: Colors.grey[850],
        backColor: devExam.theme.accentTestPurple.withOpacity(.7),
      ),
      child: Center(
        child: Text(
          "${devExam.intl.of(context).fmt('examResult.reviewIncorrectAnswers')}",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      onPressed: () {
        if (noInternet) {
          print("no internet");
        } else {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => ExamReview(
                data: incorrectAnswersList,
                questionIndex: 1,
              ),
            ),
          );
        }
      },
    );
  }

  Column buildCardTitles(BuildContext context) {
    return Column(
      children: [
        buildTitle(
          "${devExam.intl.of(context).fmt('examResult.correctAnswers')}",
          correctAnswersCount,
          context,
        ),
        buildTitle(
          "${devExam.intl.of(context).fmt('examResult.incorrectAnswers')}",
          incorrectAnswersCount,
          context,
        ),
        SizedBox(height: 3),
        buildTitle(
          "${devExam.intl.of(context).fmt('examResult.langType')}",
          langType,
          context,
        ),
      ],
    );
  }

  Container buildTitle(String title, String item, BuildContext context) =>
      Container(
        alignment: Alignment.topLeft,
        child: RichText(
          text: TextSpan(
            text: "$title: ",
            style: TextStyle(
              color: Colors.black.withOpacity(.5),
              fontSize: isRussian(context) ? 14.0 : 16,
              fontWeight: FontWeight.w600,
            ),
            children: [
              TextSpan(
                text: "$item",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              )
            ],
          ),
        ),
      );

  BoxDecoration buildDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            spreadRadius: .3,
            color: Colors.black.withOpacity(.5),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      );
}
