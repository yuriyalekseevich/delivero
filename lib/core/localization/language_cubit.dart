import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'language_service.dart';

@injectable
class LanguageCubit extends Cubit<Locale> {
  final LanguageService _languageService;

  LanguageCubit(this._languageService) : super(const Locale('en')) {
    _initializeLanguage();
  }

  void _initializeLanguage() {
    emit(_languageService.currentLocale);
  }

  Future<void> changeLanguage(String languageCode) async {
    if (!_languageService.isLanguageSupported(languageCode)) {
      return;
    }

    await _languageService.setLanguage(languageCode);
    emit(Locale(languageCode));
  }

  String get currentLanguageCode => _languageService.currentLanguage;

  List<Locale> get supportedLocales => _languageService.supportedLocales;

  String getLanguageDisplayName(String languageCode) {
    return _languageService.getLanguageDisplayName(languageCode);
  }
}
