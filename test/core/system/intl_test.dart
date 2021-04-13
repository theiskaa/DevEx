import 'package:devexam/core/system/intl.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // The classes that are to be tested.
  Intl intl;
  IntlDelegate intlDelegate;

  // Pre-defined constant values intended for testing purposes (dependencies).
  const locale = Locale('en');
  const supportedLanguageCodes = ['en', 'ru'];
  const unsupportedLocale = Locale('unsupported');
  const testLocalizedKey = 'error';

  // Initializing the classes that are to be tested right before the test run.
  setUpAll(() {
    intl = Intl();
    intlDelegate = IntlDelegate();
  });

  // Main group consisting of all things related to Intl class.
  group('[Intl]', () {
    // Function that loads the translation file contents to memory
    // and assigns it to _intl's localizedValues property.
    Future<void> testIntlLoad() async {
      // The .load() method depends on _intl's locale property.
      intl.locale = locale;

      // A way to ensure that the .load() method will work during the test.
      TestWidgetsFlutterBinding.ensureInitialized();

      // Setting the translation file contents to _intl.localizedValues.
      intl.localizedValues = await intl.load();
    }

    // Verifying that Intl has the following default property values.
    test('has expected default property values', () {
      expect(intl, isA<Intl>());
      expect(intl.delegate, isA<IntlDelegate>());
      expect(intl.locale, isNull);
      expect(intl.localizedValues, isNull);
      expect(intl.supportedLocales, isNull);
      expect(intl.runtimeType, Intl);
    });

    // Verifying that Intl returns localized text.
    test('returns localized (formatted) text as defined', () async {
      // Loading the translation file contents.
      await testIntlLoad();

      // Verifying the .fmt() method.
      expect(intl.fmt(testLocalizedKey), testLocalizedKey);
    });

    // Verifying that Intl loads the translation file contents.
    test('loads the language JSON file as defined', () async {
      // Loading the translation file contents.
      await testIntlLoad();

      // Verifying that the localizedValues is not empty.
      expect(intl.localizedValues.isNotEmpty, true);
    });
  });

  // Main group consisting of all things related to IntlDelegate class.
  group('[IntlDelegate]', () {
    // Verifying that IntlDelegate has the following default property values.
    test('has expected default property values', () {
      expect(intlDelegate, isA<IntlDelegate>());
      expect(intlDelegate, isA<LocalizationsDelegate>());
      expect(intlDelegate.runtimeType, IntlDelegate);
    });

    // Verifying that IntlDelegate supports specific locales.
    test('checks if specific locale is supported', () {
      // Iterating over language codes and verifying that the locales
      // that have the aforementioned language code as the primary argument
      // are indeed supported by the IntlDelegate.
      supportedLanguageCodes.forEach((languageCode) => expect(
            intlDelegate.isSupported(Locale(languageCode)),
            true,
          ));

      // Verifying that any other locales aren't supported.
      expect(intlDelegate.isSupported(unsupportedLocale), false);
    });

    // Verifying that IntlDelegate loads the translation file contents.
    test('loads the language JSON file as defined', () async {
      // Loading the translation file contents.
      intl = await intlDelegate.load(locale);

      // Verifying that the localizedValues is not empty.
      expect(intl.fmt(testLocalizedKey), testLocalizedKey);
    });

    // Verifying that IntlDelegate checks correctly if it should reload.
    test(
      'checks if it should reload',
      () => expect(intlDelegate.shouldReload(intlDelegate), false),
    );
  });
}
