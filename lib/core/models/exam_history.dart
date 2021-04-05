import 'package:flutter/material.dart';

class ExamHistory {
  String correctAnswersCount;
  String incorrectAnswersCount;
  String date;
  String person;

  ExamHistory(
      {@required this.correctAnswersCount,
      @required this.incorrectAnswersCount,
      @required this.date,
      @required this.person})
      : assert(correctAnswersCount != null),
        assert(incorrectAnswersCount != null),
        assert(date != null),
        assert(person != null);

  ExamHistory.fromJson(Map<String, dynamic> json) {
    correctAnswersCount = json['correctAnswersCount'];
    incorrectAnswersCount = json['incorrectAnswersCount'];
    date = json['date'];
    person = json['personID'];
  }

  Map<String, dynamic> toJson() {
    final data = Map<String, dynamic>();
    data['correctAnswersCount'] = this.correctAnswersCount;
    data['incorrectAnswersCount'] = this.incorrectAnswersCount;
    data['date'] = this.date;
    data['personId'] = this.person;

    return data;
  }
}
