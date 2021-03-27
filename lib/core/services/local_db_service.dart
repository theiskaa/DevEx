import 'package:shared_preferences/shared_preferences.dart';

///Box keys which were in localDb.
class LocalDbKeys {
  LocalDbKeys._();
  static const String suggestionListKey = "suggestionsList";
  static const String languageCode = 'languageCode';
}

/// Custom service class for controlle local database.
class LocalDbService {
  static LocalDbService _instance;
  static SharedPreferences _preferences;

  static LocalDbService get localDbServiceInstance {
    return LocalDbService._internal();
  }

  LocalDbService._internal();

  /// The instace getter for [LocalDbService].
  static Future<LocalDbService> get instance async {
    if (_instance == null) {
      _instance = LocalDbService._internal();
    }

    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }

    return _instance;
  }

  /// Set language code by `langCode`
  Future<void> setLanguage(String langCode) =>
      _preferences.setString(LocalDbKeys.languageCode, langCode);

  /// Get saved language code
  String get languageCode => _preferences.getString(LocalDbKeys.languageCode);

  /// For Save new email suggestion to local database.
  Future<void> saveSuggestionList(List<String> newSuggestions) async {
    List<String> defaultList =
        _preferences.getStringList(LocalDbKeys.suggestionListKey);
    if (defaultList != newSuggestions) {
      await _preferences.setStringList(
          LocalDbKeys.suggestionListKey, newSuggestions);
      print("Suggestion Saved!");
    } else {
      print("Can't save suggestion");
    }
  }

  /// Get current list which were saved in db.
  Future<List<String>> getDbList() async {
    List<String> list =
        _preferences.getStringList(LocalDbKeys.suggestionListKey);
    return list;
  }
}
