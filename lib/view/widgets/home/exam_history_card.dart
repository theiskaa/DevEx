import 'package:devexam/core/blocs/theme/theme_bloc.dart';
import 'package:devexam/view/widgets/components/3d_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      decoration: buildDecoration(context),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
                    buildDateTitel(context),
                  ],
                )
              : buildDateTitel(context),
        ],
      ),
    );
  }

  Container buildDateTitel(BuildContext context) {
    return Container(
      alignment: Alignment.centerRight,
      child: Text(
        "$date",
        style: TextStyle(
          color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                  devExam.theme.dark
              ? Colors.white
              : devExam.theme.darkTestPurple,
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
              color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                      devExam.theme.dark
                  ? Colors.white.withOpacity(.7)
                  : Colors.black.withOpacity(.7),
              fontSize: isRussian(context) ? 14.0 : 16,
              fontWeight: FontWeight.w400,
            ),
            children: [
              TextSpan(
                text: "$item",
                style: TextStyle(
                  color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                          devExam.theme.dark
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.w800,
                ),
              )
            ],
          ),
        ),
      );

  BoxDecoration buildDecoration(BuildContext context) => BoxDecoration(
        color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                devExam.theme.dark
            ? Color(0xFF070707)
            : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            spreadRadius: .3,
            color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                    devExam.theme.dark
                ? Colors.white.withOpacity(.1)
                : Colors.black.withOpacity(.5),
            blurRadius: 15,
            offset: Offset(0, 8),
          ),
        ],
      );
}
