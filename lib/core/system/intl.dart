import 'dart:convert';
import 'dart:async' show Future;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

enum Lang { RUS, EN }

class Intl {
  Locale locale;

  Map<String, String> localizedValues;

  List<String> supportedLocales;

  IntlDelegate get delegate => const IntlDelegate();

  Intl of(BuildContext context) => Localizations.of<Intl>(context, Intl);

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

  Future<Map<String, dynamic>> load() async {
    final String jsonString = await rootBundle
        .loadString('assets/languages/${locale.languageCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    this.localizedValues = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    return this.localizedValues;
  }
}

@immutable
class IntlDelegate extends LocalizationsDelegate<Intl> {
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
