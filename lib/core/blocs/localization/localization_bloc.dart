import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../services/local_db_service.dart';
import '../../system/intl.dart';

part 'localization_event.dart';
part 'localization_state.dart';

class LocalizationBloc extends Bloc<LocalizationEvent, LocalizationState> {
  LocalizationBloc() : super(LocalizationState(Locale('en', 'UK')));

  @override
  Stream<LocalizationState> mapEventToState(
    LocalizationEvent event,
  ) async* {
    if (event is LocalizationStarted) {
      yield* _mapEventForLocalizationStarted();
    } else if (event is LocalizationSuccess) {
      yield* _mapEventForLocalizationSuccess(event.langCode);
    }
  }

  Stream<LocalizationState> _mapEventForLocalizationStarted() async* {
    Locale locale;
    final _dbService = await LocalDbService.instance;
    final defaultLanguageCode = _dbService.languageCode;
    if (defaultLanguageCode == null) {
      locale = Locale('en', 'UK');
      await _dbService.setLanguage(locale.languageCode);
    } else {
      locale = Locale(defaultLanguageCode);
    }

    yield LocalizationState(locale);
  }

  Stream<LocalizationState> _mapEventForLocalizationSuccess(
    Lang selectedLang,
  ) async* {
    final _dbService = await LocalDbService.instance;
    if (selectedLang == Lang.EN) {
      yield* _setAndLoadLang(
        localDbService: _dbService,
        languageCode: 'en',
        countryCode: 'UK',
      );
    } else if (selectedLang == Lang.RUS) {
      yield* _setAndLoadLang(
        localDbService: _dbService,
        languageCode: 'ru',
        countryCode: 'RU',
      );
    }
  }

  Stream<LocalizationState> _setAndLoadLang({
    LocalDbService localDbService,
    String languageCode,
    String countryCode,
  }) async* {
    final locale = Locale(languageCode, countryCode);
    await localDbService.setLanguage(locale.languageCode);
    yield LocalizationState(locale);
  }
}

// rX5<5Ab%U@AU+%-u
