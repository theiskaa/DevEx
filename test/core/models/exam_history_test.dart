import 'package:devexam/core/models/exam_history.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  ExamHistory examHistory;

  const Map<String, String> examHistoryJson = {
    'correctAnswersCount': '7',
    'incorrectAnswersCount': '3',
    'date': '13/4/21',
    'personId': 'theiskaa',
  };

  setUpAll(() {
    // Initilaze [examHistory].
    examHistory = ExamHistory(
      correctAnswersCount: '7',
      incorrectAnswersCount: '3',
      date: '13/4/21',
      person: 'theiskaa',
    );
  });

  group('[ExamHistory]', () {
    test('converts from json correctly', () {
      final examHistoryJsonFromJson = ExamHistory.fromJson(examHistoryJson);

      // Need to match properties rather than instances.
      expect(
        examHistory.correctAnswersCount,
        examHistoryJsonFromJson.correctAnswersCount,
      );
      expect(
        examHistory.incorrectAnswersCount,
        examHistoryJsonFromJson.incorrectAnswersCount,
      );
      expect(examHistory.date, examHistoryJsonFromJson.date);
      expect(examHistory.person, examHistoryJsonFromJson.person);
    });

    test('converts to json correctly', () {
      final examHistoryToJson = examHistory.toJson();

      expect(examHistoryJson, examHistoryToJson);
    });
  });
}
