import 'package:devexam/core/system/devexam.dart';
import 'package:devexam/core/system/intl.dart';
import 'package:devexam/core/system/themes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  DevExam devExam;

  setUpAll(() => devExam = DevExam());

  group('[DevExam]', () {
    test('Intl and Themes', () {
      devExam.intl = Intl();
      devExam.theme = Themes();

      expect(devExam.intl, isNotNull);
      expect(devExam.theme, isNotNull);
    });
  });
}
