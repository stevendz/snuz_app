import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  LocaleProvider({required this.prefs});
  final SharedPreferences prefs;

  late Locale _locale;

  Locale get locale => _locale;

  void init() {
    final String? languageCode = prefs.getString('languageCode');
    _locale = Locale(languageCode ?? 'en');
    notifyListeners();
  }

  void setLocale(Locale newLocale) {
    if (newLocale != _locale) {
      _locale = newLocale;
      prefs.setString('languageCode', newLocale.languageCode);
      notifyListeners();
    }
  }
}
