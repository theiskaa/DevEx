import 'package:devexam/core/system/devexam.dart';
import 'package:devexam/core/system/intl.dart';
import 'package:devexam/core/system/themes.dart';
import 'package:flutter_test/flutter_test.dart';

import '../models/exam_history_test.dart' as exam_history_test;
import '../models/user_test.dart' as user_test;

void main() {
  DevExam devExam;

  // For DevExModel.
  exam_history_test.main();
  user_test.main();

  setUpAll(() {
    devExam = DevExam();
  });

  group('[DevExam]', () {
    test('Intl and Themes', () {
      devExam.intl = Intl();
      devExam.theme = Themes();

      expect(devExam.intl, isNotNull);
      expect(devExam.theme, isNotNull);
    });
  });
}
