import 'package:devexam/core/services/local_db_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

main() {
  group('[LocalDbService]', () {
    SharedPreferences.setMockInitialValues({
      LocalDbKeys.darkTheme: false,
      LocalDbKeys.fieldSearchEnabled: false,
      LocalDbKeys.languageCode: 'az',
      LocalDbKeys.suggestionListKey: [],
      LocalDbKeys.scrollSearchEnabled: true,
    });

    test('set and get setted language', () async {
      var localDbServiceInstence = await LocalDbService.instance;
      await localDbServiceInstence.setLanguage('ru');
      expect(localDbServiceInstence.languageCode, 'ru');
    });

    test('set and get setted theme', () async {
      var localDbServiceInstence = await LocalDbService.instance;
      await localDbServiceInstence.setTheme(isDark: true);
      expect(await localDbServiceInstence.getTheme(), await Future.value(true));
    });

    test('set and get setted custom bool value (fieldSearchEnabled)', () async {
      var localDbServiceInstence = await LocalDbService.instance;
      await localDbServiceInstence.setValue(
          LocalDbKeys.fieldSearchEnabled, true);
      expect(
        await localDbServiceInstence.getValue(LocalDbKeys.fieldSearchEnabled),
        await Future.value(true),
      );
    });

    test('set and get setted custom bool value (scrollSearchEnabled)',
        () async {
      var localDbServiceInstence = await LocalDbService.instance;
      await localDbServiceInstence.setValue(
          LocalDbKeys.scrollSearchEnabled, false);
      expect(
        await localDbServiceInstence.getValue(LocalDbKeys.scrollSearchEnabled),
        await Future.value(false),
      );
    });

    test('set and get setted suggestion list', () async {
      var localDbServiceInstence = await LocalDbService.instance;
      await localDbServiceInstence
          .saveSuggestionList(['test@gmail.com', 'test12@gmail.com']);
      expect(
        await localDbServiceInstence.getDbList(),
        await Future.value(['test@gmail.com', 'test12@gmail.com']),
      );
    });
  });
}
