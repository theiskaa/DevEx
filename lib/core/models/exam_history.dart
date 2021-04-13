import 'package:devexam/core/system/devexam.dart';
import 'package:flutter/material.dart';

class ExamHistory implements DevExModel {
  final String correctAnswersCount;
  final String incorrectAnswersCount;
  final String date;
  final String person;

  const ExamHistory(
      {@required this.correctAnswersCount,
      @required this.incorrectAnswersCount,
      @required this.date,
      @required this.person})
      : assert(correctAnswersCount != null),
        assert(incorrectAnswersCount != null),
        assert(date != null),
        assert(person != null);

  ExamHistory.fromJson(Map<String, dynamic> json)
      : correctAnswersCount = json['correctAnswersCount'],
        incorrectAnswersCount = json['incorrectAnswersCount'],
        date = json['date'],
        person = json['personId'];

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['correctAnswersCount'] = this.correctAnswersCount;
    data['incorrectAnswersCount'] = this.incorrectAnswersCount;
    data['date'] = this.date;
    data['personId'] = this.person;

    return data;
  }
}
