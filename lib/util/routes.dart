import 'package:amiidex/UI/views/amiibo.dart';
import 'package:amiidex/UI/views/privacy.dart';
import 'package:amiidex/UI/views/settings.dart';
import 'package:amiidex/UI/views/splash.dart';
import 'package:amiidex/application.dart';
import 'package:amiidex/main.dart';
import 'package:amiidex/services/assets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Routes {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        final AssetsService assetsService = locator<AssetsService>();
        if (assetsService.isLineupLoaded == false) {
          return materialRoute(SplashView(), settings);
        }
        return materialRoute(const HomeView(config: null), settings);
      case '/home':
        return materialRoute(HomeView(config: settings.arguments), settings);
      case '/settings':
        return materialRoute(SettingsView(), settings);
      case '/privacy':
        return materialRoute(PrivacyView(), settings);
      case '/amiibo':
        return cupertinoRoute(AmiiboView(amiibo: settings.arguments), settings);
      default:
        return null;
    }
  }
}

CupertinoPageRoute<void> cupertinoRoute(
  Widget builder,
  RouteSettings settings,
) {
  return CupertinoPageRoute<void>(
    builder: (BuildContext context) => builder,
    settings: settings,
  );
}

MaterialPageRoute<void> materialRoute(
  Widget builder,
  RouteSettings settings,
) {
  return MaterialPageRoute<void>(
    builder: (BuildContext context) => builder,
    settings: settings,
  );
}
