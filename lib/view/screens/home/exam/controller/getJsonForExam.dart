import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../widgets/components/loading.dart';
import '../../../../widgets/components/widgets.dart';
import '../views/exam.dart';

class GetJsonForExam extends DevExamStatefulWidget {
  final userID;
  GetJsonForExam({Key key, @required this.userID}) : super(key: key);

  @override
  _GetJsonForExamState createState() => _GetJsonForExamState();
}

class _GetJsonForExamState extends DevExamState<GetJsonForExam> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString(
        "assets/json/${devExam.intl.of(context).fmt('lang')}.json",
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Loading();
        } else {
          if (snapshot.hasError) {
            return buildErrorText(context);
          } else {
            if (snapshot.hasData) {
              List data = jsonDecode(snapshot.data.toString());
              var random = Random();
              var dataLength =
                  (data == null) ? 166 : data[0].keys.toList().length;
              List cuttedData = [{}, {}];

              for (int i = 1; i < 11; i++) {
                var qi = random.nextInt(dataLength);
                if (cuttedData[0].containsKey(qi)) {
                  var newQi = random.nextInt(data[0].keys.toList().length);
                  cuttedData[0].putIfAbsent(
                    "$i",
                    () => data[0][qi.toString()] ?? data[0][newQi.toString()],
                  );
                  cuttedData[1].putIfAbsent(
                    "$i",
                    () => data[1][qi.toString()] ?? data[1][newQi.toString()],
                  );
                } else {
                  cuttedData[0].putIfAbsent("$i", () => data[0][qi.toString()]);
                  cuttedData[1].putIfAbsent("$i", () => data[1][qi.toString()]);
                }
              }

              if (cuttedData == null ||
                  data == null ||
                  data[0] == null ||
                  data[1] == null) {
                return Loading();
              } else {
                return ExamScreen(
                  userID: widget.userID,
                  data: cuttedData,
                );
              }
            } else {
              return buildSnapErrorText(context);
            }
          }
        }
      },
    );
  }

  Container buildSnapErrorText(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Text(
        devExam.intl.of(context).fmt('authStatus.undefined'),
        style: TextStyle(
          color: devExam.theme.errorBg,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Container buildErrorText(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Text(
        devExam.intl.of(context).fmt('message.somethingWentWrongg'),
        style: TextStyle(
          color: devExam.theme.errorBg,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
