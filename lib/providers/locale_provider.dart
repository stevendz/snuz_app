import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale = const Locale('en', '');

  Locale get locale => _locale;

  void setLocale(Locale newLocale) {
    if (newLocale != _locale) {
      _locale = newLocale;
      notifyListeners();
    }
  }

  void initLocale() {
    _locale = const Locale('en', '');
  }
}
