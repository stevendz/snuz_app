import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snuz_app/l10n/app_localizations.dart';
import 'package:snuz_app/main.dart';

class LocaleProvider with ChangeNotifier {
  Locale _locale;

  LocaleProvider(this._locale);

  Locale get locale => _locale;

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;

    _locale = locale;

    // Update the global l10n variable
    l10n = await AppLocalizations.delegate.load(locale);

    // Save to preferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', locale.languageCode);

    notifyListeners();
  }

  static Future<LocaleProvider> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final localeCode = prefs.getString('locale') ?? 'en';
    final locale = Locale(localeCode);

    // Load the initial l10n
    l10n = await AppLocalizations.delegate.load(locale);

    return LocaleProvider(locale);
  }
}
