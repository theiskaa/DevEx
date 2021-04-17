import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

enum Lang { RUS, EN }

/// Internationalization class
/// @param locale name/code of language
class Intl {
  // Intl(this.locale);
  // Current locale.
  Locale locale;

  // Json parsed key-values.
  Map<String, String> localizedValues;

  // Supported Locales.
  List<String> supportedLocales;

  // Intl delegation shortcut.
  IntlDelegate get delegate => const IntlDelegate();

  // Helper method to keep the code in the widgets concise.
  // Localizations are accessed using an InheritedWidget "of" syntax.
  Intl of(BuildContext context) => Localizations.of<Intl>(context, Intl);

  // This variadic method will be called from every widget which.
  // Needs a localized (formatted) text
  String fmt(String key, [List<dynamic> args]) {
    if (args == null || args.length < 1)
      return this.localizedValues[key] ?? key;

    int _idx;
    String formatted = this.localizedValues[key].replaceAllMapped(
        RegExp(r'\%[0-9]{1,3}', multiLine: true), (Match match) {
      _idx = int.parse(match[0].substring(1)) - 1;

      return (args.asMap()[_idx] ?? match[0]).toString();
    });

    return formatted;
  }

  // Load the language JSON file from the "assets/i18n" folder.
  Future<Map<String, dynamic>> load() async {
    final String jsonString = await rootBundle
        .loadString('assets/languages/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    // Convert json values to string.
    this.localizedValues = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    return this.localizedValues;
  }
}

// LocalizationsDelegate is a factory for a set of localized resources.
// In this case, the localized strings will be gotten in an Intl object.
@immutable
class IntlDelegate extends LocalizationsDelegate<Intl> {
  // This delegate instance will never change (it doesn't even have fields!).
  // It can provide a constant constructor.
  const IntlDelegate();

  @override
  bool isSupported(Locale locale) => ['ru', 'en'].contains(locale.languageCode);

  @override
  Future<Intl> load(Locale locale) async {
    final Intl intl = Intl();
    intl.locale = locale;
    await intl.load();
    return intl;
  }

  @override
  bool shouldReload(IntlDelegate old) => false;
}
