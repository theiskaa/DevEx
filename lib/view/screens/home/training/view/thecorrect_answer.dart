import 'package:flutter/material.dart';

import '../../../../../core/utils/ui.dart';
import '../../../../widgets/components/widgets.dart';

class TheCorrectAnswer extends DevExamStatefulWidget {
  final data;
  final int i;

  TheCorrectAnswer({
    Key key,
    this.data,
    this.i,
  }) : super(key: key);

  @override
  _TheCorrectAnswerState createState() =>
      _TheCorrectAnswerState(data: data, i: i);
}

class _TheCorrectAnswerState extends DevExamState<TheCorrectAnswer> {
  var data;
  int i;

  _TheCorrectAnswerState({
    this.data,
    this.i,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(.9),
      appBar: buildAppBar(context),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 80),
            buildDes(),
            SizedBox(height: 30),
            divider(),
            SizedBox(height: 30),
            buildAnswers(),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Column buildAnswers() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${devExam.intl.of(context).fmt('test.answer')}: ",
          style: TextStyle(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.w800,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text:
                  "${data[1][i.toString()]["answerByLetter"].toString().toUpperCase()}: ",
              style: TextStyle(
                fontSize: 25,
                color: Colors.black,
                fontWeight: FontWeight.w800,
              ),
              children: [
                TextSpan(
                  text: data[1][i.toString()]["answer"].toString(),
                  style: TextStyle(
                    fontSize: 23,
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  Column buildDes() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${devExam.intl.of(context).fmt('test.des')}: ",
          style: TextStyle(
            color: Colors.black,
            fontSize: 30,
            fontWeight: FontWeight.w800,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Text(
            data[1][i.toString()]["des"],
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        )
      ],
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.clear,
          color: Colors.black,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      backgroundColor: Colors.white.withOpacity(.9),
    );
  }
}
