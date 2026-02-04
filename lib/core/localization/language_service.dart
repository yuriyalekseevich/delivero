import 'dart:ui';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@singleton
class LanguageService {
  static const String _languageKey = 'selected_language';
  static const String _defaultLanguage = 'en';

  final SharedPreferences _prefs;

  LanguageService(this._prefs);

  String get currentLanguage {
    return _prefs.getString(_languageKey) ?? _defaultLanguage;
  }

  Locale get currentLocale {
    return Locale(currentLanguage);
  }

  Future<void> setLanguage(String languageCode) async {
    await _prefs.setString(_languageKey, languageCode);
  }

  List<Locale> get supportedLocales {
    return const [
      Locale('en'),
      Locale('es'),
    ];
  }

  String getLanguageDisplayName(String languageCode) {
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      default:
        return 'English';
    }
  }

  bool isLanguageSupported(String languageCode) {
    return supportedLocales.any((locale) => locale.languageCode == languageCode);
  }
}
