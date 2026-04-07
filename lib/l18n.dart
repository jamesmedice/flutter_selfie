import 'dart:async';
import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;
  final Logger _logger = Logger();

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  late Map<String, String> _localizedStrings;

Future<bool> load() async {
  try {
    final String jsonString = await rootBundle.loadString('assets/i18n/${locale.languageCode}.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      _logger.i('Key: $key, Value: ${value.toString()}');
      return MapEntry(key, value.toString());
    });

    return true;
  } catch (e) {
    _logger.i('Error loading localization: $e');
    return false;
  }
}

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  final Locale defaultLocale;

  const AppLocalizationsDelegate({required this.defaultLocale});

  @override
  bool isSupported(Locale locale) {
    return ['en', 'it'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);

    // Try to load the specified language
    if (await localizations.load()) {
      return localizations;
    }

    // Fallback to the default language
    localizations = AppLocalizations(defaultLocale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}

