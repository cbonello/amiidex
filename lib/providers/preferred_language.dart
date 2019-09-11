import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:amiidex/main.dart';
import 'package:amiidex/services/local_storage.dart';
import 'package:amiidex/util/i18n.dart';

// Language displayed in UI.
class PreferredLanguageProvider with ChangeNotifier {
  PreferredLanguageProvider() {
    _locale = storageService.getPreferredLanguage();
  }

  final LocalStorageService storageService = locator<LocalStorageService>();
  final GeneratedLocalizationsDelegate i18n = I18n.delegate;
  String _locale;

  Locale get locale {
    final List<String> codes = _locale.split('_');
    assert(codes.length == 2);
    return Locale(codes[0], codes[1]);
  }

  set language(String newLanguage) {
    _locale = newLanguage;
    storageService.setPreferredLanguage(_locale);
    notifyListeners();
    // i18n.load(locale).then(
    //   (WidgetsLocalizations l) {
    //     storageService.setPreferredLanguage(_locale);
    //     notifyListeners();
    //   },
    // );
  }
}
