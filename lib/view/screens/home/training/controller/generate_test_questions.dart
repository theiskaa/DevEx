import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../widgets/components/loading.dart';
import '../../../../widgets/components/widgets.dart';
import '../view/training.dart';

class GenerateTestQuestions extends DevExamStatelessWidget {
  final String id;
  final int questionIndex;
  final userID;
  final bool isAbleToSaveQ;

  GenerateTestQuestions({
    Key key,
    this.id,
    this.questionIndex,
    @required this.userID,
    this.isAbleToSaveQ,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DefaultAssetBundle.of(context).loadString("assets/json/$id.json"),
      builder: (context, snapshot) {
        List data = jsonDecode(snapshot.data.toString());
        if (data == null) {
          return Loading();
        } else {
          return TrainingScreen(
            data: data,
            questionIndex: questionIndex,
            userID: userID,
            isAbleToSaveQ: isAbleToSaveQ,
          );
        }
      },
    );
  }
}
